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
    
    <xsl:variable name="linkClasses" select="('Technology_Node', 'Application_Provider', 'Geographic_Region', 'Technology_Product', 'Technology_Node_Type', 'Business_Process', 'Application_Deployment', 'Technology_Instance','Information_Store', 'Information_Representation', 'Enterprise_Strategic_Plan', 'Project')" />
    <xsl:variable name="apiPathTechnologyProducts" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Products']"/>
    <xsl:variable name="apiPathTechnologySuppliers" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Products and Suppliers']"/>
    <xsl:variable name="apiPathAppMart" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"/>
    <xsl:variable name="apiPathPhyProcs" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
    <xsl:variable name="allPlansData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"></xsl:variable>
    <xsl:variable name="allLifecyleData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Lifecycles']"></xsl:variable>
   	<xsl:key name="overallCurrencyDefault" match="/node()/simple_instance[type='Report_Constant']" use="own_slot_value[slot_reference = 'name']/value"/>
    <xsl:variable name="overallCurrencyDefault" select="key('overallCurrencyDefault', 'Default Currency')"/> 
	<xsl:variable name="currency" select="/node()/simple_instance[type='Currency'][name=$overallCurrencyDefault/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>
    <xsl:variable name="pageLabel">
        <xsl:value-of select="eas:i18n('Technology Product Summary')" />
    </xsl:variable>
    
    <xsl:template match="knowledge_base">
        <xsl:variable name="apiPathProducts">
            <xsl:call-template name="GetViewerAPIPath">
               <xsl:with-param name="apiReport" select="$apiPathTechnologyProducts"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="apiPathProductsSuppliers">
            <xsl:call-template name="GetViewerAPIPath">
               <xsl:with-param name="apiReport" select="$apiPathTechnologySuppliers"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="apiPathAppMart">
            <xsl:call-template name="GetViewerAPIPath">
               <xsl:with-param name="apiReport" select="$apiPathAppMart"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="apiPathPhysProc">
            <xsl:call-template name="GetViewerAPIPath">
               <xsl:with-param name="apiReport" select="$apiPathPhyProcs"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="apiPlans">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$allPlansData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
        <xsl:variable name="apiLifecycles">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$allLifecyleData"></xsl:with-param>
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
                <script src="js/chartjs/Chart.min.js?release=6.19"></script>
				<script src="js/chartjs/chartjs-plugin-labels.min.js?release=6.19"></script>
				<link href="js/chartjs/Chart.css?release=6.19" type="text/css" rel="stylesheet"></link>
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

                    #map {
                        width: 100%;
                        height: 100vh;
                    }
                    .blinking {
                        animation: blinker 1s linear infinite;
                    }
                    @keyframes blinker {
                        50% {
                            opacity: 0;
                        }
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
                                    <span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Product Summary for')"/> </span>&#160;
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
     
            <script id="panel-template" type="text/x-handlebars-template">
                
                <div class="container-fluid" id="summary-content">
                    
                    <div class="row">
                        <div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
                            <ul class="nav nav-tabs tabs-left">
                                <li class="active">
                                    <a href="#details" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Product Details')"/></a>
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
                                {{#if this.functions}} 
                                <li>
                                    <a href="#functions" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Technology Functions')"/></a>
                                </li> 
                                {{/if}}

                                {{#if this.applications}} 
                                <li>
                                    <a href="#applications" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supported Applications')"/></a>
                                </li> 
                                {{/if}}

                                {{#if this.matchedProcesses}} 
                                <li>
                                    <a href="#processes" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supported Business Processes')"/></a>
                                </li> 
                                {{/if}}
                                {{#if this.infoStores}} 
                                <li>
                                    <a href="#stores" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Information Stores Supporting')"/></a>
                                </li> 
                                {{/if}}
                                {{#if this.instances}} 
                                <li>
                                    <a href="#instances" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Deployed Instances')"/></a>
                                </li> 
                                {{/if}}
                                {{#if this.usages}} 
                                <li> 
                                    <a href="#techArchs" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Technology Architectures')"/></a>
                                </li>
                                {{/if}}
                                {{#if this.costs}} 
                                <li>
                                    <a href="#costs" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></a>
                                </li> 
                                {{/if}}
                                {{#if this.plans}}
                                <li>
                                    <a href="#strategicPlans" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Strategic Plans')"/></a>
                                </li>  
                                {{/if}}
                                
                                {{#if this.documents}} 
                                <li>
                                    <a href="#docs" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Documentation')"/></a>
                                </li>  
                                {{/if}}
                            </ul>
                        </div>
                        
                        <div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
                            <div class="tab-content">
                                  <div class="tab-pane fade in active" id="details">
                                    <div class="parent-superflex">
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-server right-10"></i><xsl:value-of select="eas:i18n('Product Details')"/></h3>
                                            <label><xsl:value-of select="eas:i18n('Name')"/></label>
                                            <div class="ess-string">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
                                            {{#if this.description}}
                                            <label><xsl:value-of select="eas:i18n('Description')"/></label>
                                            <div class="ess-string">{{{breaklines this.description}}}</div>
                                            {{/if}}
                                            <div class="clearfix bottom-10"></div>
                                            
                                            {{#if this.vendor}}
                                            <label><xsl:value-of select="eas:i18n('Supplier')"/></label>
                                            <div class="ess-string">{{this.vendor}}</div>
                                            {{/if}}
                                            {{#if this.family}}
                                            {{#ifEquals this.family.length 1}}
                                            <label><xsl:value-of select="eas:i18n('Family')"/></label>
                                            {{else}}
                                            <label><xsl:value-of select="eas:i18n('Families')"/></label>
                                            {{/ifEquals}}
                                                                           
                                            {{/if}}   
                                            <ul class="ess-list-tags">
                                            {{#each this.family}}
                                                <li class="ess-list-tags">{{this.name}}</li>          
                                            {{/each}}   
                                            </ul>
                                          
                                           

                                        </div>
                                        <div class="superflex">
                                            <h3 class="text-primary"><i class="fa fa-info-circle right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
                                            {{#if this.technology_provider_delivery_model}}
                                            <label><xsl:value-of select="eas:i18n('Delivery Model')"/></label>
                                            <div class="ess-string"><xsl:attribute name="style">color:{{this.technology_provider_delivery_model.0.colour}};background-color:{{this.technology_provider_delivery_model.0.backgroundColor}}</xsl:attribute>{{this.technology_provider_delivery_model.0.name}}</div>
                                            {{/if}}
                                            {{#if this.technology_provider_lifecycle_status}} 
                                            <label><xsl:value-of select="eas:i18n('Internal Lifecycle')"/></label> <div class="ess-string"><xsl:attribute name="style">color:{{this.technology_provider_lifecycle_status.0.colour}};background-color:{{this.technology_provider_lifecycle_status.0.backgroundColor}}</xsl:attribute>{{this.technology_provider_lifecycle_status.0.name}}</div><xsl:text> </xsl:text>
                                            {{/if}}
                                            {{#if this.vendor_product_lifecycle_status}}
                                            <label><xsl:value-of select="eas:i18n('Vendor Lifecycle')"/></label> <div class="ess-string"><xsl:attribute name="style">color:{{this.vendor_product_lifecycle_status.0.colour}};background-color:{{this.vendor_product_lifecycle_status.0.backgroundColor}}</xsl:attribute>{{this.vendor_product_lifecycle_status.0.name}}</div><br/>
                                            {{/if}}
                                            {{#if lifecycles}}
                                                {{#each this.lifecycles}} 
                                                    {{#ifEquals this.dates.0.type 'Lifecycle_Status'}}
                                                    <label><xsl:value-of select="eas:i18n('Internal Lifecycle')"/></label>
                                                    <div class="ess-string"><xsl:attribute name="style">color:{{this.activeDate.colour}};background-color:{{this.activeDate.backgroundColour}}</xsl:attribute>{{this.activeDate.name}}</div> 
                                                    {{/ifEquals}}
                                                    {{#ifEquals this.dates.0.type 'Vendor_Lifecycle_Status'}}
                                                    <label><xsl:value-of select="eas:i18n('Vendor Lifecycle')"/></label>
                                                    <div class="ess-string"><xsl:attribute name="style">color:{{this.activeDate.colour}};background-color:{{this.activeDate.backgroundColour}}</xsl:attribute>{{this.activeDate.name}}</div> 
                                                    {{/ifEquals}}
                                                {{/each}}
                                            {{/if}}
                                            
                                            {{#if this.criticality}}
                                            <label><xsl:value-of select="eas:i18n('Criticality')"/></label>
                                            <div class="bottom-10">
			                                     <div class="ess-string"><xsl:attribute name="style">{{#styles this.criticalityId}}{{/styles}}</xsl:attribute>{{this.criticality}}</div>
                                            </div>                                                 
                                            {{/if}}   
                                           
                                        </div>
                                        {{#if this.stakeholders}}
                                            {{#if (anyRoleContains this.stakeholders 'Owner')}}
                                            <div class="superflex">
                                                <h3 class="text-primary"><i class="fa fa-user right-10"></i><xsl:value-of select="eas:i18n('Ownership')"/></h3>
                                                {{#each this.stakeholders}}
                                                {{#ifContains this 'Owner'}}
                                                    {{this.name}}
                                                {{/ifContains}}
                                                {{/each}}
                                                <div class="clearfix bottom-10"></div>  
                                            </div> 
                                            {{/if}}
                                        {{/if}}
                                        <div class="col-xs-12"></div>
                                        {{#if this.caps}}
                                        <div class="superflex" style="vertical-align: top">
                                            <h3 class="text-primary"><i class="fa fa-tags right-10"></i><xsl:value-of select="eas:i18n('Technology Capabilities')"/></h3>
                                            <xsl:value-of select="eas:i18n('Technology capabilities implemented by this technology product')"/><br/>
                                            <div class="tech-card-container">
                                            {{#each this.caps}}
                                                <div class="tech-card">
                                                    <div class="techlabel">Capability</div>
                                                    <div class="name">{{this.name}}</div>
                                                    <div class="description">{{this.description}}</div>
                                                    <div class="bottomText">
                                                    <div class="bText"> </div> 
                                                    </div>
                                              </div>
                                                
                                            {{/each}}
                                            </div>
                                        </div>
                                        {{/if}}
                                        {{#if this.comp}}
                                        <div class="superflex" style="vertical-align: top">
                                            <h3 class="text-primary"><i class="fa fa-tags right-10"></i><xsl:value-of select="eas:i18n('Technology Components')"/></h3>
                                            <xsl:value-of select="eas:i18n('Technology components implemented by this technology product')"/><br/>
                                            <div class="tech-card-container">
                                            {{#each this.comp}}
                                                <div class="tech-card">
                                                    <div class="techlabel"><xsl:attribute name="style">background-color:{{this.stdColour}};color:{{this.stdTextColour}}</xsl:attribute>{{#ifEquals allStandards.length 1}}{{this.std}}{{else}}{{#ifEquals allStandards.length 0}}<xsl:value-of select="eas:i18n('Not Set')"/>{{else}}<xsl:value-of select="eas:i18n('Multiple')"/>{{/ifEquals}}{{/ifEquals}}</div>
                                                    <div class="name">{{this.name}}</div>
                                                    <div class="description">{{this.description}}</div>
                                                    <div class="bottomText">
                                                      
                                                        <div class="bText">
                                                            {{#if this.technology_provider_lifecycle_status}}  
                                                            <span class="label label-default"><xsl:attribute name="style">color:{{this.technology_provider_lifecycle_status.0.colour}};background-color:{{this.technology_provider_lifecycle_status.0.backgroundColor}}</xsl:attribute>{{this.technology_provider_lifecycle_status.0.name}}</span><xsl:text> </xsl:text>
                                                            {{/if}}

                                                        </div> 
                                                    </div>
                                                    {{#ifEquals allStandards.length 0}}{{else}}
                                                   <div class="info-circle"><i class="fa fa-info-circle std-info-icon"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i></div>{{/ifEquals}}
                                                </div>
                                                
                                            {{/each}}
                                            </div>
                                        </div>
                                        {{/if}}
                                    </div>
                                    <div id="infoModal" class="stdmodal">
                                        <div class="stdmodal-content">
                                            <div class="pull-right"><span class="std-close"><i class="fa fa-times"></i></span></div>
                                            <h2><xsl:value-of select="eas:i18n('Technology Standard')"/></h2>
                                            <div id="standardsModal"></div>
                                            <!-- Add more content as needed -->
                                        </div>
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
                                            <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Deployed Instances')"/></h3>
                                            <xsl:value-of select="eas:i18n('Deployments of this technology product')"/>
                                            <div class="info-card-container">
                                            {{#each this.instances}}
                                            <div class="deployed-card">
                                                <div class="deployed-card-header">
                                                <span class="deployed-card-label">Name</span>
                                                <b>
                                                    {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                                                </b>
                                                </div>
                                                <div class="deployed-card-body">
                                                <div class="deployed-card-description">
                                                    <span class="deployed-card-label">Node</span> 
                                                    <span class="deployed-card-performer"><xsl:text> </xsl:text>{{this.node}}</span><xsl:text> </xsl:text>
                                                    <span class="deployed-card-label">Status</span> 
                                                    <span class="deployed-card-performer"><xsl:text> </xsl:text><span class="label label-default"><xsl:attribute name="style">{{#styles this.runtime_status 'Deployment_Status'}}{{/styles}}</xsl:attribute>{{this.runtime_status}}</span></span>
                                                    <br/><br/>
                                                <p>{{this.description}}</p>
                                                </div>
                                                </div>
                                            </div>
                                            {{/each}}
                                            </div>
                                        </div>
                                </div>
                            </div>
                            
                            <div class="tab-pane fade" id="dependencies">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Dependencies')"/></h3>
                                    </div>
                                    <svg id="depend"></svg>
                                </div>

                            </div>
                            {{#if this.plans}}	
                            <div class="tab-pane" id="strategicPlans">
                                <h2 class="print-only top-30"><i class="fa fa-fw fa-check-circle-o right-10"></i> <xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></h2>
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i><xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></h3>
                                        <p><xsl:value-of select="eas:i18n('Plans and projects that impact this application')"/></p>
                                        <h4><xsl:value-of select="eas:i18n('Plans')"/></h4>
                                        {{#each this.plans}}
                                            <span class="label label-success"><xsl:value-of select="eas:i18n('Plan')"/></span>&#160;<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>&#160;
                                            <span class="label label-default"><xsl:value-of select="eas:i18n('From')"/></span>&#160;	{{#if this.validStartDate}} {{#formatDate this.validStartDate}}{{/formatDate}} {{else}}<xsl:value-of select="eas:i18n('Not Set')"/>	{{/if}}
                                            <span class="label label-default"><xsl:value-of select="eas:i18n('To')"/></span>&#160;{{#if this.validEndDate}}{{#formatDate this.validEndDate}}{{/formatDate}}{{else}}<xsl:value-of select="eas:i18n('Not Set')"/>  	{{/if}}
                                            <br/>
                                        {{/each}}
                                        {{#each this.aprplans}} 
                                            <span class="label label-success"><xsl:value-of select="eas:i18n('Plan')"/></span>&#160;<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong> &#160;
                                            <span class="label label-default"><xsl:value-of select="eas:i18n('From')"/></span>&#160;	{{#if this.validStartDate}} {{#formatDate this.validStartDate}}{{/formatDate}} {{else}}<xsl:value-of select="eas:i18n('Not Set')"/>	{{/if}}
                                            <span class="label label-default"><xsl:value-of select="eas:i18n('To')"/></span>&#160;{{#if this.validEndDate}}{{#formatDate this.validEndDate}}{{/formatDate}}{{else}}<xsl:value-of select="eas:i18n('Not Set')"/>  	{{/if}}
                                            <br/>
                                        {{/each}}
                                        {{#if this.projects}} 
                                     
                                        <h4 class="mt-4 mb-3">Projects</h4>
                                        <div class="panel-group" id="accordionProjects">
                                          {{#each this.projects}}
                                            <div class="panel panel-default">
                                              <!-- Collapsible Project Header -->
                                              <div class="panel-heading" style="position:relative">
                                                <h4 class="panel-title">
                                                    <span class="label label-primary"><xsl:value-of select="eas:i18n('Project')"/></span>
                                                    <xsl:text> </xsl:text>
                                                    <strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>
                                                    
                                                    <div class="pull-right" style="position:absolute; right:3px; bottom:3px;">
                                                    <a data-toggle="collapse" data-parent="#accordionProjects"><xsl:attribute name="href">#collapse{{@index}}</xsl:attribute>
                                                            <button class="btn btn-default btn-xs toggle-btn"><xsl:value-of select="eas:i18n('More Information')"/></button>
                                                    </a>
                                                  </div>
                                                </h4>
                                                <div class="project-dates mt-3 top-5">
                                                    <span class="label label-default"><xsl:value-of select="eas:i18n('Proposed Start')"/></span>
                                                    {{#if this.proposedStartDate}}
                                                      <span class="text-muted">{{#formatDate this.proposedStartDate}}{{/formatDate}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                    
                                                    <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Actual Start')"/></span>
                                                    {{#if this.actualStartDate}}
                                                      <span class="text-muted">{{#formatDate this.actualStartDate}}{{/formatDate}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                    
                                                    <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Target End')"/></span>
                                                    {{#if this.targetEndDate}}
                                                      <span class="text-muted">{{#formatDate this.targetEndDate}}{{/formatDate}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                        
                                                    <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Forecast End')"/></span>
                                                    {{#if this.forecastEndDate}}
                                                      <span class="text-muted">{{#formatDate this.forecastEndDate}}{{/formatDate}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                  </div>
                                                  <div class="mt-3 top-5">
                                                    <span class="label label-light-grey "><xsl:value-of select="eas:i18n('Approval Status')"/></span>
                                                    {{#if this.approvalStatus}}
                                                    <span class="label label-default"><xsl:attribute name="style">{{#styler this.approvalId}}{{/styler}}</xsl:attribute>{{this.approvalStatus}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                    <span class="label label-light-grey"><xsl:value-of select="eas:i18n('Project Business Priority')"/></span>
                                                    {{#if this.priority}}
                                                     
                                                      {{#ifEquals this.priority 'High'}}
                                                      <span class="label label-danger"> {{this.priority}}</span>
                                                      {{else}}
                                                        {{#ifEquals this.priority 'Medium'}}
                                                        <span class="label label-warning"> {{this.priority}}</span>
                                                        {{else}}
                                                        <span class="label label-success"> {{this.priority}}</span>
                                                        {{/ifEquals}}
                                                      {{/ifEquals}}
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                    <span class="label label-light-grey"><xsl:value-of select="eas:i18n('Lifecycle Status')"/></span>
                                                    {{#if this.lifecycleStatus}}
                                                    <span class="label label-default"><xsl:attribute name="style">{{#styler this.lifecycleStatusID}}{{/styler}}</xsl:attribute>{{this.lifecycleStatus}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                  </div>
                                              </div>
                                        
                                              <!-- Collapsible Project Body -->
                                              <div class="panel-collapse collapse"><xsl:attribute name="id">collapse{{@index}}</xsl:attribute>
                                                <div class="panel-body">
                                                  <!-- Parent Program -->
                                                  <div class="mt-2">
                                                    <span class="label label-light-grey top-5"><xsl:value-of select="eas:i18n('EA Reference')"/></span>
                                                    {{#if this.ea_reference}}
                                                      <span class="text-muted"> {{this.ea_reference}}</span>
                                                      {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                  </div> 
                                                  <div class="mt-2">
                                                    <span class="label label-light-grey top-5"><xsl:value-of select="eas:i18n('Parent Program')"/></span>
                                                    {{#if this.programmeName}}
                                                      <span class="text-muted">{{this.programmeName}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                  </div>
                                                  
                                              
                                                  
                                                  <!-- Project Description -->
                                                  <div class="mt-2">
                                                    <span class="label label-default top-5 ms-3"><xsl:value-of select="eas:i18n('Description')"/></span>
                                                    {{#if this.description}}
                                                      <span class="text-muted">{{this.description}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                  </div>
                                        
                                                  <!-- Approval Status
                                                  <div class="mt-2">
                                                    <span class="label label-primary"><xsl:value-of select="eas:i18n('Approval Status')"/></span>
                                                    {{#if this.approvalStatus}}
                                                      <span class="text-muted">{{this.approvalStatus}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                    <span class="label label-warning"><xsl:value-of select="eas:i18n('Project Business Priority')"/></span>
                                                    {{#if this.businessPriority}}
                                                      <span class="text-muted">{{this.businessPriority}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                    <span class="label label-danger"><xsl:value-of select="eas:i18n('Lifecycle Status')"/></span>
                                                    {{#if this.lifecycleStatus}}
                                                      <span class="text-muted">{{this.lifecycleStatus}}</span>
                                                    {{else}}
                                                      <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                    {{/if}}
                                                  </div>
                                         -->
                                                 
                                                  
                                                  <!-- Project Dates -->
                                                  
                                                </div>
                                              </div>
                                            </div>
                                          {{/each}}
                                        </div>
                                        
                                        
    
                                        {{#each this.aprprojects}}
                                        <div class="panel panel-default">
                                            <!-- Collapsible Project Header -->
                                            <div class="panel-heading" style="position:relative">
                                              <h4 class="panel-title">
                                                  <span class="label label-primary"><xsl:value-of select="eas:i18n('Project')"/></span>
                                                  <xsl:text> </xsl:text>
                                                  <strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>
                                                  
                                                  <div class="pull-right" style="position:absolute; right:3px; bottom:3px;">
                                                  <a data-toggle="collapse" data-parent="#accordionProjects"><xsl:attribute name="href">#collapse{{@index}}</xsl:attribute>
                                                          <button class="btn btn-default btn-xs toggle-btn"><xsl:value-of select="eas:i18n('More Information')"/></button>
                                                  </a>
                                                </div>
                                              </h4>
                                              <div class="project-dates mt-3 top-5">
                                                  <span class="label label-default"><xsl:value-of select="eas:i18n('Proposed Start')"/></span>
                                                  {{#if this.proposedStartDate}}
                                                    <span class="text-muted">{{#formatDate this.proposedStartDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  
                                                  <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Actual Start')"/></span>
                                                  {{#if this.actualStartDate}}
                                                    <span class="text-muted">{{#formatDate this.actualStartDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  
                                                  <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Target End')"/></span>
                                                  {{#if this.targetEndDate}}
                                                    <span class="text-muted">{{#formatDate this.targetEndDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                      
                                                  <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Forecast End')"/></span>
                                                  {{#if this.forecastEndDate}}
                                                    <span class="text-muted">{{#formatDate this.forecastEndDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                                <div class="mt-3 top-5">
                                                  <span class="label label-light-grey "><xsl:value-of select="eas:i18n('Approval Status')"/></span>
                                                  {{#if this.approvalStatus}}
                                                  <span class="label label-default"><xsl:attribute name="style">{{#styler this.approvalId}}{{/styler}}</xsl:attribute>{{this.approvalStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-light-grey"><xsl:value-of select="eas:i18n('Project Business Priority')"/></span>
                                                  {{#if this.priority}}
                                                   
                                                    {{#ifEquals this.priority 'High'}}
                                                    <span class="label label-danger"> {{this.priority}}</span>
                                                    {{else}}
                                                      {{#ifEquals this.priority 'Medium'}}
                                                      <span class="label label-warning"> {{this.priority}}</span>
                                                      {{else}}
                                                      <span class="label label-success"> {{this.priority}}</span>
                                                      {{/ifEquals}}
                                                    {{/ifEquals}}
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-light-grey"><xsl:value-of select="eas:i18n('Lifecycle Status')"/></span>
                                                  {{#if this.lifecycleStatus}}
                                                  <span class="label label-default"><xsl:attribute name="style">{{#styler this.lifecycleStatusID}}{{/styler}}</xsl:attribute>{{this.lifecycleStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                            </div>
                                      
                                            <!-- Collapsible Project Body -->
                                            <div class="panel-collapse collapse"><xsl:attribute name="id">collapse{{@index}}</xsl:attribute>
                                              <div class="panel-body">
                                                <!-- Parent Program -->
                                                <div class="mt-2">
                                                  <span class="label label-light-grey top-5"><xsl:value-of select="eas:i18n('EA Reference')"/></span>
                                                  {{#if this.ea_reference}}
                                                    <span class="text-muted"> {{this.ea_reference}}</span>
                                                    {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div> 
                                                <div class="mt-2">
                                                  <span class="label label-light-grey top-5"><xsl:value-of select="eas:i18n('Parent Program')"/></span>
                                                  {{#if this.programmeName}}
                                                    <span class="text-muted">{{this.programmeName}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                                
                                                
                                                <!-- Project Description -->
                                                <div class="mt-2">
                                                  <span class="label label-default top-5 ms-3"><xsl:value-of select="eas:i18n('Description')"/></span>
                                                  {{#if this.description}}
                                                    <span class="text-muted">{{this.description}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                      
                                                <!-- Approval Status
                                                <div class="mt-2">
                                                  <span class="label label-primary"><xsl:value-of select="eas:i18n('Approval Status')"/></span>
                                                  {{#if this.approvalStatus}}
                                                    <span class="text-muted">{{this.approvalStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-warning"><xsl:value-of select="eas:i18n('Project Business Priority')"/></span>
                                                  {{#if this.businessPriority}}
                                                    <span class="text-muted">{{this.businessPriority}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-danger"><xsl:value-of select="eas:i18n('Lifecycle Status')"/></span>
                                                  {{#if this.lifecycleStatus}}
                                                    <span class="text-muted">{{this.lifecycleStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                       -->
                                               
                                                
                                                <!-- Project Dates -->
                                                
                                              </div>
                                            </div>
                                          </div>
                                        
                                        {{/each}}
                                        {{else}}
                                        {{#if this.aprprojects}} 
                                        <h4>Projects</h4>
                                        {{#each this.aprprojects}}
                                        <div class="panel panel-default">
                                            <!-- Collapsible Project Header -->
                                            <div class="panel-heading" style="position:relative">
                                              <h4 class="panel-title">
                                                  <span class="label label-primary"><xsl:value-of select="eas:i18n('Project')"/></span>
                                                  <xsl:text> </xsl:text>
                                                  <strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>
                                                  
                                                  <div class="pull-right" style="position:absolute; right:3px; bottom:3px;">
                                                  <a data-toggle="collapse" data-parent="#accordionProjects"><xsl:attribute name="href">#collapse{{@index}}</xsl:attribute>
                                                          <button class="btn btn-default btn-xs toggle-btn"><xsl:value-of select="eas:i18n('More Information')"/></button>
                                                  </a>
                                                </div>
                                              </h4>
                                              <div class="project-dates mt-3 top-5">
                                                  <span class="label label-default"><xsl:value-of select="eas:i18n('Proposed Start')"/></span>
                                                  {{#if this.proposedStartDate}}
                                                    <span class="text-muted">{{#formatDate this.proposedStartDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  
                                                  <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Actual Start')"/></span>
                                                  {{#if this.actualStartDate}}
                                                    <span class="text-muted">{{#formatDate this.actualStartDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  
                                                  <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Target End')"/></span>
                                                  {{#if this.targetEndDate}}
                                                    <span class="text-muted">{{#formatDate this.targetEndDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                      
                                                  <span class="label label-default ms-3"><xsl:value-of select="eas:i18n('Forecast End')"/></span>
                                                  {{#if this.forecastEndDate}}
                                                    <span class="text-muted">{{#formatDate this.forecastEndDate}}{{/formatDate}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                                <div class="mt-3 top-5">
                                                  <span class="label label-light-grey "><xsl:value-of select="eas:i18n('Approval Status')"/></span>
                                                  {{#if this.approvalStatus}}
                                                  <span class="label label-default"><xsl:attribute name="style">{{#styler this.approvalId}}{{/styler}}</xsl:attribute>{{this.approvalStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-light-grey"><xsl:value-of select="eas:i18n('Project Business Priority')"/></span>
                                                  {{#if this.priority}}
                                                   
                                                    {{#ifEquals this.priority 'High'}}
                                                    <span class="label label-danger"> {{this.priority}}</span>
                                                    {{else}}
                                                      {{#ifEquals this.priority 'Medium'}}
                                                      <span class="label label-warning"> {{this.priority}}</span>
                                                      {{else}}
                                                      <span class="label label-success"> {{this.priority}}</span>
                                                      {{/ifEquals}}
                                                    {{/ifEquals}}
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-light-grey"><xsl:value-of select="eas:i18n('Lifecycle Status')"/></span>
                                                  {{#if this.lifecycleStatus}}
                                                  <span class="label label-default"><xsl:attribute name="style">{{#styler this.lifecycleStatusID}}{{/styler}}</xsl:attribute>{{this.lifecycleStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                            </div>
                                      
                                            <!-- Collapsible Project Body -->
                                            <div class="panel-collapse collapse"><xsl:attribute name="id">collapse{{@index}}</xsl:attribute>
                                              <div class="panel-body">
                                                <!-- Parent Program -->
                                                <div class="mt-2">
                                                  <span class="label label-light-grey top-5"><xsl:value-of select="eas:i18n('EA Reference')"/></span>
                                                  {{#if this.ea_reference}}
                                                    <span class="text-muted"> {{this.ea_reference}}</span>
                                                    {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div> 
                                                <div class="mt-2">
                                                  <span class="label label-light-grey top-5"><xsl:value-of select="eas:i18n('Parent Program')"/></span>
                                                  {{#if this.programmeName}}
                                                    <span class="text-muted">{{this.programmeName}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                             
                                                
                                                <!-- Project Description -->
                                                <div class="mt-2">
                                                  <span class="label label-default top-5 ms-3"><xsl:value-of select="eas:i18n('Description')"/></span>
                                                  {{#if this.description}}
                                                    <span class="text-muted">{{this.description}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                      
                                                <!-- Approval Status
                                                <div class="mt-2">
                                                  <span class="label label-primary"><xsl:value-of select="eas:i18n('Approval Status')"/></span>
                                                  {{#if this.approvalStatus}}
                                                    <span class="text-muted">{{this.approvalStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-warning"><xsl:value-of select="eas:i18n('Project Business Priority')"/></span>
                                                  {{#if this.businessPriority}}
                                                    <span class="text-muted">{{this.businessPriority}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                  <span class="label label-danger"><xsl:value-of select="eas:i18n('Lifecycle Status')"/></span>
                                                  {{#if this.lifecycleStatus}}
                                                    <span class="text-muted">{{this.lifecycleStatus}}</span>
                                                  {{else}}
                                                    <span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>
                                                  {{/if}}
                                                </div>
                                       -->
                                               
                                                
                                                <!-- Project Dates -->
                                                
                                              </div>
                                            </div>
                                          </div>
                                        
                                        {{/each}}
                                        {{/if}}
                                        {{/if}}
                                        
                                    </div> 
                                </div>
                            </div>
                            {{/if}}
                            <div class="tab-pane fade" id="techArchs">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Used in Technology Architectures')"/></h3>
                                   
                                    <div class="container mt-4"> 
                                        <div  id="techarch"></div>
                                    </div>
                                </div> 
                                   
                                </div>

                            </div>
                            <div class="tab-pane" id="costs">
                                <h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></h2>
                                <div class="parent-superflex">
                                    <div class="superflex">
                                    <div class="pull-right"><b>Currency</b>: <select id="ccySelect"><option>Choose</option></select></div>
                                        <div class="costTotal-container" id="ctc"> 
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
                                        <p><xsl:value-of select="eas:i18n('Costs related to this product')"/></p>
                                        <table class="table table-striped table-bordered display compact" id="dt_costs">
                                            <thead><tr><th><xsl:value-of select="eas:i18n('Cost')"/></th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Description')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></thead>
                                            {{#each this.costs}}
                                            <tr>
                                                <td><span class="label label-primary">{{this.name}}</span></td>
                                                <td><span class="label label-primary">{{#getType this.costType}}{{/getType}}</span></td>
                                                <td>{{this.description}}</td>
                                                <td>{{#if this.component_currency}}{{this.component_currency}}{{else}}{{#if this.this_currency}}{{this.this_currency}}{{else}}{{this.currency}}{{/if}}{{/if}}{{#formatCurrency this.cost}}{{/formatCurrency}}</td>
                                                <td>{{#formatDate this.fromDate}}{{/formatDate}}</td>
                                                <td>{{#formatDate this.toDate}}{{/formatDate}}</td>
                                            </tr>
                                            {{/each}}
                                            <!--
                                            <tfoot><tr><th><xsl:value-of select="eas:i18n('Cost')"/></th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Description')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></tfoot>
                                            -->
                                        </table>
                                    </div>
                                </div>	
                            </div>
                            <div class="tab-pane fade" id="functions">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Functions')"/></h3>
                                        <p>Technology functions offered</p>
                                        {{#each this.functions}}
                                            <div class="functionCard">
                                                <span class="label label-default">Name</span><xsl:text> </xsl:text><div class="name">{{this.name}}</div>
                                                <div class="description">{{this.description}}</div>
                                                <div class="rightinfo">
                                                    <b><small>Function Type:</small></b><xsl:text> </xsl:text>
                                                    <span class="label label-info">{{this.functiontype}}</span></div>
                                            </div> 
                                        {{/each}}
                                    </div> 
                                </div>

                            </div>
                            <div class="tab-pane fade" id="applications">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Supported Applications')"/></h3>
                                        <xsl:value-of select="eas:i18n('Application(s) that are supported by this technology product')"/><br/>
                                        <div class="info-card-container">
                                        {{#each this.applications}} 
                                        <div class="app-card">
                                            <div class="app-card-header">
                                              <span class="app-card-label">Name</span>
                                              <b>
                                                {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                                              </b>
                                              <div class="pull-right"><span class="label label-light-grey label-xs">{{this.usage}}</span></div>
                                            </div>
                                            <div class="app-card-body">
                                              <div class="app-card-description">
                                                <span class="app-card-label">Status</span>
                                                <xsl:text> </xsl:text> 
                                                <label class="app-status-label"><xsl:attribute name="style">background-color: {{this.backgroundColour}}; color:{{this.colour}}</xsl:attribute>{{this.environment}}</label> 
                                              </div>
                                              {{#if this.nodes}}
                                              <div class="app-card-deployment">
                                                <b>Deployed To</b>
                                                <ul class="app-card-list">
                                                    {{#each this.nodes}}
                                                    <li class="app-card-list-item">{{this.name}}</li>
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
                            <div class="tab-pane fade" id="processes">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Processes')"/></h3>
                                        <xsl:value-of select="eas:i18n('Process(es) that are supported by this technology product')"/><br/>
                                        <div class="info-card-container">
                                        {{#each this.matchedProcesses}} 
                                        <div class="process-card">
                                            <div class="process-card-header">
                                              <span class="process-card-label">Name</span>
                                              <b>
                                                {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                                              </b>
                                            </div>
                                            <div class="process-card-body">
                                              <div class="process-card-description">
                                                <span class="process-card-label">Performed by</span> 
                                                <span class="process-card-performer"><xsl:text> </xsl:text>{{this.org}}</span>
                                              </div>
                                              {{#if this.sites}} 
                                              <div class="process-card-sites">
                                                <b>Sites performed at</b>
                                                <ul class="process-card-list">
                                                    {{#each this.sites}}
                                                    <li class="process-card-list-item">{{this.name}}</li>
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
                            <div class="tab-pane fade" id="stores">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Supports Information Stores')"/></h3>
                                        <xsl:value-of select="eas:i18n('Information store(s) that use this technology')"/>
                                        {{#each this.infoStores}}
                                        <div class="info-card">
                                            <div class="info-card-header">
                                              <span class="info-card-label">Name</span>
                                              <b>
                                                {{#essRenderInstanceMenuLink this.infoRep}}{{/essRenderInstanceMenuLink}}
                                              </b>
                                            </div>
                                            <div class="info-card-body">
                                              <div class="info-card-description">
                                                <span class="info-card-label">Status</span> 
                                                <span class="info-card-performer"><xsl:text> </xsl:text><span><xsl:attribute name="style">{{#styles this.runtime_status 'Deployment_Status'}}{{/styles}}</xsl:attribute>{{this.runtime_status}}</span></span>
                                                <br/><br/>
                                               <p>{{this.infoRep.description}}</p>
                                              </div>
                                            </div>
                                          </div>
                                        {{/each}}
                                    </div> 
                                </div>

                            </div>
                            <div class="tab-pane fade" id="docs">
                                <div class="parent-superflex">
                                    <div class="superflex">
                                        <h3 class="text-primary"><i class="fa fa-random right-10"></i><xsl:value-of select="eas:i18n('Documentation')"/></h3>
                                  
                                    
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
                            
                            </div>
                        </div>
                    </div>
                </div>
                
            </script>
            <script id="select-template" type="text/x-handlebars-template"> 
              <xsl:text> </xsl:text>{{#essRenderInstanceLinkSelect this}}{{/essRenderInstanceLinkSelect}}       
            </script>
            <script type="text/javascript" src="technology/technology_product_summary.js"></script>
            <script>
                <xsl:call-template name="RenderViewerAPIJSFunction"> 
                   <xsl:with-param name="viewerAPIPathProds" select="$apiPathProducts"/>
                   <xsl:with-param name="viewerAPIPathProdsSup" select="$apiPathProductsSuppliers"/>
                   <xsl:with-param name="viewerAPIPathAppMart" select="$apiPathAppMart"/>
                   <xsl:with-param name="viewerAPIPathPhysProc" select="$apiPathPhysProc"/>
                   <xsl:with-param name="viewerAPIPathPlans" select="$apiPlans"></xsl:with-param>
                   <xsl:with-param name="viewerAPIPathLifecycles" select="$apiLifecycles"></xsl:with-param>
                </xsl:call-template>
            </script>
            <script id="standardScope-template" type="text/x-handlebars-template">
                {{#each this}}
                <div class="standard"><xsl:attribute name="style">color:{{this.stdTextColour}};background-color:{{this.stdColour}}40</xsl:attribute>
          
                    <p><strong><xsl:value-of select="eas:i18n('Standard Strength')"/>:</strong><xsl:text> </xsl:text> <span class="label label-default"><xsl:attribute name="style">color:{{this.stdTextColour}};background-color:{{this.stdColour}};padding:2px; padding-left:4px;padding-right:4px; font-weight:bold</xsl:attribute>{{this.stdStrength}}</span></p>
                    <div class="scopes">
                        {{#ifEquals this.orgScope.length 0}}
                        {{else}}
                        <div class="org-scope">
                            <strong>Organisation Scope:</strong>
                            {{#each this.orgScope}}
                               <div class="ess-tag-info">{{this.name}}</div>
                            {{/each}}
                        </div>
                        {{/ifEquals}}
                        
                        {{#ifEquals this.geoScope.length 0}}
                        {{else}}
                        <div class="geo-scope">
                            <strong>Geographic Scope:</strong> 
                            {{#each this.geoScope}}
                                <div class="ess-tag-info">{{this.name}}</div>
                            {{/each}}  
                        </div>
                        {{/ifEquals}}
                    </div>
                </div>
                {{/each}}
            </script>
            <script id="costTotal-template" type="text/x-handlebars-template">
                <h3 class="text-primary"><i class="fa fa-money right-10"></i><b><xsl:value-of select="eas:i18n('Costs')"/></b></h3>
                
                <h3><b><xsl:value-of select="eas:i18n('Regular Annual Cost')"/></b>: <span id="regAnnual">{{this.annualCost}}</span></h3>
		            <h3><b><xsl:value-of select="eas:i18n('Regular Monthly Cost')"/></b>: <span id="regMonthly">{{this.monthlyCost}}</span></h3>
            </script>
             <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
             <script>
                var currentLang="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>";
                if (!currentLang || currentLang === '') {
                  currentLang = 'en-GB';
                }

            var rcCcyId= {ccyCode: "<xsl:value-of select="$currency/own_slot_value[slot_reference='currency_code']/value"/>", ccySymbol: "<xsl:value-of select="$currency/own_slot_value[slot_reference='currency_symbol']/value"/>", ccyName: "<xsl:value-of select="$currency/own_slot_value[slot_reference='name']/value"/>", ccyId: "<xsl:value-of select="$currency/name"/>"};
            if(rcCcyId.ccyCode==''){
              rcCcyId= {ccyCode: "USD", ccySymbol: "$", ccyName: "Dollar"}

            }
             </script>
        </html>
    </xsl:template>
    
    <xsl:template name="RenderViewerAPIJSFunction">
      <xsl:param name="viewerAPIPathProds"/>
      <xsl:param name="viewerAPIPathProdsSup"/>
      <xsl:param name="viewerAPIPathAppMart"/>
      <xsl:param name="viewerAPIPathPhysProc"/>
      <xsl:param name="viewerAPIPathPlans"></xsl:param>
      <xsl:param name="viewerAPIPathLifecycles"></xsl:param>

      var viewAPIDataProds ='<xsl:value-of select="$viewerAPIPathProds"/>';  
      var viewAPIDataProdsSuppliers ='<xsl:value-of select="$viewerAPIPathProdsSup"/>';  
      var viewAPIDataAppMart ='<xsl:value-of select="$viewerAPIPathAppMart"/>';  
      var viewAPIDataPhysProc ='<xsl:value-of select="$viewerAPIPathPhysProc"/>';  
      var viewAPIDataPlans = '<xsl:value-of select="$viewerAPIPathPlans"/>';
      var viewAPIDataLifecycles = '<xsl:value-of select="$viewerAPIPathLifecycles"/>';

      var promise_loadViewerAPIData = function(apiDataSetURL, filterCallback) {
        return new Promise(function(resolve, reject) {
            if (apiDataSetURL != null) {
                var xmlhttp = new XMLHttpRequest();
    
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState == 4 &amp;&amp; this.status == 200) {
                        var viewerData = JSON.parse(this.responseText);
    
                        // If a filterCallback is provided, apply it to filter the data
                        if (filterCallback &amp;&amp; typeof filterCallback === "function") {
                            viewerData = filterCallback(viewerData);
                        }
    
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
     let focusProductId='<xsl:value-of select="$param1"/>';
      
        
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