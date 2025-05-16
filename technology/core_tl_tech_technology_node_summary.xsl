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
    
    <xsl:param name="param1" /> 
    
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes" use-character-maps="c-1replace"/>
    
    <xsl:variable name="linkClasses" select="('Technology_Node', 'Application_Provider', 'Geographic_Region', 'Technology_Product', 'Technology_Node_Type', 'Application_Deployment', 'Technology_Instance','Information_Store')" />
    <xsl:variable name="apiPathNodesRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Nodes']"/>
    <xsl:variable name="pageLabel">
        <xsl:value-of select="eas:i18n('Technology Node Summary')" />
    </xsl:variable>
    
    <xsl:template match="knowledge_base">
        <xsl:variable name="apiPathNodes">
            <xsl:call-template name="GetViewerAPIPath">
               <xsl:with-param name="apiReport" select="$apiPathNodesRep"/>
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
                
                <link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css?release=6.19" type="text/css" rel="stylesheet"></link>
                <link href="technology/technology_summary.css" type="text/css" rel="stylesheet"></link>
                
                <title>
                    <xsl:value-of select="$pageLabel" />
                </title>
                
                <script src="js/d3/d3.v5.9.7.min.js?release=6.19"></script>
                <style>
                       svg {
            border: 1px solid #ccc;
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

                </style>
                <style>
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
                                    <span class="text-darkgrey"><xsl:value-of select="eas:i18n('Node Summary for')"/> </span>&#160;
                                    <span class="text-primary headerName"><select id="subjectSelection" style="width: 600px;"></select></span>
                                	<span id="selectMenu"></span>
                                </h1>
                            </div>
                        </div>
                    </div>
                    
                    <span id="mainPanel"/>
                </div>
                
                <xsl:call-template name="Footer"></xsl:call-template>
            </body>
            <script id="select-template" type="text/x-handlebars-template"> 
                <xsl:text> </xsl:text>{{#essRenderInstanceLinkSelect this}}{{/essRenderInstanceLinkSelect}}   
            </script>
            <script id="panel-template" type="text/x-handlebars-template">
                
                <div class="container-fluid" id="summary-content">
                    
                    <div class="row">
                        <div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
                            <ul class="nav nav-tabs tabs-left">
                                <li class="active">
                                    <a href="#details" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Node Details')"/></a>
                                </li> 
                                {{#if this.stakeholders}}
                                <li>
                                    <a href="#stakeholders" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Stakeholders')"/></a>
                                </li> 
                                {{/if}}
                                {{#if this.graph.nodes}}
                                <li>
                                    <a href="#dependencies" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Dependencies')"/></a>
                                </li>
                                {{/if}}
                                {{#if this.instances}}
                                <li>
                                    <a href="#instances" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Instances')"/></a>
                                </li> 
                                {{/if}}
                            </ul>
                        </div>
                        
                        <div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
                            <div class="tab-content">
                                  <div class="tab-pane fade in active" id="details">
                                    <div class="parent-superflex">
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-server right-10"></i><xsl:value-of select="eas:i18n('Node')"/></h3>
                                            <label><xsl:value-of select="eas:i18n('Name')"/></label>
                                            <div class="ess-string">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
                                            <div class="clearfix bottom-10"></div>
                                            {{#if this.deployment_of}}
                                            <label><xsl:value-of select="eas:i18n('Deployment Of')"/></label>
                                            <div class="ess-string">{{#essRenderInstanceMenuLink this.deployment_of}}{{/essRenderInstanceMenuLink}}</div>
                                            {{/if}}
                                            {{#if this.description}}
                                            <label><xsl:value-of select="eas:i18n('Description')"/></label>
                                            <div class="ess-string">{{{breaklines this.description}}}</div>
                                            {{/if}}
                                            {{#if this.appDeployment}}
                                            <label><xsl:value-of select="eas:i18n('Application deployed')"/></label>
                                            <div class="ess-string">{{#essRenderInstanceMenuLink this.appDeployment}}{{/essRenderInstanceMenuLink}}</div>
                                            {{/if}}
                                            {{#if this.parentNodes}}
                                            <label><xsl:value-of select="eas:i18n('Supporting Nodes')"/></label>
                                            {{#each this.parentNodes}}
                                            <div class="ess-string">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
                                            {{/each}}
                                            {{/if}}
            
                                            {{#if this.hostInfo}}
                                            <label><xsl:value-of select="eas:i18n('Site')"/></label>
                                            <div class="ess-string">{{#essRenderInstanceMenuLink this.hostInfo}}{{/essRenderInstanceMenuLink}}</div>
                                            {{/if}}
                                        </div>
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-info-circle right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
                                            {{#if this.criticality}}
                                            <label><xsl:value-of select="eas:i18n('Business Criticality')"/></label>
                                            <div class="bottom-10">
			  
                                              
                                                <div class="ess-string"><xsl:attribute name="style">{{#styles this.criticalityId}}{{/styles}}</xsl:attribute>{{this.criticality}}</div>
                                            </div>                                                 
                                            {{/if}}   
                                            
                                            <label><xsl:value-of select="eas:i18n('Node Type')"/></label>
                                            <div class="bottom-10">
                                                {{#if this.technology_node_type}}
                                                <div class="ess-string">
                                                <i><xsl:attribute name="class">fa {{this.technology_node_type.icon}}</xsl:attribute></i><xsl:text> </xsl:text>{{this.technology_node_type.name}}</div>
                                                {{else}}
                                                <div class="ess-string"><xsl:value-of select="eas:i18n('Not Set')"/></div>
                                                {{/if}}
                                            </div>
                                            {{#if this.IPAddress}}
                                            <label><xsl:value-of select="eas:i18n('IP Address')"/></label>
                                            <div class="bottom-10">
                                                <span class="label label-primary">{{this.IPAddress.attribute_value}}</span>
                                            </div>
                                            {{/if}}
                                        </div>
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
                                        {{#if this.techStack}}
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-tags right-10"></i><xsl:value-of select="eas:i18n('Technology Stack')"/></h3>
                                            {{#each this.techStack}}
                                            <div class="tech-stack-card">
                                                <div class="techlabel"><xsl:value-of select="eas:i18n('Technology')"/></div>
                                                <div class="name"><i class="fa fa-circle" style="color:#c938c9"></i><xsl:text> </xsl:text> {{this.technology_product}}</div>
                                                <div class="name"><i class="fa fa-circle" style="color:plum"></i><xsl:text> </xsl:text> {{this.technology_component}}</div>  
                                            </div>
                                            {{/each}}
                                        </div>
                                        {{/if}}
                                        {{#if this.attributes}}
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-tags right-10"></i><xsl:value-of select="eas:i18n('Attributes')"/></h3>
                                            
                                            <table class="table-condensed" style="border:0;border-collapse: collapse">
                                                <thead>
                                                    <tr>
                                                        <th class="cellWidth-30pc">
                                                            <xsl:value-of select="eas:i18n('Attribute')"/>
                                                        </th>
                                                        <th class="cellWidth-30pc">
                                                            <xsl:value-of select="eas:i18n('Value')"/>
                                                        </th>
                                                        <th class="cellWidth-30pc">
                                                            <xsl:value-of select="eas:i18n('Unit')"/>
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {{#each this.attributes}} 
                                                    <tr>
                                                        <td class="cellWidth-30pc">
                                                          <i class="fa fa-tag" style="color:#c092ea"></i><xsl:text> </xsl:text>  {{this.attribute_value_of}}
                                                        </td>
                                                        <td class="cellWidth-30pc">
                                                            <span class="label label-default"> {{this.attribute_value}}</span>
                                                        </td>
                                                        <td class="cellWidth-30pc">
                                                            {{#if this.attribute_value_unit}}
                                                            <span class="label label-default"> {{this.attribute_value_unit}}</span>
                                                            {{/if}}
                                                        </td>
                                                    </tr>
                                                    {{/each}}
                                                </tbody>
                                            </table>
                                        </div>
                                        {{/if}}
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
                            
                                <div class="tab-pane fade" id="instances">
                                    <div class="parent-superflex">
                                      
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Business Applications')"/></h3>
                                            <div class="stack-item-instances-wrapper">
                                                {{#each this.instances}}
                                                {{#if this.app}}
                                                <div class="stack-item-instances">
                                                    <div class="tech-item-wrapper">
                                                        <div class="tech-item-label">{{#essRenderInstanceMenuLink this.app}}{{/essRenderInstanceMenuLink}}</div>
                                                        <div class="xsmall">
                                                            <div class="tech-item-label-sub">
                                                                {{this.app.deployment.name}}
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="tech-detail-wrapper">
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Runtime Status')"/>:</b> <xsl:text> </xsl:text> <span class="label label-warning pulse-slow"><xsl:attribute name="style">{{#styles this.runtime_status_id}}{{/styles}}</xsl:attribute>{{this.runtime_status}}</span><br/>
                                                    {{#if this.tech}}
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Deployment Technology Format')"/></b><br/> 	 
                                                    {{#essRenderInstanceMenuLink this.tech}}{{/essRenderInstanceMenuLink}}<br/>
                                                    {{/if}}
                                                    {{#each this.instance_software_dependencies}} 
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Supporting Application Runtime Instance')"/></b><br/> {{this.given_name}}<br/>
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Supporting Application Runtime Technology')"/></b><br/> {{this.technology_product}}<br/>
                                                    {{/each}}
                                                    {{#if this.app.deployment.role}}
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Deployment of Application')"/>:</b><xsl:text> </xsl:text><span class="label label-default"><xsl:attribute name="style">{{#styles this.app.deployment.roleid}}{{/styles}}</xsl:attribute>{{this.app.deployment.role}}</span><br/>
                                                      {{/if}}
                                                    </div>
                                                </div>
                                                {{/if}}
                                                {{/each}}
                                            </div>
                                        </div>
                                   
                                        {{#if (some this.instances "tech")}}
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-tasks right-10"></i><xsl:value-of select="eas:i18n('Infrastructure Software')"/></h3>
                                            <div class="stack-item-instances-wrapper">
                                            {{#each this.instances}}
                                            {{#if this.tech}}
                                            <div class="stack-item-instances">
                                                <div class="tech-item-wrapper">
                                                    <div class="tech-item-label">{{#essRenderInstanceMenuLink this.tech}}{{/essRenderInstanceMenuLink}}</div>
                                                </div>
                                                <div class="tech-detail-wrapper">
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Runtime Status')"/>:</b> <xsl:text> </xsl:text> {{#if this.runtime_status}} <span class="label label-warning pulse-slow"><xsl:attribute name="style">{{#styles this.runtime_status_id}}{{/styles}}</xsl:attribute>{{this.runtime_status}}</span>
                                                    {{else}}
                                                    <span class="label label-default"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                    <br/>
                                                    {{#if this.tech}}
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Deployment Technology Format')"/></b><br/> 	 
                                                    {{/if}}
                                                    {{#essRenderInstanceMenuLink this.tech}}{{/essRenderInstanceMenuLink}}<br/>
                                                    {{#each this.instance_software_dependencies}} 
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Supporting Application Runtime Instance')"/></b><br/> {{this.given_name}}<br/>
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Supporting Application Runtime Technology')"/></b><br/> {{this.technology_product}}<br/>
                                                    {{/each}}
                                                    {{#if this.role}}
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Deployment of Application')"/>:</b>	<xsl:text> </xsl:text><span class="label label-default"><xsl:attribute name="style">{{#styles this.app.deployment.roleid}}{{/styles}}</xsl:attribute>{{this.app.deployment.role}}</span><br/>
                                                    {{/if}}
                                                </div>
                                            </div>
                                            {{/if}}
                                            {{/each}}
                                            </div>
                                        </div>
                                        {{/if}}
                                        {{#if (some this.instances "instance_of_information_store")}}
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-database right-10"></i><xsl:value-of select="eas:i18n('Deployed Database Schema')"/></h3>
                                            <div class="stack-item-instances-wrapper">
                                            {{#each this.instances}}
                                            {{#if this.instance_of_information_store}}
                                            <div class="stack-item-instances">
                                                <div class="tech-item-wrapper">
                                                    <div class="tech-item-label">{{#essRenderInstanceMenuLink this.instance_of_information_store}}{{/essRenderInstanceMenuLink}}</div>
                                                </div>
                                                <div class="tech-detail-wrapper">
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Deployment Status')"/>:</b> <xsl:text> </xsl:text> <span class="label label-warning pulse-slow"><xsl:attribute name="style">{{#styles this.runtime_status_id}}{{/styles}}</xsl:attribute>{{this.runtime_status}}</span><br/>
                                                    {{#if this.role}}
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Deployment Role')"/>:</b> <xsl:text> </xsl:text> <span class="label label-warning pulse-slow"><xsl:attribute name="style">{{#styles this}}{{/styles}}</xsl:attribute>{{this.role}}</span><br/> 
                                                    {{/if}}
                                                    <b><xsl:value-of select="eas:i18n('Software Dependencies')"/></b><br/>
                                                    {{#each this.instance_software_dependencies}}
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Supporting Database Installation')"/></b><br/> {{this.given_name}}<br/>
                                                    <i class="fa fa-circle fa-xs" style="color:rgb(101, 203, 197)" ></i><xsl:text> </xsl:text><b><xsl:value-of select="eas:i18n('Database Installation Technology')"/></b><br/> {{this.technology_product}}<br/>
                                                    {{/each}}
                                                     
                                                </div>
                                            </div>
                                            {{/if}}
                                            {{/each}}
                                            </div>
                                        </div>
                                        {{/if}}
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="dependencies">
                                    <div class="parent-superflex">
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Node Dependencies')"/></h3>
                                        </div>
                                        <svg id="depend"></svg>
                                    </div>

                                </div>
                            
                            </div>
                        </div>
                    </div>
                </div>
                
            </script>
            <script type="text/javascript" src="technology/technology_node_summary.js"></script>
            <script>
                <xsl:call-template name="RenderViewerAPIJSFunction"> 
                   <xsl:with-param name="viewerAPIPathNodes" select="$apiPathNodes"/>
                </xsl:call-template>
            </script>
        </html>
    </xsl:template>
    
    <xsl:template name="RenderViewerAPIJSFunction">
      <xsl:param name="viewerAPIPathNodes"/>

      var viewAPIDataNodes ='<xsl:value-of select="$viewerAPIPathNodes"/>';  
       
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
     let focusNodeId='<xsl:value-of select="$param1"/>';
       
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
</xsl:stylesheet>