<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	 <xsl:include href="../common/core_roadmap_functions.xsl"></xsl:include>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:include href="../common/core_handlebars_functions.xsl"/>
    
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider','Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
    <xsl:variable name="allInfoReps" select="/node()/simple_instance[type=('Information_Representation')]"/>

	<xsl:variable name="allArchUsages" select="/node()/simple_instance[type='Static_Application_Provider_Usage']"/>
    <xsl:variable name="allAPUs" select="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']"/>
	<xsl:key name="allArchUsagesKey" match="/node()/simple_instance[type='Static_Application_Provider_Usage']" use="name"/>
	<xsl:key name="allSAKey" match="/node()/simple_instance[supertype='Application_Provider']" use="own_slot_value[slot_reference='ap_static_architecture']/value"/>
	<xsl:key name="allAppsforSAKey" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]" use="name"/>
	<xsl:key name="allAppProtoInfoKey" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION','APP_PRO_TO_INFOREP_EXCHANGE_RELATION')]" use="name"/>
	<xsl:key name="allInfoRepKey" match="/node()/simple_instance[type=('Information_Representation')]" use="name"/>
	
    <xsl:variable name="allAppProtoInfo" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_RELATION'][name=$allAPUs/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
    <xsl:variable name="allInfo" select="/node()/simple_instance[type='Information_Representation'][name=$allAppProtoInfo/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>

	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="infoData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"></xsl:variable>
	<xsl:variable name="appMartData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"></xsl:variable>

<!--	* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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

	

		D3 License
		Copyright 2010-2023 Mike Bostock

		Permission to use, copy, modify, and/or distribute this software for any purpose
		with or without fee is hereby granted, provided that the above copyright notice
		and this permission notice appear in all copies.

		THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
		REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
		FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
		INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
		OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
		TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
		THIS SOFTWARE.

		JS Tree License 
		Copyright (c) 2020 Ivan Bozhanov (http://vakata.com)

		Dagre D3 license
		Copyright (c) 2013 Chris Pettitt

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in
		all copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
		THE SOFTWARE.
	-->
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
  

	<xsl:template match="knowledge_base">
			<xsl:variable name="apiApps">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="apiInfo">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$infoData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="apiappMart">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$appMartData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<link rel="stylesheet" href="js/jstree/themes/default/style.min.css" />
				<script src="js/jstree/jstree.min.js?release=6.19"/>
				<script src="js/d3/d3.v5.9.7.min.js?release=6.19"/>
                <script src="js/dagre/dagre.min.js?release=6.19"></script>
				<script src="js/dagre/dagre-d3.min.js?release=6.19"></script> 
 
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Data Dependencies</title>
                  <style>
					#tooltip {
						z-index: 1000;
					}
                	.clusters rect {
                          fill: #00ffd0;
                          stroke: #999;
                          stroke-width: 1.5px;
                        }

                        text {
                          font-weight: 300;
                          font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
                          font-size: 10px;
                        }

                        .node rect {
                          stroke: #999;
                          fill: #fff;
                          stroke-width: 1.5px;
                        }

                        .edgePath path {
                          stroke: #333;
                          stroke-width: 1.5px;
                        }
                 	
					   .ds {
						display: inline-block;
						 min-width: 100px;
						 background-color:#ffffff;
						 width: 100%;
						 border-radius:3px;
						 color:#000000;
						 text-transform: uppercase;
						 min-height:20px;
						 font-weight:700;
						 vertical-align: middle;
						 padding: 5px;
						 font-size:12px;
						 border-radius: 4px;
						 margin-bottom: 4px;
					  }

					  .dw{
					 	border:1px solid #ccc;
						margin-top:4px;
						color:#000;
						width: 100%;
						background-color:#ffffff;
						padding: 5px;
						font-size:12px;
						border-radius: 4px;
					  }

					  span.tp {
						display: inline-block;
						 font-weight:normal;
					  	color:#000;
					  }
					  span.tc {
						display: inline-block;
						 font-weight:normal;
					  	color:#000;
					  }

					 .apibadge {
						 border-radius:4px;
						 background-color: #7b0071;
						 color:#fff;
						 font-size:0.8em;
					 }
					 .appbadge {
						 border-radius:4px;
						 background-color: #333;
						 color:#fff;
						 padding: 5px;
					 }
					 
					 .key  {
						top: -30px;
						position: relative;
					}
					.infoBox{
						height:0px;
						display:none;
						opacity:0;
					}
					.selectBox{
						display:inline-block;
					}
					.apptype{
						display: flex;            /* Enables flexbox */
    					justify-content: center;  /* Centers content horizontally */
    					align-items: center;  
						border-radius:36px;
						border:2pt solid #d3d3d3;
						width:20px;
						height:20px;
						position:relative; 
						display:inline-block;

					}
					.enumLozenge{
						border-radius: 6px;
						margin:2px;
						padding:2px;
					}

					#slideupPanel {
						background-color: rgba(0,0,0,0.85);
						padding: 10px;
						border-top: 1px solid #ccc;
						position: fixed;
						bottom: 0;
						left: 0;
						z-index: 100;
						width: 100%;
						height: 350px;
						color: #fff;
					}

					#zoomWarning {
						position: absolute; /* Use absolute positioning */
						top: 10%; /* Position the top edge of the div in the center of the screen */
						left: 50%; /* Position the left edge of the div in the center of the screen */
						transform: translate(-50%, -50%); /* Adjust the div's position to be truly centered */
						
						/* Optional styles for your div */
						padding: 20px;
						background-color: red; /* Just for visibility */
						border-radius: 5px;
						box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
						text-align: center; /* Centers the text inside the div */
						color:white;
						z-index:1000;
					  }
			 
					  /* The sidepanel (hidden by default) */
					  .sidepanel {
						  height: 100%;
						  width: 0;
						  position: fixed;
						  z-index: 1002; /* Ensure it's above other content */
						  top: 0;
						  right: 0;
						  background-color: #111;
						  overflow-x: hidden;
						  transition: 0.5s;
						  padding-top: 60px;
					  }
					  
					  /* Handle to open the sidepanel */
					  .handle {
						  position: fixed; /* changed to fixed */
						  right: 30px; /* position on the right edge */
						  top: 30%; /* vertically centered */
						  z-index: 3; /* higher z-index to be on top */
						  background-color: #333;
						  color: white;
						  padding: 5px 10px;
						  cursor: pointer;
						  text-align: center;
						  border-radius: 5px 0 0 5px; /* rounded corners on the left */
						  transform: translateX(100%); /* move it right so it's visible */
						  transition: 0.5s;
					  }
					  
					  /* Close button */
					  .closebtn {
						  position: absolute;
						  top: 0;
						  right: 25px;
						  font-size: 36px;
						  cursor: pointer;
					  }
					  .appData{
						color:white;
						font-size:0.9em;
						padding:3px;
						border:1pt solid #d3d3d3;
						margin:2px;
					  }
.stakeholdersbox{

	position: relative;
	display: inline-block;
    width: 24%;
	border:1pt solid #d3d3d3;
	border-radius: 6px;
	margin:2px;
	padding:3px;
	vertical-align:top;
}
.summarybox{
	position: relative;
	display: inline-block;
    width: 24%;
	border:1pt solid #d3d3d3;
	background-color:#ffffff;
	color:#000;
	border-radius: 6px;
	margin:2px;
	padding:3px;
	vertical-align:top;
} 
.boxBadge{
    position: absolute;
    width: 25px;
    height: 25px;
    border: 1pt solid #ffffff;
    background-color: #d01e1e;
    border-radius: 36px;
    right: 3px;
    top: 4px;
    display: flex;
    justify-content: center;
    align-items: center;
}

#scrollToTop {
  display: flex; /* Use Flexbox */
  justify-content: center; /* Center horizontally */
  align-items: center; /* Center vertically */
  position: fixed; /* Fixed position */
  bottom: 20px; /* 20px from the bottom */
  left: 30px; /* 30px from the left */
  z-index: 99;
  border: none;
  outline: none;
  background-color: rgb(28, 28, 28);
  color: white;
  cursor: pointer;
  padding: 15px;
  border-radius: 10px;
  font-size: 16px; /* Adjust as per your icon size */
  width: 28px; /* Width of the div */
  height: 28px; /* Height of the div */
}


#scrollToTop:hover {
  background-color: #cf3c3c;
}

.keyBox{
	border:1pt solid #ffffff;
	border-radius:5px;
	padding:3px;
	margin: 2px;
	position: relative;
}

.keyBox .keyTitle {
    position: absolute;
    top: 30px;
    left: 0;
    transform: rotate(-90deg);
    transform-origin: left top;
    white-space: nowrap;
}
.keyBox i {
	padding-left: 25px;
    text-align: center;
    display: inline-block;
}

                </style>
 			 </head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/> 
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
			 
				<!--ADD THE CONTENT-->
				<div class="container-fluid" id="container">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Connections')"/></span>
								</h1>
							</div>
						
						</div>

						<xsl:text> </xsl:text>						
						<input class="show_all"  style="margin-left:20px" type="radio" id="show_all" name="view_mode" value="show_all" checked="true"/>
    					<label class="show_all" for="show_all"><xsl:value-of select="eas:i18n('Show All')"/></label>
					    <input class="show_all" type="radio" id="by_application" name="view_mode" value="by_application"/>
    					<label class="show_all" for="by_application"><xsl:value-of select="eas:i18n('Filtered')"/></label>
						<xsl:text> </xsl:text>

						<div class="selectBox appBox">
						<small><xsl:value-of select="eas:i18n('Choose by Application')"/></small><br/>
						<select id="appList"><option value="All"><xsl:value-of select="eas:i18n('All')"/></option></select>
						</div>
						<div class="selectBox appBox">
						<small><xsl:value-of select="eas:i18n('Depth')"/></small><br/>
							<select id="depthSelector">
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option> 
							</select>
						</div>
						<div class="selectBox appBox">
							<small><xsl:value-of select="eas:i18n('Choose by Application Capability')"/></small><br/>
							<select id="appCapList"><option value="All"><xsl:value-of select="eas:i18n('Choose')"/></option></select>
						</div>
						<div class="pull-right right-20">
							<b>ZOOM:</b><xsl:text> </xsl:text>
							<button id="zoom_in"><i class="fa fa-plus-square"></i></button>
							<button id="zoom_out"><i class="fa fa-minus-square"></i></button>
						</div>
					<!--	
						<div class="selectBox">
							<small>Choose by Information</small><br/>
							<select id="infoRepList"><option value="All">All</option></select>
						</div>

					-->
						<div class="selectBox">
							<small><xsl:value-of select="eas:i18n('Choose by Data Object')"/></small><br/>
							<select id="dataObjList"><option value="Choose"><xsl:value-of select="eas:i18n('Choose')"/></option></select>
						</div>
						<xsl:text> </xsl:text>
						<!--
						<label for="connectedApps"><xsl:value-of select="eas:i18n('Show Unconnected Apps')"/></label>
						<input type="checkbox" id="connectedApps" />
						-->
						<div id="warning" style="color:red"><b><xsl:value-of select="eas:i18n('There are too many nodes to show the whole network, select filter when data ready')"/></b></div>
						<!--
						<div class="pull-right"><button class="btn btn-warning btn-xs" id="saveButton"><i class="fa fa-floppy-o fa-xs"></i> Save</button><button class="btn btn-warning btn-xs" id="printButton"><i class="fa fa-floppy-o fa-xs"></i> PDF</button></div>
						-->
						<div id="zoomWarning"><xsl:value-of select="eas:i18n('You may need to zoom out and drag to see the full image')"/></div>
									<div id="diagram"></div>
					</div>
				</div>
			<div class="slideupPanel" id="slideupPanel" style="overflow-y: auto;">
				<div class="pull-right"><i class="fa fa-times closePanelButton"></i></div>
				<div class="col-xs-3">
					<div class="keyBox">
						<div class="keyTitle"><xsl:value-of select="eas:i18n('Key')"/></div>
						<i class="fa fa-book"></i> <xsl:value-of select="eas:i18n('Information Representation')"/><br/>
						<i class="fa fa-file-text-o"></i> <xsl:value-of select="eas:i18n('Information View')"/><br/>
						<i class="fa fa-bars"></i> <xsl:value-of select="eas:i18n('Data Object')"/>
					</div>
						<div id="jstree_div"/>
					<!--	<div id="infoData"></div>
					-->
				</div>
				<div class="col-xs-9" id="summaryBox" style="border:1px solid #ffffff; border-radius:6px;">
				
					<div id="dataSummary"/>
				</div>
				
			</div>
			<div id="infoSidepanel" class="sidepanel">
				<div id="dataList"/>
				<span class="handle"><i class="fa fa-file-text-o" aria-hidden="true"></i></span>
			</div>
			<div id="scrollToTop"><i class="fa fa-arrow-up"></i></div>
<script id="data-summary-template" type="text/x-handlebars-template">
	<h4>	<div class="boxBadge" style="left:3px"><i class="fa fa-info"></i></div><div style="display:inline-block; margin-left:20px">{{this.name}}</div></h4>
	
	<div class="summarybox">
		<b><xsl:value-of select="eas:i18n('Description')"/></b>: {{this.description}}<br/>		
		<b><xsl:value-of select="eas:i18n('Category')"/></b>: {{this.category}}<br/>						
		<b><xsl:value-of select="eas:i18n('Parent(s)')"/></b>:{{#each this.parents}}{{this.name}}{{#unless @last}},{{/unless}}{{/each}}<br/>
	</div>
	{{#if this.dataAttributes}}
	<div class="stakeholdersbox">
		<div class="boxBadge">
		<i class="fa fa-tags"></i>
		</div> <b><xsl:value-of select="eas:i18n('Attribute(s)')"/></b><br/>
			{{#each this.dataAttributes}}
			<xsl:text> </xsl:text> 
			<i class="fa fa-caret-right"></i>
			<xsl:text> </xsl:text> {{this.name}}<br/>
			{{/each}}
	</div>
	{{/if}}
	{{#if this.systemOfRecord}}
	<div class="stakeholdersbox">
		<div class="boxBadge">
		<i class="fa fa-id-card-o"></i>
		</div> <b><xsl:value-of select="eas:i18n('System of Record(s)')"/></b><br/>
			{{#each this.systemOfRecord}}
			<xsl:text> </xsl:text> 
			<i class="fa fa-caret-right"></i>
			<xsl:text> </xsl:text> {{this.name}}<br/>
			{{/each}}
	</div>
	{{/if}}
	{{#if this.stakeholders}}
	<div class="stakeholdersbox">
		<div class="boxBadge">
		<i class="fa fa-user-circle"></i>
		</div> <b><xsl:value-of select="eas:i18n('Stakeholder(s)')"/></b><br/>
			{{#each this.stakeholders}}
			<xsl:text> </xsl:text> 
			<i class="fa fa-caret-right"></i>
			<xsl:text> </xsl:text> {{this.actorName}} : {{this.roleName}}<br/>
			{{/each}}
	</div>
	{{/if}}
</script>
<script id="data-template" type="text/x-handlebars-template">
	{{#each this}}
	<div class="appData"><xsl:attribute name="style">{{#ifEquals this.inDiagram 'yes'}}background-color:#a8325e;color:white{{/ifEquals}}</xsl:attribute>{{this.source.name}} <i class="fa fa-arrow-right" aria-hidden="true"></i> {{this.target.name}}</div>		
	{{/each}}
</script>
<script id="node-template" type="text/x-handlebars-template">
	<!--
	<div class="apptype">
		{{#ifEquals this.className 'Application_Provider_Interface'}}
		<i class="fa fa-plug" style="color:#c176df"/>
		{{else}}
		<i class="fa fa-desktop" style="color:green"/>
		{{/ifEquals}}
	</div>
--> 
		{{#ifEquals this.className 'Application_Provider_Interface'}}
		<i class="fa fa-exchange" style="color:#c176df;"/>
		{{else}}
		<i class="fa fa-desktop" style="color:#c176df"/>
		{{/ifEquals}}
		<xsl:text> </xsl:text>
		<span style="color:black">{{{wrapName this.name}}}
	<!-- {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}-->
		</span><xsl:text> </xsl:text>
		<i class="fa fa-search focusApp" style="color:blue"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i><br/>
	 	{{#if this.ap_codebase_status.[0]}}
		<div class="enumLozenge"><xsl:attribute name="style">background-color:{{this.ap_codebase_status.[0].backgroundColor}};color:{{this.ap_codebase_status.[0].colour}}</xsl:attribute>
			<i class="fa fa-code"><xsl:attribute name="style">color:{{this.ap_codebase_status.[0].colour}}</xsl:attribute></i><xsl:text> </xsl:text>
			{{this.ap_codebase_status.[0].enum_name}}</div>
		{{/if}}
		{{#if this.ap_delivery_model.[0]}}	
		<div class="enumLozenge"><xsl:attribute name="style">background-color:{{this.ap_delivery_model.[0].backgroundColor}};color:{{this.ap_delivery_model.[0].colour}}</xsl:attribute>
			<i class="fa fa-truck"><xsl:attribute name="style">color:{{this.ap_codebase_status.[0].colour}}</xsl:attribute></i><xsl:text> </xsl:text>
			{{this.ap_delivery_model.[0].enum_name}}</div>
		{{/if}}
	  
	
</script>	
<script id="edge-template" type="text/x-handlebars-template"> 

	{{#each this.label}}
	<span style="color:green"><xsl:attribute name="data-id">{{this.id}}</xsl:attribute><xsl:attribute name="easid">{{../this.source}}-{{../this.target}}</xsl:attribute>{{this.name}}</span>{{#unless @last}},{{/unless}}<br/>
	{{/each}}
</script>	
<style>
	.info-container {
		font-family: Arial, sans-serif;
		margin: 10px;
		color:black;
	}
	
	.info-container h3 {
		color: #333;
		margin-bottom: 10px;
	}
	
	.info-table, .inner-table {
		width: 100%;
		border-collapse: collapse;
	}
	
	.info-table td, .inner-table td {
		border-bottom: 1px solid #ddd;
		padding: 8px;
		background-color: #f2f2f2;
	}
	
	.info-name, .view-name {
		font-weight: bold;
		background-color: #f2f2f2;
		vertical-align:top;
	}
	
	.data-object-list {
		list-style-type: none;
		padding-left: 0;
		margin: 0;
		vertical-align:top;
		background-color: #f2f2f2;
	}
	.info-name-head{
		background-color:#d3d3d3;
		color:black;
	}

</style>	
<script id="info-template" type="text/x-handlebars-template">
    <div class="info-container">
        <h3 style="color:white">{{toApp}} to {{fromApp}}</h3>
        <table class="info-table">
			<tr><th class="info-name-head"> <xsl:value-of select="eas:i18n('Information Representation')"/></th><th class="info-name-head"></th></tr>
            {{#each infoView}}
                <tr>
                    <td class="info-name">{{name}}</td>
                    <td>
                        <table class="inner-table">
							<tr><th class="view-name"> <xsl:value-of select="eas:i18n('Information Views')"/></th><th><xsl:value-of select="eas:i18n('Data Objects')"/></th></tr>
                            {{#each this.views}}
                                <tr>
                                    <td class="view-name">{{name}}</td>
                                    <td>
                                        <ul class="data-object-list">
                                            {{#each this.dataObjects}}
                                                <li>{{this.name}}</li>
                                            {{/each}}
                                        </ul>
                                    </td>
                                </tr>
                            {{/each}}
                        </table>
                    </td>
                </tr>
            {{/each}}
        </table>
    </div>
</script>


<script>
 
var apus = [<xsl:apply-templates select="$allAPUs" mode="allAPUs"/>];
var appList, appListMap, appListMapScoped;
var infoList <!--[<xsl:apply-templates select="$allInfoReps" mode="allApps">
	<xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
</xsl:apply-templates>]; -->
 

 
var inner, svg;
var nodes=[];
var edges=[];

$(window).scroll(function() {
    if ($(this).scrollTop() > 200) {
      $('#scrollToTop').fadeIn(200);
    } else {
      $('#scrollToTop').fadeOut(200);
    }
  });
 
  // Animate the scroll to top
  $('#scrollToTop').click(function(event) {
    event.preventDefault();
    
    $('html, body').animate({scrollTop: 0}, 300);
  })

</script>
	</body>
	<script>			
		<xsl:call-template name="RenderViewerAPIJSFunction"> 
			<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
			<xsl:with-param name="viewerAPIPathInfo" select="$apiInfo"></xsl:with-param>   
			<xsl:with-param name="viewerAPIPathAppMart" select="$apiappMart"></xsl:with-param>
		</xsl:call-template>  
	</script>
</html>
</xsl:template>
<xsl:template match="node()" mode="allApps">
	{
		"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:value-of select="current()/own_slot_value[slot_reference=('name', 'relation_name', ':relation_name')]/value"/>"
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="allAPUs">
	<xsl:variable name="thisFrom" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':FROM']/value)"/>
	<xsl:variable name="thisTo" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':TO']/value)"/>
	<xsl:variable name="fromApp" select="key('allAppsforSAKey', $thisFrom/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
	<xsl:variable name="toApp" select="key('allAppsforSAKey', $thisTo/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
	<xsl:variable name="edgeInfo" select="key('allAppProtoInfoKey', current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value)"/>
	<xsl:variable name="edgeInfoIndirect" select="key('allAppProtoInfoKey', $edgeInfo/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value)"/>
	<xsl:variable name="allInfoEdges" select="$edgeInfo union $edgeInfoIndirect"/>
	<xsl:variable name="thisInfoReps" select="key('allInfoRepKey', $allInfoEdges/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value)"/>
	

{
"id":"<xsl:value-of select="current()/name"/>",
<xsl:variable name="temp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = (':relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
"edgeName":"<xsl:value-of select="$fromApp/name"/> to <xsl:value-of select="$toApp/name"/>",
"fromAppId":"<xsl:value-of select="$fromApp/name"/>",
"toAppId":"<xsl:value-of select="$toApp/name"/>",
<xsl:variable name="ftemp" as="map(*)" select="map{'fromApp': string(translate(translate($fromApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
<xsl:variable name="fresult" select="serialize($ftemp, map{'method':'json', 'indent':true()})"/>  
<xsl:value-of select="substring-before(substring-after($fresult,'{'),'}')"></xsl:value-of>,
<xsl:variable name="ttemp" as="map(*)" select="map{'toApp': string(translate(translate($toApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
<xsl:variable name="tresult" select="serialize($ttemp, map{'method':'json', 'indent':true()})"/>  
<xsl:value-of select="substring-before(substring-after($tresult,'{'),'}')"></xsl:value-of>,
"info":[<xsl:for-each select="$thisInfoReps">
	{
		"id":"<xsl:value-of select="current()/name"/>",
		<xsl:variable name="infoTemp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
		<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of>,
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:for-each>]
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

	<xsl:template name="GetViewerAPIPath">
		<xsl:param name="apiReport"></xsl:param>

		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderAPILinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$dataSetPath"></xsl:value-of>

	</xsl:template>
	<xsl:template name="RenderViewerAPIJSFunction"> 
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathInfo"></xsl:param>
		<xsl:param name="viewerAPIPathAppMart"></xsl:param>
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>'; 
		var viewAPIDataInfo = '<xsl:value-of select="$viewerAPIPathInfo"/>'; 
		var viewAPIDataAppMart = '<xsl:value-of select="$viewerAPIPathAppMart"/>'; 
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
		<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
		var promise_loadViewerAPIData = function (apiDataSetURL)
		{
			return new Promise(function (resolve, reject)
			{
				if (apiDataSetURL != null)
				{
					var xmlhttp = new XMLHttpRequest();
					xmlhttp.onreadystatechange = function ()
					{
						if (this.readyState == 4 &amp;&amp; this.status == 200){
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
							$('#ess-data-gen-alert').hide();
						}
						
					};
					xmlhttp.onerror = function ()
					{
						reject(false);
					};
					
					xmlhttp.open("GET", apiDataSetURL, true);
					xmlhttp.send();
				} else
				{
					reject(false);
				}
			});
		}; 

	function updateObjectsWithFilters(objects, filter) {
		// Iterate through each object
		objects.forEach(obj => {
			// Check if the slotName exists and is an array
			if (obj.slotName &amp;&amp; Array.isArray(obj[obj.slotName])) {
				// Update each id in the array
				obj[obj.slotName] = obj[obj.slotName].map(id => {
					// Find the matching value in the filter
					const matchingFilterValue = filter.values.find(value => value.id === id);
	
					// Return the original id or the updated value
					return matchingFilterValue || id;
				});
			}
		});
	
		return objects;
	}	

	var depthType, scopedNodes, scopedEdges;
		
	$('document').ready(function (){
		$('#appList, #infoRepList, #dataObjList, #appCapList').select2({width: '250px'})
		$('#depthSelector').select2({width: '30px'})
		$('.slideupPanel').hide();
		$('.appBox').hide();
		$('#warning').hide();
		$('#summaryBox').hide()
		$('.handle').hide().animate({right: '0'}, 'medium');;
 
		setTimeout(function() {
			$('#zoomWarning').hide();  // This will hide the element after 10 seconds
		}, 4000);

		Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('wrapName', function(name) {
			if (name.length &lt;= 30) {
				return name;
			} else {
				let wrappedName = '';
				let words = name.split(' ');
				let currentLine = '';
		
				words.forEach(function(word) {
					if ((currentLine + word).length &lt;= 30) {
						currentLine += word + ' ';
					} else {
						wrappedName += currentLine + '<br/>';
						currentLine = word + ' ';
					}
				});
		
				return wrappedName + currentLine; // Add the last line
			}
		});
		
		$('.handle').click(function(){
			var panelWidth = $('#infoSidepanel').width();
			if (panelWidth > 0) {
				// If the panel is open (width > 0), close it
				$('#infoSidepanel').css('width', '0');
				$('.handle').css('top', '30%');
			} else {
				// If the panel is closed (width = 0), open it
				$('#infoSidepanel').css('width', '250px');
				$('.handle').css('top', '10px');
			}
		});
	

			Promise.all([ 
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataInfo),
			promise_loadViewerAPIData(viewAPIDataAppMart) 
			]).then(function (responses)
			{
			appList = responses[0].applications.concat(responses[0].apis);
			
			appListMap  = new Map(appList.map(app => [app.id, app]));
			
			appList=appList.sort((a, b) => {
				const nameA = a.name.toLowerCase(); // Converting to lowercase for a case-insensitive comparison
				const nameB = b.name.toLowerCase();
				return nameA &lt; nameB ? -1 : nameA > nameB ? 1 : 0;
			  });
			filters=responses[0].filters;
			responses[0].filters.sort((a, b) => (a.id > b.id) ? 1 : -1)
	 

			let appCaps=responses[2].application_capabilities;
			let appSvcs=responses[2].application_services;

			const servicesWithAppIds = appSvcs.map(service => ({
				id: service.id,
				apps: service.APRs.map(apr => apr.appId)
			}));
			
			appCaps.forEach(cap => {
				cap['thisApps']=[];
				  cap.supportingServices.map(supportingServiceId => {
					const matchingService = servicesWithAppIds.find(service => service.id === supportingServiceId);
					
					if (matchingService.apps) { 
						cap.thisApps= [...new Set([...cap.thisApps, ...matchingService.apps])];
					} else {
				
					}
				});

			function getAllKidAppCaps(appCaps, thisappcapId) {
				return appCaps.filter(appCap => 
					appCap.ParentAppCapability.some(cap => 
						cap.id === thisappcapId
					)
				);
			}
			
				let getKidAppCaps= getAllKidAppCaps(appCaps,cap.id)
			
				getKidAppCaps.forEach((a)=>{
					if(a.thisApps){
						cap.thisApps= [...new Set([...cap.thisApps, ...a.thisApps])];
					}
				})

			});

			let infoReps=responses[1].information_representation;
			let infoViews=responses[1].information_views;
			let dataObjects=responses[1].data_objects;

			dataObjects=dataObjects.sort((a, b) => {
				const nameA = a.name.toLowerCase(); // Converting to lowercase for a case-insensitive comparison
				const nameB = b.name.toLowerCase();
				return nameA &lt; nameB ? -1 : nameA > nameB ? 1 : 0;
			  });
			// Create a map for direct access by 'id' from 'infoViews'
			const infoViewsMap = new Map(infoViews.map(e => [e.id, e]));

			infoReps.forEach(i => {
				i.infoViews.forEach(d => {
					let match = infoViewsMap.get(d.id);
					
					if (match) {
						if (!match.infoReps) {
							match.infoReps = [];
						}
						match.infoReps.push(i.id);
				
					}
				});
			});

			const infoRepsMap = new Map();

			// Populate the map for mapping views
			infoViews.forEach(item => {
				item.infoReps?.forEach(infoRepId => {
					if (!infoRepsMap.has(infoRepId)) {
						infoRepsMap.set(infoRepId, { id: infoRepId, views: [] });
					}
					const view = {
						id: item.id,
						name: item.name,
						dataObjects: item.dataObjects
					};
					infoRepsMap.get(infoRepId).views.push(view);
				});
			});

			// Convert the map back into an array
			const newInfoRepsArray = Array.from(infoRepsMap.values());
 

// Iterate over the 'apus' array
apus.forEach(apu => { 
	if(apu.fromApp == '' || apu.toApp ==''){
		delete(apu)
	}else{
    apu.info.forEach(infoId => { 
        let match = newInfoRepsArray.find((s)=> {return s.id == infoId.id});
		 
        if (match) {
            // Check if 'infoView' property exists, if not initialize it
            if (!apu.infoView) {
                apu.infoView = [];
            }
			match['name']=infoId.name
            // Append the matched 'infoView' and its 'dataObjects' to 'infoRep'
            apu.infoView.push(match);
        }
    });

 
	apu.dataObjects = [];

	// Iterate through each 'infoView' and accumulate 'dataObjects'
			apu.infoView?.forEach(infoViewItem => {
			infoViewItem.views?.forEach(view => {
				view.dataObjects.forEach(dataObject => {
					// Prevent duplicate entries
				apu.dataObjects.push(dataObject);
			
				});
			});
		});
		apu.dataObjects= Array.from(new Map(apu.dataObjects.map(item => [item.id, item])).values());
		 
		apu.dataObjects.forEach((o)=>{
	 
			matchDO=dataObjects.find((d)=>{
				return d.id ==o.id
			});
			o['name']=matchDO.name;
		})
	}
});
 
			dynamicAppFilterDefs=filters?.map(function(filterdef){
				return new ScopingProperty(filterdef.slotName, filterdef.valueClass)

			});
			
			// Pre-compute a lookup table for each filter's values
			const valueLookups = filters.reduce((acc, filter) => {
				acc[filter.slotName] = filter.values.reduce((valAcc, value) => {
					valAcc[value.id] = value;
					return valAcc;
				}, {});
				return acc;
			}, {});

		 
			let optionsHtmlData = dataObjects.map(e => `<option value="`+e.id+`">${e.name}</option>`).join('');
			let optionsInfoHtml = '<option value="All">All</option>'
			let optionsInfoChooseHtml = '<option value="choose">Choose</option>'
			let optionsHtmlInfo = infoReps.map(e => `<option value="`+e.id+`">${e.name}</option>`).join('');
			$('#infoRepList').html(optionsInfoHtml + optionsHtmlInfo);
			$('#dataObjList').html(optionsInfoChooseHtml + optionsHtmlData);
			let appMax=1000;
			appList.forEach((e,i) => {
				
				// Iterate over each slotName in valueLookups
				Object.keys(valueLookups).forEach(slotName => {
					// Check if the current object has the property matching the slotName
					if (e.hasOwnProperty(slotName) &amp;&amp; Array.isArray(e[slotName])) {
						// Update each ID in the array with the corresponding value from the lookup table
						e[slotName] = e[slotName].map(id => valueLookups[slotName][id] || id);
					}
				});

				let appContent={
					"id": e.id,
					"name": e.name, 
					"ap_codebase_status":e.ap_codebase_status,
					"ap_delivery_model":e.ap_delivery_model,
					"className": e.className				
				}
				 
				// Update nodes and DOM elements
					nodes.push({ id: e.id, label: e.name, content: appContent });
				
			});
			
			// Build and append HTML for options
			let optionsHtml = '<option value="All">All</option>'
			let optionsChooseHtml = '<option value="All">Choose</option>'
			let optionsHtmlApps = appList.map(e => `<option value="`+e.id+`">${e.name}</option>`).join('');
			if(nodes.length&lt;3000){
				$('#appList').html(optionsHtml + optionsHtmlApps);
			}else{
				$('#appList').html(optionsHtmlApps);
			}
			const opt=optionsHtmlApps
 
			let optionsHtmlAppCaps = appCaps.map(e => `<option value="`+e.id+`">${e.name}</option>`).join('');
			$('#appCapList').html(optionsChooseHtml + optionsHtmlAppCaps);
			
	 
	
	apus.forEach((e)=>{ 
		if(e.toAppId &amp;&amp; e.fromAppId){
			edges.push( {source: e.toAppId, target: e.fromAppId, label:e.info })
		}
	})


	const allNodes=nodes;
	const allEdges=edges;
	
	
//$('#infoBox').hide();

var dataFragment = $("#data-template").html();	
	dataTemplate = Handlebars.compile(dataFragment);

	var dataSumFragment = $("#data-summary-template").html();	
	datasummaryTemplate = Handlebars.compile(dataSumFragment);
	

	var nodeFragment = $("#node-template").html();
	nodeTemplate = Handlebars.compile(nodeFragment);
	
	var edgeFragment = $("#edge-template").html();
	edgeTemplate = Handlebars.compile(edgeFragment);

	var infoFragment = $("#info-template").html();
	infoTemplate = Handlebars.compile(infoFragment);



function centerGraph() {

	<!--
	// Step 1: Get SVG dimensions
    const svgWidth = svg.node().getBoundingClientRect().width;
    const svgHeight = svg.node().getBoundingClientRect().height;

    // Step 2: Get content (graph) dimensions
    const graphWidth = g.graph().width;
    const graphHeight = g.graph().height;

    // Step 3: Calculate center position
    const xOffset = (svgWidth - graphWidth) / 2;
    const yOffset = (svgHeight - graphHeight) / 2;

    // Step 4: Apply translation
    inner.attr("transform", "translate(" + xOffset + "," + yOffset + ")");


	var svg = d3.select("svg"), // Select the SVG element
		inner = svg.select("g"), // Select the group that holds the graph
		zoom = d3.zoom().on("zoom", function() { 
			inner.attr("transform", d3.event.transform); 
		});
	-->

}

// Call this function after rendering the graph

// Function to add unique identifiers to edge data

// depth 

function findRelatedApps(id, depth, currentDepth = 1, visited = new Set()) {
 
	if (currentDepth > depth) return [];
 
	let relatedApps = apus.filter(app => 
		(app.fromAppId === id || app.toAppId === id) &amp;&amp; !visited.has(app.id)
	);
	 

	visited.add(id);
	relatedApps.forEach(app => {
		const nextId = app.fromAppId === id ? app.toAppId : app.fromAppId;
		if (!visited.has(nextId)) {
			relatedApps = relatedApps.concat(findRelatedApps(nextId, depth, currentDepth + 1, visited));
		}
	});

	return relatedApps;
}
$('#connectedApps').on('change', function(){
	$('#diagram').empty();
	redrawView();
})

	
	var redrawView = function () { 
		$('#diagram').empty();
		let scopedRMApps = [];
		appList.forEach((d) => {
			scopedRMApps.push(d)
		});
		let toShow =   appList;  
	
		let appOrgScopingDef = new ScopingProperty('stakeholdersA2R', 'ACTOR_TO_ROLE_RELATION');
		let capOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
		let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
		let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');

		essResetRMChanges();
		let typeInfo = {
			"className": "Application_Provider",
			"label": 'Application',
			"icon": 'fa-desktop'
		}
		let scopedApps = essScopeResources(toShow, [capOrgScopingDef, appOrgScopingDef, visibilityDef, geoScopingDef].concat(dynamicAppFilterDefs), typeInfo);
 
		scopedAppsList = scopedApps.resourceIds;  
	
		let optionsHtml = '<option value="All">All</option>'
		let optionsHtmlApps = scopedApps.resources.map(e => `<option value="`+e.id+`">${e.name}</option>`).join('');
		if(allNodes.length&lt;3000){
			$('#appList').html(optionsHtml + optionsHtmlApps);
		}else{
			$('#appList').html(optionsHtmlApps);
		}
	
 
		appListMapScoped = new Map();

		appListMap.forEach((value, key) => {
			if (scopedAppsList.includes(key)) {
				appListMapScoped.set(key, value);
			}
		});

	
		let matchedResources = allNodes.filter(resource => scopedAppsList.includes(resource.id));

		let matchedEdgeResources = allEdges.filter(resource => 
			scopedAppsList.includes(resource.source) || scopedAppsList.includes(resource.target)
		);
		nodes=matchedResources;
		edges=matchedEdgeResources;
 
		let connected = $('#connectedApps').prop('checked')
		if(connected==true){
		
			scopedNodes=matchedResources;
			scopedEdges=matchedEdgeResources;
		
			if($('#appCapList').val()!=='All'){
				let thisappcapId=$('#appCapList').val();
				thisCap=appCaps.find((e)=>{return e.id==thisappcapId})
 
				const depth = parseInt(document.getElementById("depthSelector").value);
				appsToShow=[];
				thisCap.thisApps.forEach((a)=>{
				
					let relatedApps = findRelatedApps(a, depth);
					appsToShow= [...new Set([...appsToShow, ...relatedApps])];
				})
				//get childrenCaps data
				
		
			}

		}else{
			let idSet = new Set();

			edges.forEach(edge => {
				// Add source and target IDs
				idSet.add(edge.source);
				idSet.add(edge.target);

			})


			let filteredResources = matchedResources.filter(resource => idSet.has(resource.id));
 
			scopedNodes=filteredResources;
		scopedEdges=matchedEdgeResources; 
		}
		
var svg = d3.select("#diagram").append("svg"),
inner = svg.append("g");


var zoom = d3.zoom().on("zoom", function() {
	inner.attr("transform", d3.event.transform);
  });

// Apply the zoom behavior to the SVG canvas
svg.call(zoom);



var render = new dagreD3.render();

var g = new dagreD3.graphlib.Graph().setGraph({
rankdir: "LR",
nodesep: 10,
ranksep: 40,
acyclicer:"greedy",
ranker:"longest-path",
labeloffset: 10,
labelpos: "c"
});

scopedNodes.forEach(function(node) { 

g.setNode(node.id, {labelType: "html", label: nodeTemplate(node.content)});
});


// Set some general styles
g.nodes().forEach(function(v) {
	 
var node = g.node(v); 
node.rx = node.ry = 5;
});

scopedEdges.forEach(function(edge) {

if (!g.hasNode(edge.source) || !g.hasNode(edge.target)) {
	//console.error("Edge refers to undefined node:", edge);
} else {

	g.setEdge(edge.source, edge.target,  {labelType: "html", label: edgeTemplate(edge), curve: d3.curveBundle.beta(0.5), id:edge.source+'-'+edge.target});

}

});

if(nodes.length&lt;3000){

render(inner, g);
centerGraph()
}else{
$('#warning').show();
setTimeout(function() {
	$('#warning').hide();  // This will hide the element after 10 seconds
}, 10000);
$('.show_all').hide();
$('.appBox').show();
}

		function setUpSVG(){

			inner.selectAll(".edgePath path")
			.style("cursor", "pointer")
			.on("mouseover", handleMouseover)
			.on("mouseout", handleMouseout)
			.on("click", handleClick);
		
			// Apply interactivity to edge labels
			inner.selectAll(".edgeLabel")
			.style("cursor", "pointer")
			.on("mouseover", handleMouseover)
			.on("mouseout", handleMouseout)
			.on("click", handleClick);
		
			// Adjust SVG size to fit the graph
			//svg.attr("width", g.graph().width + 40);
		
			adjustSvgWidth() 
			var desiredHeight = g.graph().height + 40;

			// Ensure the SVG height is at least 300 pixels
			var finalHeight = Math.max(desiredHeight, 300);
			
			// Set the height of the SVG
			svg.attr("height", finalHeight);
			svg.call(zoom.transform, d3.zoomIdentity);

			if($('#show_all').prop('checked')==true){

			let graphBounds = inner.node().getBBox();
			let graphWidth = graphBounds.width;
			let graphHeight = graphBounds.height;

			// Calculate the translation required to move the graph's center to the top left
			let translateX = -graphWidth / 2;
			let translateY = -graphHeight / 2;

			// Apply the new transform
			svg.transition().duration(500).call(zoom.transform, d3.zoomIdentity.translate(translateX, translateY));
		
			}
function zoomIn() {
    zoom.scaleBy(svg.transition().duration(500), 1.3);
}

// Function to zoom out
function zoomOut() {
    zoom.scaleBy(svg.transition().duration(500), 0.7);
}

// Attach event listeners to buttons
d3.select('#zoom_in').on('click', zoomIn);
d3.select('#zoom_out').on('click', zoomOut);
centerGraph();
			setDODrop()
		}			
//redraw svg function

function adjustSvgWidth() {
 
    var containerWidth = $('#container').width(); // Or use 'window.innerWidth' for full window width
    $('#diagram svg').attr('width', containerWidth);
}


function redrawSVG(){
	const selectedApp=$('#appList').val();
	inner.selectAll("*").remove();	
	inner.attr("transform", "translate(0,0) scale(1)");
	svg.transition().duration(500).call(zoom.transform, d3.zoomIdentity.translate(0, 0));

	// Recreate the graph layout
	g = new dagreD3.graphlib.Graph().setGraph({rankdir: "LR",
	nodesep: 10,
	ranksep: 20,
	acyclicer:"greedy",
	ranker:"longest-path",
	labeloffset: 10,
	labelpos: "c"
});

 
	// Add nodes and edges as before
	nodes.forEach(function(node) {
	
		if(node.id==selectedApp &amp;&amp; depthType!=='capOn'){
			g.setNode(node.id, { labelType: "html", label: nodeTemplate(node.content), style: "fill: #a5eddc" });
		}else{
	
			g.setNode(node.id, { labelType: "html", label: nodeTemplate(node.content) });
		}
	
	});
	edges.forEach(function(edge) {
		if (g.hasNode(edge.source) &amp;&amp; g.hasNode(edge.target)) {
		
			g.setEdge(edge.source, edge.target, { labelType: "html", label: edgeTemplate(edge), curve: d3.curveBundle.beta(0.5), id:edge.source+'-'+edge.target });
		}
	});
	
	// Call any additional functions like addEdgeIdentifiers(), applyInteractivity(), etc.

	// Set some general styles
	g.nodes().forEach(function(v) {
			
	var node = g.node(v); 
	node.rx = node.ry = 5;
	});

	render(inner, g);
	centerGraph();
	addEdgeIdentifiers();

	
	setUpSVG()

}
// Call this function after rendering the graph
addEdgeIdentifiers();
setUpSVG()


 
// Function to handle mouseover event
function handleMouseover(event, d) {
	let edgematch=($(this)[0].__data__)
	var edgeId = edgematch.v+'-'+edgematch.w;

 	inner.select("#" + edgeId).select("path")
	 	.style("stroke-width", "2px")
     	.style("stroke", "red"); // Highlight the edge

}

// Function to handle mouseout event
function handleMouseout(d) {
	let edgematch=($(this)[0].__data__)
	var edgeId = edgematch.v+'-'+edgematch.w;
	 
 	inner.select("#" + edgeId).select("path")
	 	.style("stroke-width", "1px")
     	.style("stroke", "black");;
    // Hide hover pop-up or tooltip
}

function findMatchingApusElement(source, target, apusArray) {
    return apusArray.find(apusItem => apusItem.fromAppId === target  &amp;&amp; apusItem.toAppId === source);
}

// Function to handle click event
function handleClick(d) {
  
	const matchingApusElement = findMatchingApusElement(d.v, d.w, apus);
 
	//console.log('matchingApusElement',matchingApusElement)

	function transformToJsTreeData(data) {
	 
		return data.map(item => {
			let node = {
				text: item.name,
				id: item.id,
				children: item.views.map(view => {
					return {
						text: view.name,
						id: view.id,
						children: view.dataObjects.map(obj => {
							return { text: obj.name, id: obj.id };
						})
					};
				})
			};
			return node;
		});
	}
	
	// Transform the data
	var jsTreeData=[];

 	if (matchingApusElement.infoView) {
    // If the property exists, transform the data to jsTree format
  	  jsTreeData = transformToJsTreeData(matchingApusElement.infoView);
	} 	else{


	}
  
	// Assign types to nodes in jsTreeData based on their level or other criteria
	 
	assignTypesToNodes(jsTreeData, 1);
	
	// Then, initialize jsTree
	$('#jstree_div').jstree({ 
		'core': {
			'data': jsTreeData,
			'check_callback': true
		},
		'types': {
			'default': {
				'icon': 'fa fa-book'
			},
			'type1': {
				'icon': 'fa fa-book'  
			},
			'type2': {
				'icon': 'fa fa-file-text-o'  
			},
			'type3': {
				'icon': 'fa fa-bars'
			}
		},
		'plugins': ['types']
	}).on("select_node.jstree", function(e, data) {
		if(data.node.children.length === 0) {
        // This is a leaf node, handle the click

		$('#summaryBox').show().animate({opacity: 1}, 'slow');
		let match=dataObjects.find((e)=>{
			return e.id == data.node.id
		})
 
		if(match){
		$('#dataSummary').html(datasummaryTemplate(match))
		} else{
			$('#dataSummary').empty();
		}
    } else {
        // This node has children, so ignore the click
 
		$('#dataSummary').empty();
        $('#jstree_div').jstree(true).deselect_node(data.node);
    }

    });;

	// Function to assign types to nodes
	function assignTypesToNodes(nodes, level) {
		nodes.forEach(function(node) {
			if (level === 1) {
				node.type = 'type1';
			} else if (level === 2) {
				node.type = 'type2';
			} else {
				node.type = 'default';
			}
		
			if (node.children &amp;&amp; node.children.length > 0) {
				assignTypesToNodes(node.children, level + 1);
			}
		});
	}


$('#infoData').html(infoTemplate(matchingApusElement))
//$('#infoBox').css("display", "block").animate({height: '200px',  opacity: 1}, 1000)
 
$('.slideupPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
	

$(document).on('click','.closePanelButton', function(){ 
	$('#jstree_div').jstree("destroy");
	$('.slideupPanel').hide();
})

}

$('.closeInfo').on('click', function(){
//$('#infoBox').animate({height: '0px',  opacity: 0}, 1000)
	 
})
// Apply interactivity to edge apiPathSites
function addEdgeIdentifiers() {
	 
 
$('input[type="radio"][name="view_mode"]').off().on('change', function() {
	$('#infoSidepanel').css('width', '0');;
	$('.handle').hide().animate({right: '0'}, 'medium').css('top', '30%');;;
		event.stopPropagation()
	 
		$('#dataObjList').val('choose').trigger('change.select2');
		if (this.value === 'show_all') {
			nodes=scopedNodes;
			edges=scopedEdges;
			<!--
			$('#zoomWarning').show();

			setTimeout(function() {
				$('#zoomWarning').hide();  // This will hide the element after 10 seconds
			}, 3000);
		-->
			$('.appBox').hide();
			redrawSVG();
		} else if (this.value === 'by_application') {
		 
			$('#zoomWarning').hide(); 
			$('.appBox').show();
		}
	});

		
	function getAppCapData(thisappcapId){
		thisCap=appCaps.find((e)=>{return e.id==thisappcapId})
 
		const depth = parseInt(document.getElementById("depthSelector").value);
		appsToShow=[];
		thisCap.thisApps?.forEach((a)=>{
	
			let relatedApps = findRelatedApps(a, depth);
	 
			appsToShow= [...new Set([...appsToShow, ...relatedApps])];
			 
		})
		nodes=[];
		edges=[];

		getAppsToShow(appsToShow);
		redrawSVG();
		
	}

	$('#depthSelector').off('change.depthSelectorChange').on('change.depthSelectorChange', function(event) {
		$('.handle').hide().animate({right: '0'}, 'medium').css('top', '30%');;

		let thisval=$(this).val();
 
		const thisappId = $('#appList').val();
		const thisappcapId = $('#appCapList').val();
		if(depthType!=='capOn'){
			getAppOnlyData(thisappId)
	 
		}
		else{
			getAppCapData(thisappcapId)
			 
			
		}
		 
	})

	
$('#appList').one('change.appListChange', function(){
	event.stopPropagation()

	$('#infoSidepanel').css('width', '0');
	$('.handle').hide().animate({right: '0'}, 'medium').css('top', '30%');;
	depthType = 'appOn';
	const thisappId = $('#appList').val();
	getAppOnlyData(thisappId)
	$('#appList').val(thisappId).trigger('change.select2');
	$('#appCapList').val('All').trigger('change.select2');
	$('#dataObjList').val('choose').trigger('change.select2');
})

$('#appCapList').off('change.appCapListChange').on('change.appCapListChange', function(){
	$('#infoSidepanel').css('width', '0');
	$('.handle').hide().animate({right: '0'}, 'medium').css('top', '30%');;

	depthType = 'capOn';
	const thisappcapId = $(this).val();
	getAppCapData(thisappcapId)
    $('#appCapList').val(thisappcapId).trigger('change.select2');
	$('#dataObjList').val('choose').trigger('change.select2');
	$('#appList').val('All').trigger('change.select2');
	$('#dataObjList').val('choose').trigger('change.select2');
 
})

	function getAppsToShow(appsForGraph, selectedapp){
		nodes=[];
		edges=[];
 
	
		const allIds = appsForGraph.map(item => [item.fromAppId, item.toAppId]).flat();
		if(selectedapp){
			allIds.push(selectedapp)

		}
 
			// Create a Set from the concatenated array to get unique values, and then convert it back to an array
			let focusAppList = Array.from(new Set(allIds));
			focusAppList = focusAppList.filter(item => item !== undefined &amp;&amp; item !== null &amp;&amp; item !== '');

			focusAppList.forEach((a)=>{
		
		 
				let e=appList.find((s)=>{
					return s.id== a
				})

 
				let appContent={
					"id": e.id,
					"name": e.name, 
					"ap_codebase_status":e.ap_codebase_status,
					"ap_delivery_model":e.ap_delivery_model,
					"className": e.className					
				}
				
					nodes.push( { id: e.id, label: e.name, content: appContent})
				
			})

			appsForGraph.forEach((e)=>{ 
				edges.push( {source: e.toAppId, target: e.fromAppId, label:e.info })
			})

	}

	function getAppOnlyData(appId){
	
		const depth = parseInt(document.getElementById("depthSelector").value);
		const relatedApps = findRelatedApps(appId, depth);

		const relatedAppsFilteredFrom = relatedApps.filter(object => scopedApps.resourceIds.includes(object.fromAppId));
		const relatedAppsFilteredTo = relatedAppsFilteredFrom.filter(object => scopedApps.resourceIds.includes(object.toAppId));

		if(appId =='All'){
			nodes=scopedNodes;
			edges=scopedEdges;
		}else{
			
			getAppsToShow(relatedAppsFilteredTo, appId)
		} 
		redrawSVG();
	}

		$(document).off().one('click', '.focusApp', function(){
	 
			const thisappId = $(this).attr('easid');
			$('input[type="radio"][name="view_mode"][value="by_application"]').prop('checked', true).trigger('change');
			$('#appList').val(thisappId).trigger('change.select2');
			getAppOnlyData(thisappId)
		})


	adjustSvgWidth();
    $(window).resize(adjustSvgWidth); 

}
<!--
$('#infoRepList').off().one('change', function(){
	inner.selectAll("path").style("stroke-width", "1px")
	.style("stroke", "#d3d3d3");
	id= $(this).val();
	console.log('id', id)
	var easids = [];
	let pairs=[];
	let infoRepArray=[];

    // Use jQuery to find elements with the specified data-id and loop through them
    $('[data-id="' + id + '"]').each(function() {
		console.log('edge match')
        // Get the data-easid attribute of each element and add it to the array
		let thisId= $(this).attr('easid');
        easids.push(thisId);
 
		let parts = thisId.split('-');

		let beforeDash = parts[0];
		let afterDash = parts[1];
		pairs.push({"source":parts[0], "target": parts[1]})


    });
	console.log("pairs",pairs)

		easids.forEach((e)=>{
			inner.select("#" + e).select("path")
			.style("stroke-width", "4px")
			.style("stroke", "red");

		})
		console.log('easids', easids)

	});
-->
	function filterByDataObjectId(array, id) {
		return array.filter(item => item.dataObjects?.some(dataObject => dataObject.id === id));
	}

function setDODrop(){	
	$('#dataObjList').off('change.dataSelectorChange').on('change.dataSelectorChange', function(){

		
		inner.selectAll("path").style("stroke-width", "1px")
		.style("stroke", "#d3d3d3");
 
		var easids = [];

		const idToSearch = $(this).val()

		const filteredArray = filterByDataObjectId(apus, idToSearch);
		let appsToShow=[];
		filteredArray.forEach((c)=>{
				let newId=c.toAppId+'-'+c.fromAppId;
		
					inner.select("#" + newId).select("path")
					.style("stroke-width", "4px")
					.style("stroke", "red");

					let a = appListMapScoped.get(c.toAppId);
					let b = appListMapScoped.get(c.fromAppId);
					if(a &amp;&amp; b){
						if (inner.select("#" + newId).select("path").node()) {
							appsToShow.push({"source":a,"target":b, "inDiagram":"yes"})
						}else{
							appsToShow.push({"source":a,"target":b})
						}
					}
			})
			 
			appsToShow=appsToShow.sort((a, b) => a.source.name.localeCompare(b.source.name));
			if(appsToShow.length &gt;0){
				$('.handle').show().animate({right: '30'}, 'medium');
			}
		 $('#dataList').html(dataTemplate(appsToShow));
		})
	}
	setDODrop()
	}


essInitViewScoping(redrawView,['Group_Actor', 'SYS_CONTENT_APPROVAL_STATUS','ACTOR_TO_ROLE_RELATION','Geographic_Region'], responses[0].filters, true);

		
	//end of promise			
		})
/*
		function saveSVG(svgElement, filename) {
			var serializer = new XMLSerializer();
			var svgString = serializer.serializeToString(svgElement);
			var blob = new Blob([svgString], {type: "image/svg+xml"});
		
			var link = document.createElement('a');
			link.href = URL.createObjectURL(blob);
			link.download = filename;
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		}
		
	

		$('#saveButton').one('click', function() {
			// Usage example
			var svgElement = document.querySelector('svg');	 
	
			saveSVG(svgElement, 'dependency.svg');
		});
		
		
		function printSVG(svgElement) {
			// Serialize the SVG element to a string
			var serializer = new XMLSerializer();
			var svgString = serializer.serializeToString(svgElement);
		
			// Open a new window and write the SVG string to it
			var printWindow = window.open('', '_blank');
			printWindow.document.open();
			printWindow.document.write('<html><body onload="window.print();">');
			printWindow.document.write(svgString);
			printWindow.document.write('</body></html>');
			printWindow.document.close();
		}
		
		// Usage example

		$('#printButton').one('click', function() {
			var svgElement = document.querySelector('svg'); // Select your SVG element
			printSVG(svgElement);
		});
		*/
	//end of doc ready	
})
	</xsl:template>		
</xsl:stylesheet>
