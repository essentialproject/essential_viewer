<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
    <xsl:import href="../common/core_strategic_plans.xsl"/>
    <xsl:include href="../common/core_doctype.xsl"/>
    <xsl:include href="../common/core_common_head_content.xsl"/>
    <xsl:include href="../common/core_header.xsl"/>
    <xsl:include href="../common/core_footer.xsl"/>
    <xsl:include href="../common/core_handlebars_functions.xsl"/>
    <xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:include href="../common/datatables_includes.xsl"/> 
    
    <xsl:include href="../integration/core_il_plans.xsl"/>
    
    <xsl:param name="param1" /> 
    
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes" use-character-maps="c-1replace"/>
    <xsl:variable name="allInfoUsages" select="/node()/simple_instance[type='Information_View_Usage_in_Process']"/>
    <xsl:key name="infoViews" match="/node()/simple_instance[type='Information_View']" use="name"/>
    <xsl:variable name="allProcessActivityUsages" select="/node()/simple_instance[type=('Business_Activity_Usage','Business_Process_Usage')]"/>
 
    
  	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Role', 'Business_Capability', 'Group_Actor', 'Individual_Actor', 'Site','Composite_Application_Service', 'Application_Service', 'Project', 'Enterprise_Strategic_Plan', 'Application_Strategic_Plan', 'Technology_Strategic_Plan', 'Information_Strategic_Plan', 'Composite_Application_Provider', 'Application_Provider', 'Information_Concept', 'Information_View', 'Business_Strategic_Plan')"/>
    <xsl:variable name="apiPathProcessesAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"/>
    <xsl:variable name="apiPathPhysProcessesAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
   	<xsl:variable name="instanceData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Instance']"></xsl:variable>

    <xsl:variable name="pageLabel">
        <xsl:value-of select="eas:i18n('Business Process Summary')" />
    </xsl:variable>
    <xsl:key name="overallCurrencyDefault" match="/node()/simple_instance[type='Report_Constant']" use="own_slot_value[slot_reference = 'name']/value"/>
    <xsl:variable name="overallCurrencyDefault" select="key('overallCurrencyDefault', 'Default Currency')"/> 
	<xsl:variable name="currency" select="/node()/simple_instance[type='Currency'][name=$overallCurrencyDefault/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>
	<xsl:variable name="isEIPMode">
 		<xsl:choose>
 			<xsl:when test="$eipMode = 'true'">true</xsl:when>
 			<xsl:otherwise>false</xsl:otherwise>
 		</xsl:choose>
 	</xsl:variable>
    <xsl:template match="knowledge_base">
        <xsl:variable name="apiPathProcesses">
            <xsl:call-template name="GetViewerAPIPath">
               <xsl:with-param name="apiReport" select="$apiPathProcessesAPI"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathPhysProcesses">
            <xsl:call-template name="GetViewerAPIPath">
               <xsl:with-param name="apiReport" select="$apiPathPhysProcessesAPI"/>
            </xsl:call-template>
         </xsl:variable>
        <xsl:variable name="apiInstance">
			<xsl:call-template name="GetViewerAPIPathText">
				<xsl:with-param name="apiReport" select="$instanceData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
        <xsl:call-template name="docType" />
        <html>
            <head>
                <xsl:call-template name="commonHeadContent" />
                
                <xsl:call-template name="RenderModalReportContent">
                    <xsl:with-param name="essModalClassNames" select="$linkClasses" />
                </xsl:call-template>
                
                <!-- Generate links of all related classes -->
                <xsl:for-each select="$linkClasses">
                    <xsl:call-template name="RenderInstanceLinkJavascript">
                        <xsl:with-param name="instanceClassName" select="current()" />
                        <xsl:with-param name="targetMenu" select="()" />
                    </xsl:call-template>
                </xsl:for-each>
                
                <link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css" type="text/css" rel="stylesheet"></link>
                <script src="js/chartjs/Chart.min.js"></script>
				<script src="js/chartjs/chartjs-plugin-labels.min.js"></script>
				<link href="js/chartjs/Chart.css" type="text/css" rel="stylesheet"></link>
                <link href="business/core_bl_bus_process_summary.css" type="text/css" rel="stylesheet"></link>
                
                <title>
                    <xsl:value-of select="$pageLabel" />
                </title>
                
                <script src="js/d3/d3.v5.9.7.min.js"></script>
                <xsl:if test="$isEIPMode='true'">
				<script type="text/javascript" src="editors/assets/js/joint-plus/package/joint-plus.js"></script>
				<script src="editors/configurable/sketch-diagram-tab/jointjs-sketch/js/shapes/links.js"></script> 
				</xsl:if>
                <style>
                       svg {
                            border: 0px solid #ccc;
                        }
                        .links line {
                            stroke: #999;
                            stroke-opacity: 0.6;
                            stroke-width: 1.5px;
                        }
                        .nodes circle {
                            stroke: #db9d9d;
                            stroke-width: 1.5px;
                            cursor: pointer;
                        }
                        .nodes text {
                            pointer-events: none;
                            font-size: 12px;
                            fill: #333;
                        }
                        .tooltip {
                            position: absolute;
                            text-align: center;
                            padding: 6px;
                            font-size: 12px;
                            background: lightsteelblue;
                            border: 1px solid #ccc;
                            border-radius: 4px;
                            pointer-events: none;
                            opacity: 0;
                            transition: opacity 0.3s;
                        }
                        .tab-pane {
                            position: relative; /* Ensure the content is confined to its parent container */
                            z-index: 1; /* Keep it below the tabs */
                            overflow: auto; /* Prevent content from overflowing and covering the tabs */
                        }

                        .nav-tabs {
                            position: relative; /* Ensure tabs are positioned above tab content */
                            z-index: 10; /* Set a higher z-index than .tab-pane */
                        }

                        .parent-superflex {
                            overflow: auto; /* Prevent large content from expanding outside the intended area */
                            max-width: 100%; /* Ensure it doesn't exceed the container's width */
                        }

                 
                    @keyframes pulse {
                        0% {
                            transform: scale(1);
                            opacity: 1;
                        }
                        50% {
                            transform: scale(1.05); /* Slightly increase the size */
                            opacity: 0.7;            /* Decrease opacity for a subtle effect */
                        }
                        100% {
                            transform: scale(1);
                            opacity: 1;
                        }
                        }

                        /* Create a class that applies the pulse animation */
                        .pulse-slow {
                        animation: pulse 3s infinite; /* 3 seconds duration, infinite loop */
                        }
                        .stack-item-instances {
                            width: 300px; /* Adjust as needed */
                            display: flex;
                            flex-direction: column;
                        }

                        .tech-item-wrapper {
                            width: 300px;
                            overflow: hidden; /* Ensure content stays within boundaries */
                        }

                        .tech-item-label {
                            white-space: nowrap; /* Prevent text from wrapping */
                            overflow: hidden; /* Hide overflowing text */
                            text-overflow: ellipsis; /* Add ellipsis for truncated text */
                            max-width: 100%; /* Ensure it doesn't exceed the parent width */
                            display: block; /* Ensure it behaves as a block element */
                        }

                        .xsmall .tech-item-label-sub {
                            font-size: 0.85rem; /* Smaller font size for subtitle if needed */
                            color: #666; /* Optional: Adjust styling for better readability */
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }
                        .stripe{
                            background-color:#d3d3d3;
                        }
                        #paper-container {
                           // display: flex;
                          //  justify-content: flex-start;
                          //  align-items: flex-start; /* Align to the top */ 
                            width: 100%;
                            height: 90vh;
                            position: relative; 
                            overflow: hidden;  

                        }
                        /* Ensure the scroller itself eats all pointers */
                        .joint-paper-scroller {
                            touch-action: none;       /* disable default touch scrolling */
                            -ms-touch-action: none;   /* IE/Edge prefix */
                        }
                        /* And let its background layer receive the drags: */
                        .paper-scroller-background {
                            pointer-events: all;      /* it was none by default in your HTML dump */
                        }


                        #paper-container .joint-paper {
                                top: 40px !important;
                                left: 0px !important;
                        }

                        .joint-paper {
                            pointer-events: auto;  /* should be set */
                            }


                        .diagramTitle{
                            font-size:1.1em;
                            font-weight: bold;
                        }
                        #diagrams {
                            display: none;
                        }
                </style>
            </head>
            
            <body>
                <xsl:call-template name="Heading"></xsl:call-template>
                
                <a id="top"/>
                
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="page-header">
                                <h1>
                                    <span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
                                    <span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Process Summary for')"/> </span>&#160;
                                    <span class="text-primary headerName"><select id="subjectSelection" style="width: 600px;"><option>Choose</option></select></span>
                                	<span id="selectMenu"></span>
                                </h1>
                            </div>
                        </div>
                    </div>
                    
                    <span id="mainPanel"/>
                </div>
                
                <xsl:call-template name="Footer"></xsl:call-template>
            </body> 
            <script id="panel-template" type="text/x-handlebars-template">
                
                <div class="container-fluid" id="summary-content">
                    
                    <div class="row">
                        <div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
                            <ul class="nav nav-tabs tabs-left">
                                <li class="active">
                                    <a href="#details" data-toggle="tab" onclick="event.preventDefault()"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Process Details')"/></a>
                                </li> 
                                {{#if this.stakeholders}}
                                <li>
                                    <a href="#stakeholders" data-toggle="tab" onclick="event.preventDefault()"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Stakeholders')"/></a>
                                </li> 
                                {{/if}} 
                                {{#if this.processToApps}}
                                <li>
                                    <a href="#implementingProcesses" data-toggle="tab" onclick="event.preventDefault()"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Implementing Processes')"/></a>
                                </li> 
                                {{/if}}
                               {{#if (or this.bus_process_type_creates_information.length this.bus_process_type_updates_information.length this.bus_process_type_deletes_information.length this.bus_process_type_reads_information.length)}}
                                <li>
                                    <a href="#supportingInfo" data-toggle="tab" onclick="event.preventDefault()"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supporting Information')"/></a>
                                </li>
                                {{/if}}
                                {{#if this.planData}}
                                  <li>
                                    <a href="#supportingPlans" data-toggle="tab" onclick="event.preventDefault()"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></a>
                                </li>  
                                {{/if}}
                                {{#ifEquals this.eip false}}
                                {{else}}
                                {{#ifEquals this.flow 'Y'}}
                                <li> 
                                    <a href="#diagramTab" data-toggle="tab" id="diagramtabid"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Diagrams')"/></a>
                                </li>  
                                 <!--
                                <li>
                                    <a href="#processSteps" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Process Steps')"/></a>
                                </li>
                                -->
                                {{/ifEquals}}
                                {{/ifEquals}}
                                {{#if this.costs}}	
                                <li>
                                    <a href="#costs" data-toggle="tab" onclick="event.preventDefault()"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Process Costs')"/></a>
                                </li> 
                               {{/if}}
                                {{#if this.documents}}
                                <li>
                                    <a href="#documentation" data-toggle="tab" onclick="event.preventDefault()"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Documentation')"/></a>
                                </li>  
                                {{/if}}
                            </ul>
                        </div>
                        
                        <div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
                            <div class="tab-content">
                                  <div class="tab-pane fade in active" id="details">
                                    <div class="parent-superflex">
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-server right-10"></i><xsl:value-of select="eas:i18n('Business Process')"/></h3>
                                            <label><xsl:value-of select="eas:i18n('Name')"/></label>
                                            <div class="ess-string">{{this.name}}</div>
                                            <div class="clearfix bottom-10"></div> 
                                            {{#if this.description}}
                                            <label><xsl:value-of select="eas:i18n('Description')"/></label>
                                            <div class="ess-string">{{{breaklines this.description}}}</div>
                                            {{/if}} 
                                        </div>
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-info-circle right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
                                            {{#if this.business_process_id}}
                                            <label><xsl:value-of select="eas:i18n('Process ID')"/></label>
                                            <div class="bottom-10">  
                                            <div class="ess-string"> {{this.business_process_id}}</div>
                                            </div>   
                                            {{/if}}
                                            
                                            {{#if this.processToApps.0.processCriticality}}
                                            <label><xsl:value-of select="eas:i18n('Business Criticality')"/></label>
                                            <div class="bottom-10">  
                                              
                                            <div class="ess-string"><xsl:attribute name="style">color:{{this.processToApps.0.criticalityStyle.colour}};background-color:{{this.processToApps.0.criticalityStyle.backgroundColour}}</xsl:attribute>{{this.processToApps.0.processCriticality}}</div>
                                            </div>                                                 
                                            {{/if}}  
                                            {{#if this.standardisation}}
                                            <label><xsl:value-of select="eas:i18n('Standardisation')"/></label>
                                            <div class="bottom-10">  
                                              
                                            <div class="ess-string"><xsl:attribute name="style"></xsl:attribute>{{this.standardisation}}</div>
                                            </div>                                                 
                                            {{/if}}   
                                             {{#if this.performedbyRole}}
                                            <label><xsl:value-of select="eas:i18n('Performed by Role')"/></label>
                                            <div class="bottom-10">  
                                              {{#each this.performedbyRole}}
                                                <div class="ess-string"><xsl:attribute name="style"></xsl:attribute>{{this.name}}</div>
                                                {{/each}}
                                            </div>        
                                            {{/if}} 
                                            {{#if this.ownedbyRole}}
                                            <label><xsl:value-of select="eas:i18n('Owned by Role')"/></label>
                                            <div class="bottom-10">  
                                              {{#each this.ownedbyRole}}
                                                <div class="ess-string"><xsl:attribute name="style"></xsl:attribute>{{this.name}}</div>
                                                {{/each}}
                                            </div>        
                                            {{/if}}   
                                             {{#if this.actors}}
                                            <label><xsl:value-of select="eas:i18n('Performed by Organisation')"/></label>
                                            <div class="bottom-10">  
                                              {{#each this.actors}}
                                                <div class="ess-string"><xsl:attribute name="style"></xsl:attribute>{{this.name}}</div>
                                                {{/each}}
                                            </div>        
                                            {{/if}}  
                                            
                                        </div>
                                        {{#if this.parentCaps}}
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-user right-10"></i><xsl:value-of select="eas:i18n('Business Mappings')"/></h3>
                                            <h4>Parent Capabilities</h4>
                                            {{#each this.parentCaps}}
                                                <div class="info-soft-green genericCard">
                                                    {{this.name}} 
                                                </div>
                                            {{/each}}
                                            {{#if this.bp_sub_business_processes}}
                                             <h4>Sub Processes</h4>
                                            {{#each this.bp_sub_business_processes}}
                                                <div class="info-soft-blue genericCard">
                                                    {{this.name}} 
                                                </div>
                                            {{/each}}
                                            {{/if}}
                                            <div class="clearfix bottom-10"></div>  
                                        </div> 
                                        {{/if}}
                                        {{#if this.stakeholders}}
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-user right-10"></i><xsl:value-of select="eas:i18n('Ownership')"/></h3>
                                            {{#each this.stakeholders}}
                                            {{#ifContains this 'Owner'}}{{/ifContains}}
                                            {{/each}}
                                            <div class="clearfix bottom-10"></div>  
                                        </div> 
                                        {{/if}}
                                        <div class="col-xs-12"></div>
                                       
                                    </div>
                                  
                                </div> 
                                <div class="tab-pane fade" id="stakeholders">
                                    <div class="parent-superflex">
                                        {{#if this.indivStakeholdersList}}
                                        <div class="superflex col-md-12">
                                            <h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('People &amp; Roles')"/></h3>
                                            
                                            <table class="table table-striped table-bordered dt_stakeholders">
                                                <thead>
                                                    <tr>
                                                        <th class="cellWidth-30pc">
                                                            <xsl:value-of select="eas:i18n('Person')"/>
                                                        </th>
                                                        <th class="cellWidth-30pc">
                                                            <xsl:value-of select="eas:i18n('Role')"/>
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {{#each this.indivStakeholdersList}} 
                                                    {{#ifEquals this.type ''}}
                                                    {{else}}
                                                    <tr>
                                                        <td class="cellWidth-30pc">
                                                            {{#essRenderInstanceLinkOnly this 'Individual_Actor'}}{{/essRenderInstanceLinkOnly}}
                                                        </td>
                                                        <td class="cellWidth-30pc">
                                                            <ul class="ess-list-tags">
                                                                {{#each this.values}}
                                                                <li class="tagActor" style="background-color: rgb(185, 225, 230);color:#000">{{this.role}}</li>
                                                                {{/each}}
                                                            </ul>
                                                        </td>
                                                    </tr>
                                                    {{/ifEquals}}
                                                    {{/each}}
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <th>
                                                            <xsl:value-of select="eas:i18n('Person')"/>
                                                        </th>
                                                        <th>
                                                            <xsl:value-of select="eas:i18n('Role')"/>
                                                        </th>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                            <div class="clearfix bottom-10"></div>
                                        </div>
                                        {{/if}}
                                        {{#if this.orgStakeholdersList}}
                                        <div class="superflex col-md-12">
                                            <h3 class="text-primary"><i class="fa fa-sitemap right-10"></i><xsl:value-of select="eas:i18n('Organisations &amp; Roles')"/></h3>
                                            
                                            <table class="table table-striped table-bordered dt_stakeholders">
                                                <thead>
                                                    <tr>
                                                        <th class="cellWidth-30pc">
                                                            <xsl:value-of select="eas:i18n('Organisations')"/>
                                                        </th>
                                                        <th class="cellWidth-30pc">
                                                            <xsl:value-of select="eas:i18n('Role')"/>
                                                        </th>
                                                        
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {{#each this.orgStakeholdersList}} 
                                                    <tr>
                                                        <td class="cellWidth-30pc">
                                                            {{#essRenderInstanceLinkOnly this 'Group_Actor'}}{{/essRenderInstanceLinkOnly}}
                                                        </td>
                                                        <td class="cellWidth-30pc">
                                                            
                                                            <ul class="ess-list-tags">
                                                                {{#each this.values}}
                                                                <li class="tagActor"  style="background-color: rgb(215, 190, 233);color:#000">{{this.role}}</li>
                                                                {{/each}}
                                                            </ul>
                                                            
                                                        </td>
                                                        
                                                    </tr>     
                                                    {{/each}}
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <th>
                                                            <xsl:value-of select="eas:i18n('Organisation')"/>
                                                        </th>
                                                        <th>
                                                            <xsl:value-of select="eas:i18n('Role')"/>
                                                        </th>
                                                        
                                                    </tr>
                                                </tfoot>
                                            </table>
                                            
                                            <div class="clearfix bottom-10"></div>
                                        </div>
                                        {{/if}}
                                        
                                    </div>
                                </div> 
                                <div class="tab-pane fade" id="implementingProcesses">
                                    <div class="parent-superflex">
                                      
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Implementing Processes')"/></h3> 
 
                                            <div class="process-card-container">
                                            {{#each this.processToApps}}
                                                <div class="process-card">
                                                <div class="process-card-header">
                                                    <h3>{{name}}</h3>
                                                    
                                                </div>
                                                <div class="process-card-body">
                                                    <p><strong>Organisation:</strong> {{org}}</p>
                                                    <p><strong>Process:</strong> {{processName}}</p>
                                                    
                                                    {{#if sites}}
                                                    <div>
                                                        <strong>Sites:</strong>
                                                        <ul>
                                                        {{#each sites}}
                                                            <li>{{name}} </li>
                                                        {{/each}}
                                                        </ul>
                                                    </div>
                                                    {{/if}}

                                                    {{#if appsviaservice}}
                                                    <div>
                                                        <strong>Applications:</strong>
                                                        <ul>
                                                        {{#each appsviaservice}}
                                                            <li>
                                                            {{name}} {{{essRenderInstanceMenuLink this.appInfo}}} 
                                                            {{#if this.criticality}}
                                                             <br/>
                                                            <small><b>Criticality</b></small>: <span class="badge-criticality"><xsl:attribute name="style">color:{{style.colour}};background-color:{{style.backgroundColour}}</xsl:attribute>{{criticality}}</span>
                                                            {{/if}}
                                                            </li>
                                                        {{/each}}
                                                        {{#each appsdirect}}
                                                            <li>
                                                            {{name}} {{{essRenderInstanceMenuLink this.appInfo}}} 
                                                            {{#if this.criticality}}
                                                             <br/>
                                                        <small><b>Criticality</b></small>: <span class="badge-criticality"><xsl:attribute name="style">color:{{style.colour}};background-color:{{style.backgroundColour}}</xsl:attribute>{{criticality}}</span>
                                                            {{/if}}
                                                            </li>
                                                        {{/each}}
                                                        </ul>
                                                    </div>
                                                    {{/if}}
                                                </div>
                                                </div>
                                            {{/each}}
                                            </div>



                                        </div> 
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="supportingInfo">
                                    <div class="parent-superflex">
                                      
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Supporting Information')"/></h3> 
                                      

                                            <div class="info-container">
                                                {{#if this.bus_process_type_creates_information.length}}
                                                <div class="info-group">
                                                    <h2 class="info-group-title ">Creates Information</h2>
                                                    <div class="info-group-row">
                                                        {{#each this.bus_process_type_creates_information}}
                                                            <div class="info-card info-soft-green">
                                                                <div class="info-card-header">{{this.name}}</div>
                                                                <div class="info-card-body">
                                                                    <p class="info-card-text">{{this.description}}</p>
                                                                </div>
                                                            </div>
                                                        {{/each}}
                                                    </div>
                                                </div>
                                                {{/if}}
                                                
                                                {{#if this.bus_process_type_reads_information.length}}
                                                <div class="info-group">
                                                    <h2 class="info-group-title ">Reads Information</h2>
                                                    <div class="info-group-row">
                                                        {{#each this.bus_process_type_reads_information}}
                                                            <div class="info-card info-soft-blue">
                                                                <div class="info-card-header">{{this.name}}</div>
                                                                <div class="info-card-body">
                                                                    <p class="info-card-text">{{this.description}}</p>
                                                                    {{#if this.infoConcepts}}
                                                                    <b>View of Information Concept(s)</b>
                                                                    <br/>
                                                                    {{#each this.infoConcepts}}
                                                                            {{this.name}}{{#unless @last}}, {{/unless}}
                                                                    {{/each}}
                                                                    {{/if}}
                                                                </div>
                                                            </div>
                                                        {{/each}}
                                                    </div>
                                                </div>
                                                {{/if}}
                                                
                                                {{#if this.bus_process_type_updates_information.length}}
                                                <div class="info-group">
                                                    <h2 class="info-group-title">Updates Information</h2>
                                                    <div class="info-group-row">
                                                        {{#each this.bus_process_type_updates_information}}
                                                            <div class="info-card info-soft-yellow">
                                                                <div class="info-card-header">{{this.name}}</div>
                                                                <div class="info-card-body">
                                                                    <p class="info-card-text">{{this.description}}</p>
                                                                </div>
                                                            </div>
                                                        {{/each}}
                                                    </div>
                                                </div>
                                                {{/if}}
                                                
                                                {{#if this.bus_process_type_deletes_information.length}}
                                                <div class="info-group">
                                                    <h2 class="info-group-title">Deletes Information</h2>
                                                    <div class="info-group-row">
                                                        {{#each this.bus_process_type_deletes_information}}
                                                            <div class="info-card info-soft-red">
                                                                <div class="info-card-header">{{this.name}}</div>
                                                                <div class="info-card-body">
                                                                    <p class="info-card-text">{{this.description}}</p>
                                                                </div>
                                                            </div>
                                                        {{/each}}
                                                    </div>
                                                </div>
                                                {{/if}}
                                            </div>



                                       </div> 
                                    </div>
                                </div>
                        {{#if this.costs}}
						<div class="tab-pane fade" id="costs">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
								<div class="pull-right"><b>Currency</b>: <select id="ccySelect"><option>Choose</option></select></div>
									<div class="costTotal-container">
										 
									</div>
								</div>
								<div class="col-xs-12"/>
								<div class="superflex">
								 
									<div class="chart-container" >
										<canvas id="costByType-chart"  ></canvas>
									</div>
							 
							</div>

								<div class="superflex">
									<div class="chart-container">
										<canvas id="costByCategory-chart" ></canvas>
									</div>
								</div>
								
								<div class="col-xs-12"/>
								<div class="superflex">
									<div class="chart-container" style="margin-bottom: 70px;">
										<canvas id="costByMonth-chart"></canvas>
									</div> 
								</div>
								<div class="superflex">
								  
										<div class="chart-container">
											<canvas id="costByFrequency-chart" ></canvas>
										</div> 
								</div>
								
								<div class="col-xs-12"/> 
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></h3>
									<p><xsl:value-of select="eas:i18n('Costs related to this application')"/></p>
									<table class="table table-striped table-bordered display compact" id="dt_costs">
										<thead><tr><th><xsl:value-of select="eas:i18n('Cost')"/></th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Description')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></thead>
										{{#each this.costs}}
										<tr>
											<td><span class="label label-primary">{{this.name}}</span></td>
											<td><span class="label label-primary">{{#getType this.costType}}{{/getType}}</span></td>
											<td>{{this.description}}</td>
											<td>{{#if this.this_currency}}{{this.this_currency}}{{else}}{{this.currency}}{{/if}}{{#formatCurrency this.cost}}{{/formatCurrency}}</td>
											<td>{{#formatDate this.fromDate}}{{/formatDate}}</td>
											<td>{{#formatDate this.toDate}}{{/formatDate}}</td>
										</tr>
										{{/each}}
										<tfoot><tr><th><xsl:value-of select="eas:i18n('Cost')"/></th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Description')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></tfoot>
									</table>
								</div>
							</div>	
						</div>
						{{/if}}
                        
                         <div class="tab-pane fade" id="supportingPlans">
                            <div class="parent-superflex">
                                <div class="superflex">
                                    <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></h3>
                                    <div class="clearfix"/> 
                                    <h3>Plans</h3>
                                    <p>Plans impacting this business process:</p>
                                    {{#each this.planData.plans}}
                                    <div class="plan-card">
                                        <div class="plan-header">
                                            <h3 class="plan-title">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</h3>
                                            <span class="meta-label">START</span>: <span class="plan-duration">
                                                {{formatDate planStart}}  
                                            </span>
                                             <span class="meta-label">PLANNED END</span>:  <span class="plan-duration">{{formatDate planEnd}}</span>
                                        </div>
                                        
                                        <div class="plan-projects-summary">
                                            <span class="projects-count">
                                                <strong>{{projects.length}}</strong> projects
                                            </span>
                                            <span class="status-badge {{getStatusClass planStatus}}">
                                                {{#if planStatus}}{{planStatus}}{{else}}Active{{/if}}
                                            </span>
                                        </div>
                                    </div>
                                    {{/each}}
                                    {{#ifEquals this.planData.projects.length 0}}
                                    {{else}}
                                        <h3>Projects</h3>
                                        <p>Projects impacting this business process:</p>
                                        {{#each this.planData.projects}}
                                            <div class="project-card">
                                                <div class="project-header">
                                                    <h3 class="project-title">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</h3>
                                                </div>
                                            
                                            {{#if description}}
                                            <div class="project-description">{{description}}</div>
                                            {{/if}}
                                            
                                            <div class="project-meta">
                                                <div class="meta-item">
                                                    <div class="meta-label">Status</div>
                                                    <div class="meta-value">
                                                        <span class="status-badge {{getStatusClass projectStatus}}">{{projectStatus}}</span>
                                                    </div>
                                                </div> 
                                                <div class="meta-item">
                                                    <div class="meta-label">Start Date</div>
                                                    <div class="meta-value date-range">{{formatDate projectStart}}
                                                        
                                                    </div>
                                                </div>
                                                <div class="meta-item">
                                                    <div class="meta-label">End Date</div>
                                                    <div class="meta-value date-range">{{formatDate projectEnd}}</div>
                                                </div>
                                                <!--
                                                <div class="meta-item">
                                                    <div class="meta-label">Approval</div>
                                                    <div class="meta-value">
                                                        <span class="status-badge {{getStatusClass approvalStatus}}">{{approvalStatus}}</span>
                                                    </div>
                                                </div>
                                                -->
                                            </div>
                                        </div>
                                    {{/each}}
                                    {{/ifEquals}}
                                </div>
                            </div>
						</div> 
                        <div class="tab-pane fade" id="diagramTab">
                            <div class="pull-right right-20">
                                
                            </div>

                            <div class="parent-superflex">
                                <div class="superflex">
                                    <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Diagrams')"/></h3>
                                    <div class="clearfix"/>
                                    <select id="diagrams" style="display:none"><option>Choose</option></select>
                                      
                                    <button id="zoomIn" class="btn btn-info btn-xs"><i class="fa fa-plus"/></button>
                                    <button id="zoomOut" class="btn btn-info btn-xs"><i class="fa fa-minus"/></button>
                                    <button id="fitToScreen" class="btn btn-info btn-xs"><i class="fa fa-arrows-alt"/></button>
                                    <xsl:text> </xsl:text>
                                    <button id="jumpToSteps" class="btn btn-warning btn-xs">Jump to Steps</button>
                                    <br/>
                                    <span id="diagramName" class="diagramTitle"></span>
                                    <div id="paper-container"></div>
                                   
                                </div>
                                <div class="col-xs-12"/>
                                 <div class="superflex" id="stepsdiv">
                                    <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Process Steps')"/></h3>
                                       <h1>BPMN Process Steps</h1>
                                        <table class="steptable">
                                            <thead>
                                                <tr>
                                                    <th>Step</th>
                                                    <th>Name</th>
                                                    <th>Type</th>
                                                    <th>Swimlane</th>
                                                    <th>Applications</th>
                                                    <th>Information Views</th>
                                                    <th class="hide-id">ID</th>
                                                    <th>Branch Identifier</th>
                                                    <th>Next Steps</th>
                                                </tr>
                                            </thead>
                                            <tbody id="bpmnTableBody"></tbody>
                                        </table>
                                        <div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
                                            <label for="algorithmSelect">Select Traversal Algorithm:</label>
                                            <select id="algorithmSelect">
                                                <option value="dfs" selected="true">Depth-First Search (DFS)</option>
                                                <option value="bfs">Breadth-First Search (BFS)</option>
                                                <option value="greedy_bfs">Greedy Best-First Search</option>
                                            </select>
                                        </div>
                                   
                                </div>
                            </div>
						</div> 
                        <!--
                        <div class="tab-pane fade" id="processSteps">
                            <div class="parent-superflex">
                                <div class="superflex">
                                    <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Process Steps')"/></h3>
                                       <h1>BPMN Process Steps</h1>
                                        <table class="steptable">
                                            <thead>
                                                <tr>
                                                    <th>Step</th>
                                                    <th>Name</th>
                                                    <th>Type</th>
                                                    <th>Row</th>
                                                    <th class="hide-id">ID</th>
                                                    <th>Branch Identifier</th>
                                                    <th>Next Steps</th>
                                                </tr>
                                            </thead>
                                            <tbody id="bpmnTableBody"></tbody>
                                        </table>
                                        <div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
                                            <label for="algorithmSelect">Select Traversal Algorithm:</label>
                                            <select id="algorithmSelect">
                                                <option value="dfs" selected="true">Depth-First Search (DFS)</option>
                                                <option value="bfs">Breadth-First Search (BFS)</option>
                                                <option value="greedy_bfs">Greedy Best-First Search</option>
                                            </select>
                                        </div>
                                   
                                </div>
                            </div>
                        </div>
                        -->
							{{#if this.documents}}
                                <div class="tab-pane" id="documentation">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Documentation')"/></h3>
                                        <div class="clearfix"/>
                                        
                                        {{#each this.documents}}
                                            {{#ifEquals this.key 'undefined'}}{{else}}<strong>{{this.key}}</strong><div class="clearfix"/>{{/ifEquals}}
                                        <div class="doc-link-wrapper top-10">
                                            {{#each this.values}}
                                            <div class="doc-link-blob bdr-left-blue">
                                                <div class="doc-link-icon"><i class="fa fa-file-o"></i></div>
                                                <div>
                                                    <div class="doc-link-label">
                                                        <a target="_blank">
                                                            <xsl:attribute name="href">{{this.documentLink}}</xsl:attribute>
                                                            {{this.name}}&#160;<i class="fa fa-external-link"></i>
                                                        </a>
                                                    </div>
                                                    <div class="doc-description">{{this.description}}</div>
                                                </div>
                                            </div>
                                            {{/each}}
                                        </div>
                                        {{/each}}
                                    </div>
                                </div>
                                </div>
						{{/if}}
                            </div>
                        </div>
                    </div>
                </div>
                
            </script>
<script id="dataTable-template" type="text/x-handlebars-template">
   
  <ul>
    {{#each this}}
    <li>{{this.label.text}} {{#if this.dataTypeIcon.iconType}}({{this.dataTypeIcon.iconType}}){{/if}}</li>
    {{/each}}
  </ul> 
</script>
<script id="appTable-template" type="text/x-handlebars-template">
   
  <ul>
    {{#each this}}
        <b>Direct</b><br/>
        {{#each this.appsdirect}}
            <li>{{this.name}}</li>
        {{/each}}
        <b>Via Service</b>
        {{#each this.appsviaservice}}
            <li>{{this.appName}} <small>({{this.name}})</small></li>
        {{/each}}
    {{/each}}
  </ul> 
</script>
     <script id="costTotal-template" type="text/x-handlebars-template">
        <h3 class="text-primary"><i class="fa fa-money right-10"></i><b><xsl:value-of select="eas:i18n('Costs')"/></b></h3>
        
        <h3><b><xsl:value-of select="eas:i18n('Regular Annual Cost')"/></b>: <span id="regAnnual">{{this.annualCost}}</span></h3>
        <h3><b><xsl:value-of select="eas:i18n('Regular Monthly Cost')"/></b>: <span id="regMonthly">{{this.monthlyCost}}</span></h3>
	</script>
     <script id="select-template" type="text/x-handlebars-template"> 
        <xsl:text> </xsl:text>{{#essRenderInstanceLinkSelect this}}{{/essRenderInstanceLinkSelect}}   
    </script>
            <script type="text/javascript" src="business/core_bl_business_process_summary.js"></script>
            <script>
                <xsl:call-template name="RenderViewerAPIJSFunction"> 
                   <xsl:with-param name="viewerAPIPathProcess" select="$apiPathProcesses"/>
                   <xsl:with-param name="viewerAPIPathPhysProcess" select="$apiPathPhysProcesses"/>
                   <xsl:with-param name="viewerAPIPathInstance" select="$apiInstance"></xsl:with-param>
                </xsl:call-template>
            </script>
        </html>
    </xsl:template>
    
    <xsl:template name="RenderViewerAPIJSFunction">
      <xsl:param name="viewerAPIPathProcess"/>
      <xsl:param name="viewerAPIPathPhysProcess"/>
	  <xsl:param name="viewerAPIPathInstance"></xsl:param> 
      var viewAPIDataProcess ='<xsl:value-of select="$viewerAPIPathProcess"/>';  
      var viewAPIDataPhysProcess ='<xsl:value-of select="$viewerAPIPathPhysProcess"/>';  

      var processUsages=[<xsl:apply-templates select="$allInfoUsages" mode="info"></xsl:apply-templates>]; 
      var allUsages=[<xsl:apply-templates select="$allProcessActivityUsages" mode="usages"></xsl:apply-templates>]; 
    
      console.log('allUsages',allUsages)
      var promise_loadViewerAPIData = function(apiDataSetURL) {
         return new Promise(function(resolve, reject) {
             if (apiDataSetURL != null) {
                 var xmlhttp = new XMLHttpRequest();

                 xmlhttp.onreadystatechange = function() {
                     if (this.readyState == 4 &amp;&amp; this.status == 200) {
                         var viewerData = JSON.parse(this.responseText);
                         resolve(viewerData); 
                     }
                 };
                 xmlhttp.onerror = function() {
                     reject(false);
                 };
                 xmlhttp.open("GET", apiDataSetURL, true);
                 xmlhttp.send();
             } else {
                 reject(false);
             }
         });
     };
     <xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
     <xsl:call-template name="planData"></xsl:call-template>
     let focusProcessId='<xsl:value-of select="$param1"/>';
     var eip;
    <xsl:choose>
     <xsl:when test="$isEIPMode='true'">eip=true;</xsl:when>
     <xsl:otherwise>eip=false;</xsl:otherwise>
     </xsl:choose>
     var currentLang="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>";
				if (!currentLang || currentLang === '') {
					currentLang = 'en-GB';
				}

     var rcCcyId= {ccyCode: "<xsl:value-of select="$currency/own_slot_value[slot_reference='currency_code']/value"/>", ccySymbol: "<xsl:value-of select="$currency/own_slot_value[slot_reference='currency_symbol']/value"/>", ccyName: "<xsl:value-of select="$currency/own_slot_value[slot_reference='name']/value"/>", ccyId: "<xsl:value-of select="$currency/name"/>"};
        if(rcCcyId.ccyCode==''){
            rcCcyId= {ccyCode: "USD", ccySymbol: "$", ccyName: "Dollar"}

        }
        var defaultCurrency    
        const isIndexedDBSupported = () => {
            return !!window.indexedDB;
        };

        function showEditorSpinner(message) {
				$('#editor-spinner-text').text(message);                            
				$('#editor-spinner').removeClass('hidden');                         
			};
	
        function removeEditorSpinner() {
            $('#editor-spinner').addClass('hidden');
            $('#editor-spinner-text').text('');
        };
	 
    var apiPath='<xsl:value-of select="$viewerAPIPathInstance"/>&amp;PMA=';

       
    </xsl:template>
    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
           <xsl:call-template name="RenderAPILinkText">
              <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
           </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
     </xsl:template>
     <xsl:template name="GetViewerAPIPathText">
		<xsl:param name="apiReport"></xsl:param>

		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$dataSetPath"></xsl:value-of>

	</xsl:template>
    <xsl:template match="node()" mode="info">
        <xsl:variable name="thisIV" select="key('infoViews', current()/own_slot_value[slot_reference='information_view_used']/value)"/>
        {
            "id":"<xsl:value-of select="current()/name"/>",
            <xsl:variable name="combinedMap" as="map(*)" select="map{
            'infoView': string(translate(translate($thisIV/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate($thisIV/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
            }" />
	        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	        <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
        }<xsl:if test="position()!=last()">,</xsl:if>

    </xsl:template>
    <xsl:template match="node()" mode="usages">
        {
            "id":"<xsl:value-of select="current()/name"/>",
            "processoractivityid":"<xsl:value-of select="current()/own_slot_value[slot_reference = ('business_activity_used', 'business_process_used')]/value"/>"
        }<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>
</xsl:stylesheet>