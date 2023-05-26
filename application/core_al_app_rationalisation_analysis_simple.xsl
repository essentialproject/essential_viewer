<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 <!--</xsl:stylesheet>	<xsl:import href="../../enterprise/core_el_issue_functions.xsl"/>-->
    <xsl:import href="../common/core_js_functions.xsl"></xsl:import>    
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/> 

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
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
    <xsl:variable name="rationalAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: App Rationalisation API']"/>
    <xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>


	<xsl:template match="knowledge_base">
        <xsl:call-template name="docType"/>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$rationalAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<html>
			<head>
              <script src="js/d3/d3_4-11/d3.min.js"/>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
                <script type="text/javascript" src="js/bootstrap-datepicker/js/bootstrap-datepicker.min.js"/>
				<link rel="stylesheet" type="text/css" href="js/bootstrap-datepicker/css/bootstrap-datepicker.min.css"/>

                <xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Rationalisation Analysis</title>
               		<style>
                    .appCard_Container{
                        width:216px;
                        float: left;
                        margin: 0 15px 30px 0;
                        border-radius: 2px;
                        box-shadow: 0 1px 1px 0 rgba(60,64,67,.08),0 1px 3px 1px rgba(60,64,67,.16);
                    }
                    .appCard_Top{
                        border-radius: 2px 2px 0 0;
                        border: 1px solid #ccc;
                        border-bottom: none;
                        display: flex;
                    }
                    .appCard_Middle{
                        border: 1px solid #ccc;
                        border-bottom: none;
                        display: flex;
                    }
                    .appCard_Bottom{
                        border-radius: 0 0 2px 2px;
                        border: 1px solid #ccc;
                        display: flex;
                    }
                    .appCard_Divider {
                        border-right: 1px solid #ccc;
                    }
                    .appCard_TopLeft {
                        width: 75%;
                        color:#fff;
                        height: 32px;
                        max-height: 32px;
                        overflow: hidden;
                        position: relative;
                        padding: 3px;
                        border-radius: 2px 0 0 0;
                        display: table;
                        float: left;
                        line-height: 1.1em;
                    }
                    .appCard_TopRight {
                        width: 25%;
                        height: 32px;
                        max-height: 32px;
                        color:#333;
                        position: relative;
                        padding: 3px;
                        border-radius: 0 2px 0 0;
                        display: table;
                        float: left;
                    }
                    .appCard_Label {
                        display: table-cell;
                        vertical-align: middle;
                        position: relative;
                    }
                    .appCard_Section25pc {
                        width: 25%;
                        float: left;
                        padding: 3px;
                    }
                    .appCard_Section50pc {
                        width: 50%;
                        float: left;
                        padding: 3px;
                        height: 24px;
                    }
                    .displayTable {
                        position: relative;
                        display: table;
                    }
                    .xxsmall {font-size: 85%;line-height: 1.1em;}
                    .xxxsmall {font-size: 75%;line-height: 1.1em;}
                    .popover {max-width: 400px;}
                    .fa-info-circle:hover {cursor: pointer}
                    .textGold {color: #EEC62A}
                    .textBlue {color: #4196D9}
                    .costApp {
                        border:1pt solid #d3d3d3; 
                        border-radius:3px;
                        border-left:3px solid #8241ea;
                        font-family:14pt;
                        background-color:#ffffff;
                        padding:3px;
                        margin:3px;
                        font-size:1.05em;
                        min-height:20px}
                    .costNum {
                        border:1pt solid #d3d3d3;
                        border-radius:3px;
                        font-family:14pt;
                        padding:3px;
                        margin:3px;
                        }  
                    .costNumNoBorder {
                          
                        font-family:14pt;
                        padding:3px;
                        margin:3px;
                        min-height:40px}       
                    .costClose{
                            border:1pt solid #d3d3d3;
                            border-radius:3px;
                            padding:3px;margin:3px
                            }
                    .costBox {
                        box-shadow:2px 2px 4px rgba(0,0,0,0.25);
                        padding:5px 10px;
                        border:1pt solid #ccc;
                        min-width: 100px;
                        min-height: 32px;}
                    .costBoxPanel {
                        box-shadow:2px 2px 4px rgba(0,0,0,0.25);
                        padding:5px 10px;
                        border:1pt solid #ccc;
                        min-width: 95%;
                        min-height: 20px;}
                    .optionsBox {
                        border:0pt solid #644f4f;
                         border-radius:3px;
                        padding:3px;margin:5px;
                        margin-top:10px;
                        background-color:#f7f7f7;
                        }
                    .optionText{
                        position:relative;top:0pt;
                        margin-left:0px;
                        border-radius:1px;
                        font-size:8pt;
                        padding:3pt; 
                        border:1pt solid #d3d3d3;
                        background-color:#676767;
                        color:#ffffff;
                        width:100px;
                        font-weight:bold;    
                        }
                    .optioncommentText{
                        position:relative;top:-15pt;
                        margin-left:10px;
                        border-radius:1px;
                        font-size:8pt;
                        padding:3pt; 
                        border:1pt solid #d3d3d3;
                        background-color:#676767;
                        color:#ffffff;
                        width:100px;
                        font-weight:bold;    
                        }
                    .commentText{
                        position:relative;
                        top:12px;
                        left: 12px;
                        border-radius:4px;
                        font-size:12px;
                        padding:5px; 
                        background-color:#333;
                        color:#ffffff;
                        font-weight:bold;
                        display: inline-block;
                        }
                    .removeApp{color:red} 
                    
					#appPanel {
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
					#appData{

                    }
                    .dark a {
                    	color: #fff;
                    }
                    .indicator{
                        display:inline-block;
                        border-radius:4px;
                        border: 1pt solid #d3d3d3;
                        font-weight: bold;
                        height:20px;
                        margin:4px;
                        width:20px;
                        text-align:center;
                        font-size:9pt;
                        box-shadow: 3px 3px 4px #d3d3d3;
                    }
                    .indicatorBullet{
                        display:inline-block;
                        width:90%;
                        border-radius:4px;
                        border: 1pt solid #d3d3d3;
                        font-weight: bold;
                        height:20px;
                        text-align:center;
                        font-size:9pt;
                        box-shadow: 3px 3px 4px #d3d3d3;
                        margin-bottom:3px;
                    }
                    .dots{
                        padding-right:3px;
                        color:#76e8e6;
                    }
                    .divTable {
                        overflow: auto;
                        height:250px
                    }
                    .divhead {
                        vertical-align: top; 
                        text-align:center;
                        width:50%;
                        }
                    .divrow {
                        vertical-align: top; 
                        text-align:center;
                        }
                    .removaltd{
                        background-color:#efefef;
                        font-size:12pt
                        height:30px;
                        padding: 4px;
                        border-bottom:1pt solid #fff;

                    }
                    .summaryTable{
                        font-size:12pt
                    }
                    .tdSummaryIndicator {
                        width:55px;
                        text-align:center;
                    }
                    .infoBox{
                        border-radius:4px;
                        border:1pt solid #ccc;
                        padding:5px;
                        text-align: center;
                        font-weight: 700;
                    }
                    .tab-content {
                    	padding-top: 10px;
                    }
                    .ess-tag-default {
                    	background-color: #adb5bd;
                    	color: #333;
                    }
                    .ess-tag {
                    	padding: 3px 12px;
                    	border: 1px solid #222;
                    	border-radius: 16px;
                    	margin-right: 10px;
                    	margin-bottom: 5px;
                    	display: inline-block;
                    	font-weight: 700;
                    }
                	.inline-block {display: inline-block;}
                	.ess-small-tabs > li > a {
                		padding: 5px 15px;
                	}
                	.badge.dark {
                		background-color: #555!important;
                	}
                	.vertical-scroller {
                		overflow-x:hidden;
                		overflow-y: auto;
                		padding-right: 5px;
                	}

                	.vertical-scroller.dark::-webkit-scrollbar { width: 8px; height: 3px;}
					.vertical-scroller.dark::-webkit-scrollbar-button {  background-color: #666; }
					.vertical-scroller.dark::-webkit-scrollbar-track {  background-color: #646464;}
					.vertical-scroller.dark::-webkit-scrollbar-track-piece { background-color: #222;}
					.vertical-scroller.dark::-webkit-scrollbar-thumb { height: 50px; background-color: #666; border-radius: 3px;}
					.vertical-scroller.dark::-webkit-scrollbar-corner { background-color: #646464;}}
					.vertical-scroller.dark::-webkit-resizer { background-color: #666;}
					
					table.sticky-headers > thead > tr > th {
						position: sticky;
						top: -10px;
					}
					input.form-control.dark {
						color: #333;
                    }
                    .impactHeading {
                        font-weight:bold;
                        text-transform: uppercase;
                        font-size:0.8em;
                        }
                        /* CSS styles for the chart */
                        .axis path,
                        .axis line {
                          fill: none;
                          stroke: #000;
                          shape-rendering: crispEdges;
                        }
                        .axis text {
                          font-family: sans-serif;
                          font-size: 11px;
                        }
                        .bubble {
                          fill: rgb(110 70 180 / 30%);
                        }
                        .bubble:hover {
                          fill: red;
                        }
                        .tooltip {
                          position: absolute;
                          text-align: center;
                          padding: 10px;
                          font-family: sans-serif;
                          font-size: 12px;
                          background: #333;
                          color: #fff;
                          border-radius: 5px;
                          pointer-events: none;
                        }
                        .bubble-label {
                            font-size: 10px;
                            text-anchor: right;
                            dominant-baseline: central;
                        } 

                        .axis-label{
                            font-size: 9px;
                            font-color:#d3d3d3
                        }

                    .bars .tick {
                        display: none;
                      }
                    .bars .domain {
                        display: none;
                      }
                    .compBox{
                        border: 1pt solid #d3d3d3;
                        border-radius: 6px;
                    }

.card-container {
  display: flex;
  flex-direction: row; 
}

.card {
  background-color: white;
  border: 1px solid black;
  width: 70px;
  height: 100px;
  border-radius: 0px 5px 5px 5px;
  display: flex;
  flex-direction: column;
  font-family: arial, sans-serif;
  font-size: 0.9em;
  text-align: center;
  margin:3px;
}
.textcard{
  background-color: white;
  border: 1px solid black;
  width: 100px;
  height: 100px;
  border-radius: 5px;
  display: flex;
  flex-direction: column;
  font-family: arial, sans-serif;
  font-size: 0.9em;
  text-align: center;
  margin:3px;
  position: relative;
}

.summaryCardBox{
   display: inline-block;
   font-size: 0.7em;
   position: relative;
   top: 2px;
   left: 10px;
}

.card-header {
  background-color: #0c2340;
  color: white;
  border-radius: 0px 5px 0px 0px;
 // border-top-left-radius: 5px;
 // border-top-right-radius: 5px;
  font-size:0.8em;
  padding: 5px;
  height: 32px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.card-title {
  font-size: 0.8em;
  margin: 0;
}

.card-subtitle {
  font-size: 8px;
  margin: 0;
}

.card-body {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  flex-grow: 2;
  padding: 5px;
}


.card-action {
font-size:0.7em;
}
.action{
    width:90%;
    border:1pt solid #d3d3d3;
    border-radius:3px;
    font-size:0.8em;
    font-family:verdana;
}
.rotated-text {
    width: 20px;
    height: 98px;
    background-color: #f7f7f7;
    position: relative;
    font-family: verdana;
    border-radius: 6px;
    position: absolute;
    font-weight:bold;
    font-size:0.9em;
}

.rotated-text span {
  display: block;
  position: absolute;
  left: 105%;
  top: 84%;
  transform: translate(-50%, -50%) rotate(-90deg);
  transform-origin: 0 0;
  white-space: nowrap;
  font-family:verdana;
}
.infoCircle{
    border-radius:20px;
    border:1pt solid #d3d3d3;
    font-size:0.7em;
    width:15px;
    height:15px;
    position:absolute;
    right:3px;
    bottom:3px;
    background-color:#4196D9;
    font-weight:bold;
    color:white;
}
.subServiceName {
    background-color:#359159;
    font-size:0.7em;
    color:#fff;
    display:inline-block;
    padding:2px;
    margin:2px;
} 
.subAppName  {
     background-color:#afdfbc;
     font-size:0.7em;
     color:#000000;
     display:inline-block;
     padding:2px;
     margin:2px;
}

.subAction{
     background-color:#b76bba;
     font-size:0.7em;
     color:#ffffff;
     display:inline-block;
     padding:2px;
     margin:2px;
}

.appAction{
     background-color:#000;
     font-size:0.8em;
     border-radius:6px;
     color:#ffffff;
     display:inline-block;
     padding:2px;
     width:70px;
     text-align:center;
     margin:2px;
     right:2px;
     top:2px;
     position:absolute;
}
.otherChanges{
    border-radius:6px;
    background-color:#000;
    color:#fff;
    font-weight:bold;
    width:30px;
    text-align:center;
}

                      </style>
                <link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
                <script>
                        var appCardTemplate;
                        var svgwidth 
						var sourceReport='<xsl:value-of select="$param1"/>';
                        $(document).ready(function(){
                           // console.log($('#comparison').length > 0)
                       
                            lineSVGFragment = $("#servicesSVG-template").html();
                            lineSVGTemplate = Handlebars.compile(lineSVGFragment);

                            $('.appCompareButtonFocus').hide();
                            $('select').select2({theme: "bootstrap"});

                            var appCardFragment   = $("#app-card-template").html();
                            appCardTemplate = Handlebars.compile(appCardFragment);
	                        
                            var costCardFragment   = $("#cost-card-template").html();
                            costCardTemplate = Handlebars.compile(costCardFragment);
                             
                    
                            Handlebars.registerHelper('getRow', function (arg1) {
			 
                                return (arg1 * 25) + 25;
                        })
                        
            
                        Handlebars.registerHelper('getShortName', function (arg1) {
                         if(arg1.length&gt;20){
                            return arg1.slice(0,20)+'...';
                         }else
                         {
                            return arg1 
                         }
                            
                        })
                        Handlebars.registerHelper('getRowText', function (arg1) {
                            return (arg1 * 25) + 27;
                        })
                        Handlebars.registerHelper('getRowWidth', function (arg1) {
                            let pos=(arg1 * 25)
                            if(pos &gt; svgwidth){
                                pos=svgwidth;
                            }
                            return pos;
                        
                        })
                        
                        Handlebars.registerHelper('getRowMidpoint', function (arg1, side) {
                         
                            let midpoint=svgwidth/2;

                            return midpoint;
                        
                        })

                        
                        Handlebars.registerHelper('getRowMidpointTick', function (arg1) {

                            return (arg1 * 25) + 20
                        
                        })


                        Handlebars.registerHelper('getRowWidthText', function (arg1, side) {
                            let midpoint=svgwidth/2; 
                            let wide=(midpoint/2)*(parseInt(arg1)/100)
                            if(side=='Left'){
                                return midpoint - wide -40;
                            }else{
                                return midpoint + wide +10;
                            }
                        
                        })

                        Handlebars.registerHelper('getRowWidthTextDown', function (arg1, side) {
                            
                            return (arg1 * 25) + 28;
                        
                        });

                        Handlebars.registerHelper('getRowAppNameTextDown', function (arg1, side) {
                            
                            return (arg1 * 25) + 18;
                        
                        });

                        
                        Handlebars.registerHelper('getRowWidthTextAppName', function (arg1, side) {
                            let midpoint=svgwidth/2;  
                            let appLength=(arg1.length*10)/2
                            
                                return midpoint - (appLength/2);
                           
                        
                        })

                        Handlebars.registerHelper('getRowWidthx2', function (arg1, side) {
                            
                            let midpoint=svgwidth/2; 
                            let wide=(midpoint/2)*(parseInt(arg1)/100)
                            if(side=='Left'){
                                return midpoint - wide;
                            }else{
                                return midpoint +wide;
                            }
                        
                        })

                    
	                        Handlebars.registerHelper('getScore', function(score, options) {
								if (score != null){
									return Math.round(score);
								}
								else {return ''}
							});
							
                            Handlebars.registerHelper('nameSubString', function(name) {
								return name.substring(0, 14);
							});

                    
							Handlebars.registerHelper('getCost', function(cost, options) {
								if (cost != null){
									return parseInt(cost).toLocaleString();
								}
								else {return '-'}
							});
                    
                           $(".myCostRange").on('change',function(){
								updateCards();
							});
							$(".myInterfaceRange").on('change',function(){
								  updateCards();
								});
							$(".ticks").on('change',function(){
								  updateCards();
								});		
					
					
            });

       //end of ready          
       function goBack() {
						  window.history.back();
						};  
                        function showFocusType(){
                        		var radioValue = $("input[name='focusType']:checked").val();
                        		if(radioValue == 'radioService'){
                                    $('#selBox').val(null).trigger('change');
                                    $("#application").val(null).trigger('change');
						        	$('#appSearch').hide();
						        	$('#servSearch').show();
						        }
						        else if(radioValue == 'radioApp'){
                                    $('#application').val(null).trigger('change');
						        	$('#servSearch').hide();
						        	$('#appSearch').show();
						        }
                        	};
                        	
                        function showInfoTooltips(){
                        	$('[role="tooltip"]').remove();
							$('.fa-info-circle').popover({
								container: 'body',
								html: true,
								trigger: 'click',
								content: function(){
									return $(this).next().html();
								}
							});
                        };
                            
                </script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 style="font-size: 28px !important ;font-weight: 600 !important;margin-bottom: 20px !important;">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Rationalisation Analysis')"/></span>
								</h1>
							</div>
						</div>
                        <xsl:call-template name="RenderDataSetAPIWarning"/>
						<div class="col-xs-12">
							<ul class="nav nav-tabs" id="mainPageTabs">
								<li class="active"><a data-toggle="tab" href="#home" id="homeTab"><xsl:value-of select="eas:i18n('Analysis')"/></a></li>
                                <li id="insightTab" ><a data-toggle="tab" href="#ideas" id="insightTabText"><xsl:value-of select="eas:i18n('Insight')"/></a></li>
							</ul>
	                    	<div class="tab-content">
		                      	<div id="home" class="tab-pane fade in active">
		                      		<div class="row">
		                            	<div class="col-xs-2">
		                        			<h3 class="text-primary"><xsl:value-of select="eas:i18n('Search by')"/>:</h3>
		                        	
											<label><input class="radio-inline" type="radio" name="focusType" value="radioApp" onclick="showFocusType()" checked="checked" id="radioApp"/>Application</label>
											<label><input class="radio-inline" type="radio" name="focusType" value="radioService"  onclick="showFocusType()"/>Service</label>
		                        	
											<div id="appSearch" class="top-15">
											    <h3 class="text-primary" style="display:inline-block">Focus Application</h3>
											    <div class="form-group span-3">
													<select id="application" class="form-control select2" style="width:90%;">
											           <option value="1selectOne" selected="true" disabled="true">Select an Application</option>
											           <!-- <xsl:apply-templates select="$apps" mode="getOptions">
											                <xsl:sort select="upper-case(own_slot_value[slot_reference='name']/value)" order="ascending"/>
											            </xsl:apply-templates>
				                                        -->
				                                    </select><xsl:text> </xsl:text>
				                                    <i><xsl:attribute name="class">fa fa-question-circle appCompareButtonFocus</xsl:attribute></i>
											    </div>
											</div>
									            
											<div id="servSearch" class="top-15 hiddenDiv"> 
											    <h3  class="text-primary" style="display:inline-block"><xsl:value-of select="eas:i18n('Select Services')"/></h3>
												<select class="servicesNew select2" name="servicesOnlt" multiple="multiple" style="width:100%;" id="selBox">
											       
												</select>
											    <button class="btn btn-sm btn-default top-5" onclick="selectNewApp();showInfoTooltips();">Go</button>
											</div>
											<div id="services" class="top-15"> 
												<h3 class="text-primary"><xsl:value-of select="eas:i18n('Services')"/></h3>
												<ul id="appServs" class="small fa-ul"/>
												<button id="hide" onclick="$('#appServs').hide();$('#hide').hide();$('#show').show()" class="btn btn-sm btn-default">Hide</button>
												<button id="show" onclick="$('#appServs').show();$('#hide').show();$('#show').hide()" class="btn btn-sm btn-default">Show</button>
											</div>
											<div id="carriedApps" style="display:none;border:1pt solid #d3d3d3;border-radius:3px;padding:3px" class="top-15"> 
												<h4><xsl:value-of select="eas:i18n('Application Basket')"/></h4>
												<div id="selPlace"></div>
												<br/>
												<button class="btn btn-primary btn-sm" onclick="goBack()"><xsl:value-of select="eas:i18n('Back to Previous')"/></button>
											</div>			  
		                        		</div>	
				                        <div class="col-xs-10">
				                            <div id="filters">
				                            <h3 class="text-primary pull-left"><xsl:value-of select="eas:i18n('Filters')"/></h3>
											<div style="width:100%;text-align:right">
												<button class="btn btn-xs btn-default left-5" id="reset" onclick="ResetAll()" style="display: inline-block;">Reset All Filters</button>
											</div>
											<div class="clearfix"></div>
											<div class="row">
												<div class="col-md-2 col-lg-2">
													
				                                    <div>
														<button class="btn btn-sm btn-default left-5" id="primeHide" onclick="$('#primeHide').hide();$('#primeShow').show();showPrime('on')">Off</button>
														<button class="btn btn-sm btn-default left-5" id="primeShow" onclick="$('#primeHide').show();$('#primeShow').hide();showPrime('off')" style="display:none">On</button></div>
													</div>
												
													<div class="col-md-2 col-lg-2">
														<div class="bottom-5">
															<strong><xsl:value-of select="eas:i18n('Services Match')"/>:</strong>&#160;&#160;&#160;<span id="servnums"></span>
														</div>
														<input type="range" min="1" max="5" value="1" id="myRange"></input>
														<div class="slidecontainer">
															<script>
															var slider = document.getElementById("myRange");
															var output = document.getElementById("servnums");
															output.innerHTML = slider.value;
															
															slider.oninput = function() {
															    output.innerHTML = this.value;
															    updateCards();
															}
															</script>
														</div>
													</div>
												
													<div class="col-md-2 col-lg-2">
														<div class="bottom-5">
															<strong><xsl:value-of select="eas:i18n('Cost Threshold')"/>:</strong>
															<span class="left-5" id="costnums"></span>
														</div>
														<input type="range" min="0" max="50000" value="0" id="myCostRange" class="myCostRange"></input>
														<div class="slideCostcontainer">
															<script>
															var costslider = document.getElementById("myCostRange");
															var costoutput = document.getElementById("costnums");
															costoutput.innerHTML = costslider.value;
															
															costslider.oninput = function() {
															    costoutput.innerHTML = this.value;
															    updateCards();
															}
															</script>
														</div>
														<div class="xxsmall">
															<em class="right-5"><xsl:value-of select="eas:i18n('Greater Than')"/></em>
															<input class="left-5 inverse" type="checkbox" id="inverse" name="inverse" value="inverse" checked="checked"></input>
														</div>
													</div>
												
													<div class="col-md-2 col-lg-2">
														<div class="bottom-5">
															<strong><xsl:value-of select="eas:i18n('Interfaces')"/>:</strong>
															<span class="left-5" id="interfacenums"></span>
														</div>
														<input type="range" min="0" max="50000" value="0" id="myInterfaceRange" class="myInterfaceRange"></input>
														<div class="slideInterfacecontainer">
															<script>
															var interfaceslider = document.getElementById("myInterfaceRange");
															var interfaceoutput = document.getElementById("interfacenums");
															interfaceoutput.innerHTML = interfaceslider.value;
															
															interfaceslider.oninput = function() {
															    interfaceoutput.innerHTML = this.value;
															    updateCards();
															}
															</script>
														</div>
													</div>
												
													<div class="col-md-2 col-lg-2">
														<div>
															<strong><xsl:value-of select="eas:i18n('Codebase')"/>:</strong>
														</div>
					 
														<select multiple="multiple" id="ticks" style="width:100%;" class="ticks">
															<option value="NotDefined"><xsl:value-of select="eas:i18n('Not Defined')"/></option>
														</select>
													</div>
													<div class="col-md-2 col-lg-2">
														<div>
															<strong><xsl:value-of select="eas:i18n('Strategic Lifecycle')"/>:</strong>
														</div>
														<select multiple="multiple" style="width:100%;" id="SLs"/><br/>
													</div>
												</div>
											</div>
		                           	 		<hr class="tight"/>
											<div id="key" class="bottom-15 small" xstyle="display:none">
												<strong class="right-10">Legend:</strong>
				                                
												<i class="fa fa-exchange right-5 textBlue"></i><xsl:value-of select="eas:i18n('Candidates for Replacement by Focus App')"/>
				                                <span class="left-5 right-5">|</span>
												<i class="fa fa-copy right-5 text-primary" style="color:'+colour+'"></i><xsl:value-of select="eas:i18n('Overlap')"/>
												<span class="left-5 right-5">|</span>
												<i class="fa essicon-radialdots right-5 text-primary"></i><xsl:value-of select="eas:i18n('Total Number of Services')"/>
												<span class="left-5 right-5">|</span>
												<i class="fa essicon-boxesdiagonal right-5 text-primary"></i><xsl:value-of select="eas:i18n('Processes Supporting')"/>
												<span class="left-5 right-5">|</span>
												<i class="fa essicon-connections right-5 text-primary"></i><xsl:value-of select="eas:i18n('Interfaces')"/>
												<span class="left-5 right-5">|</span>
				                                <i class="fa essicon-target right-5 text-primary" /><xsl:value-of select="eas:i18n('Commodity')"/>
												<span class="left-5 right-5">|</span>
				                                <i class="fa essicon-valuechain right-5 text-primary" /><xsl:value-of select="eas:i18n('Differentiating')"/>
				                                <br/>
											</div>
		                            		<hr class="tight" />	
		                        			<div id="cardsBlock"/>
				                		</div>
				                    </div>
		                      	</div>
                                <div id="ideas" class="tab-pane fade ">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div id="chart"></div>
                                        </div>
                                         
                                        <div class="col-xs-12" style="text-align:center">  
                                            <div id="compBox" class="compBox" >
                                            <small><b><span id="clickedApp"></span></b></small>
                                            <xsl:text> </xsl:text>
                                                    <i class="fa fa-caret-left" style="color:#32a852"></i><xsl:text> </xsl:text>
                                                    <small><xsl:value-of select="eas:i18n('Overlap')"/></small>
                                                    <xsl:text> </xsl:text>
                                                
                                                    <i class="fa fa-caret-right" style="color:#2fa5b5"></i><xsl:text> </xsl:text>
                                                    <small><xsl:value-of select="eas:i18n('Inverse')"/>
                                                </small>
                                                <div id="comparison"> 
                                                </div>
                                            </div>
                                        </div>
                                    </div>
 
                                </div>
	                    	</div>

	                    <!--Setup Closing Tags-->
					</div>
				</div>
                </div> 
                <div id="appPanel">
                    <div id="appData"></div>
                </div>
				<!-- ADD THE PAGE FOOTER
				<xsl:call-template name="Footer"/> -->
         <script>      
            <xsl:call-template name="RenderViewerAPIJSFunction">
                <xsl:with-param name="viewerAPIPath" select="$apiPath"/> 
                <xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param>
            </xsl:call-template>
            </script>

            <script id="app-template" type="text/x-handlebars-template">
            	<div class="row">
            		<div class="col-sm-8">
            			<h4 class="text-normal strong inline-block right-30">{{name}} - Overview</h4>
            			<div class="ess-tag ess-tag-default"><i class="fa fa-money right-5"/>Cost: {{costValue}}</div>
                		<div class="inline-block">{{#calcComplexity this}}{{/calcComplexity}}</div>
            		</div>
            		<div class="col-sm-4">
            			<div class="text-right">
            				<!--<span class="dropdown">
            					<button class="btn btn-default btn-sm dropdown-toggle panelHistoryButton" data-toggle="dropdown"><i class="fa fa-clock-o right-5"/>Panel History<i class="fa fa-caret-down left-5"/></button>
	            				<ul class="dropdown-menu dropdown-menu-right">
									<li><a href="#">Page 1</a></li>
									<li><a href="#">Page 2</a></li>
									<li><a href="#">Page 3</a></li>
								</ul>
            				</span>-->
            				<i class="fa fa-times closePanelButton left-30"></i>
            			</div>
            			<div class="clearfix"/>
            		</div>
            	</div>   
                <div class="row">
                	<div class="col-sm-12">
						<ul class="nav nav-tabs ess-small-tabs">
			                <li class="active"><a data-toggle="tab" href="#sum">Summary</a></li>
			                <li><a data-toggle="tab" href="#processes">Processes<span class="badge dark">{{processesSupporting}}</span></a></li>
			                <li><a data-toggle="tab" href="#integrations">Integrations<span class="badge dark">{{totalIntegrations}}</span></a></li>
			                <li><a data-toggle="tab" href="#overlap">Application Overlap</a></li> 
		                </ul>
                		<div class="tab-content vertical-scroller dark" style="height:250px;">
                			<div id="sum" class="tab-pane fade in active bottom-10">
			                    <div>
			                    	<strong>Description</strong>
			                    	<br/>
			                        {{description}}    
			                    </div>
                				<div class="ess-tags-wrapper top-10">
                					<div class="ess-tag ess-tag-default"><i class="fa fa-code right-5"/>{{codebase}}</div>
                					<div class="ess-tag ess-tag-default"><i class="fa fa-desktop right-5"/>{{appDelivery}}</div>
                					<div class="ess-tag ess-tag-default"><i class="fa fa-users right-5"/>{{processesSupporting}} Processes Supported</div>
                					<div class="ess-tag ess-tag-default"><i class="fa fa-exchange right-5"/>{{totalIntegrations}} Integrations ({{inboundIntegrations}} in / {{outboundIntegrations}} out)</div>
                					
                				</div>
                			</div>
			                <div id="processes" class="tab-pane fade">
			                    <p class="strong">This Application supports the following Business Processes:</p>
			                    <div>
		                            {{#each processList}}
		                            <div class="ess-tag ess-tag-default">{{name}}</div>   
		                            {{/each}}
			                    </div>
			                </div>
			                <div id="integrations" class="tab-pane fade">
			                    <p class="strong">This Application has the following Integrations:</p>
			                	<div class="row">
			                		<div class="col-md-6">
			                			<div class="impact bottom-10">Inbound</div>
			                				{{#each inIList}}
			                                <div class="ess-tag bg-lightblue-100">{{name}}</div>
			                            	{{/each}}
			                		</div>
			                		<div class="col-md-6">
			                			<div class="impact bottom-10">Outbound</div>
			                				{{#each outIList}}
			                                <div class="ess-tag bg-pink-100">{{name}}</div>
			                            	{{/each}}
			                		</div>
			                	</div>
			                </div>
			                <div id="overlap" class="tab-pane fade">
			                    <p class="strong">Other Applications providing overlapping Services to this Application</p>
		                        <table class="sticky-headers">
		                        	<thead>
		                        		<tr>
		                        			<th class="bg-darkgrey" width="250px">Application</th>
		                        			<th class="bg-darkgrey" width="120px">High Overlap?</th>
		                        			<th class="bg-darkgrey">Services</th>
		                        		</tr>
		                        	</thead>
		                        	<tbody>
		                        		{{#each appMap}}
		                        		<tr>
		                        			<td>{{this.key}}</td>
		                        			<td>{{#if candidate}}<i class="fa fa-check"/>{{/if}}</td>
		                        			<td>{{#drawDots this.value}}{{/drawDots}}</td>
		                        		</tr>
		                        		{{/each}}
		                        	</tbody>
		                        </table>
			                </div> 
                		</div>
                	</div>
                	<!--<div class="col-sm-4">
                		<h4 class="strong">Related Views</h4>
                		<ul class="fa-ul dark">
                			<li><i class="fa fa-li fa-list-alt"/><a>Application Provider Summary</a></li>
                			<li><i class="fa fa-li fa-area-chart"/><a>Application Information Dependency</a></li>
                			<li><i class="fa fa-li fa-list-alt"/><a>Application Info/Data Summary</a></li>
                			<li><i class="fa fa-li fa-area-chart"/><a>Application Lifecycle Model</a></li>
                			<li><i class="fa fa-li fa-bar-chart"/><a>Application Impact Analysis</a></li>
                			<li><i class="fa fa-li fa-list-alt"/><a>Application Deployment Summary</a></li>
                			<li><i class="fa fa-li fa-area-chart"/><a>Application Software Architecture</a></li>
                			<li><i class="fa fa-li fa-pie-chart"/><a>Application Cost Summary</a></li>
                			<li><i class="fa fa-li fa-area-chart"/><a>Technology Platform Model</a></li>
                			<li><i class="fa fa-li fa-area-chart"/><a>Application Strategy Alignment</a></li>
                		</ul>
                	</div>-->
                </div>
            </script>
                  <xsl:call-template name="AppCardHandlebarsTemplate"/>
                 <xsl:call-template name="costHandlebarsTemplate"/>
                <script id="servicesSVG-template" type="text/x-handlebars-template">
					<svg width="100%" id="svgMap"><xsl:attribute name="height">{{#getRowText this.ht}}{{/getRowText}}</xsl:attribute>
					{{#each this}}
							<text x="5" font-size="0.9em"><xsl:attribute name="y">{{#getRowText @index}}{{/getRowText}}</xsl:attribute>{{this.key}}</text>
							
							<line   stroke="#2fa5b5"  stroke-width="4">
                                <xsl:attribute name="x1">{{#getRowMidpoint this.percentage 'Right'}}{{/getRowMidpoint}}</xsl:attribute>
								<xsl:attribute name="y1">{{#getRow @index}}{{/getRow}}</xsl:attribute>
								<xsl:attribute name="y2">{{#getRow @index}}{{/getRow}}</xsl:attribute> 
								<xsl:attribute name="x2">{{#getRowWidthx2 this.percentage 'Right'}}{{/getRowWidthx2}}</xsl:attribute>
							</line>
                            <line   stroke="black"  stroke-width="1">
                                <xsl:attribute name="x1">{{#getRowMidpoint}}{{/getRowMidpoint}}</xsl:attribute>
								<xsl:attribute name="y1">{{#getRowMidpointTick @index}}{{/getRowMidpointTick}}</xsl:attribute>
								<xsl:attribute name="y2">{{#getRow @index}}{{/getRow}}</xsl:attribute> 
								<xsl:attribute name="x2">{{#getRowMidpoint}}{{/getRowMidpoint}}</xsl:attribute>
							</line>
							<circle r="5"   stroke-width="0">
									<xsl:attribute name="fill">#2fa5b5</xsl:attribute> 
									<xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute> 
									<xsl:attribute name="cx">{{#getRowWidthx2 this.percentage 'Right'}}{{/getRowWidthx2}}</xsl:attribute>
							</circle>
                            <circle r="5"   stroke-width="0">
									<xsl:attribute name="fill">#32a852</xsl:attribute> 
									<xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute> 
									<xsl:attribute name="cx">{{#getRowWidthx2 this.inversePercentage 'Left'}}{{/getRowWidthx2}}</xsl:attribute>
							</circle>
                            <line   stroke="#32a852"  stroke-width="4">
                                <xsl:attribute name="x1">{{#getRowMidpoint this.inversePercentage 'Left'}}{{/getRowMidpoint}}</xsl:attribute>
								<xsl:attribute name="y1">{{#getRow @index}}{{/getRow}}</xsl:attribute>
								<xsl:attribute name="y2">{{#getRow @index}}{{/getRow}}</xsl:attribute> 
								<xsl:attribute name="x2">{{#getRowWidthx2 this.inversePercentage 'Left'}}{{/getRowWidthx2}}</xsl:attribute>
							</line>
                             
                            <text font-size="0.8em" font-weight="none" fill="black">
									<xsl:attribute name="x">{{#getRowWidthText this.percentage 'Right'}}{{/getRowWidthText}}</xsl:attribute>
									<xsl:attribute name="y">{{#getRowWidthTextDown @index}}{{/getRowWidthTextDown}}</xsl:attribute>{{percentage}}%
							</text>
                            <text font-size="0.8em" font-weight="none" fill="black">
									<xsl:attribute name="x">{{#getRowWidthText this.inversePercentage 'Left'}}{{/getRowWidthText}}</xsl:attribute>
									<xsl:attribute name="y">{{#getRowWidthTextDown @index}}{{/getRowWidthTextDown}}</xsl:attribute>{{inversePercentage}}%
							</text>

                            <text font-size="0.8em" font-weight="none" fill="black">
									<xsl:attribute name="x">{{#getRowWidthTextAppName this.app2 'Right'}}{{/getRowWidthTextAppName}}</xsl:attribute>
									<xsl:attribute name="y">{{#getRowAppNameTextDown @index}}{{/getRowAppNameTextDown}}</xsl:attribute>{{this.app2}}
							</text>
                            
						<!--	<text font-size="0.8em" font-weight="bold" fill="white">
									<xsl:attribute name="x">{{#getRowWidthText this.percentage}}{{/getRowWidthText}}</xsl:attribute>
									<xsl:attribute name="y">{{#getRowWidthTextDown @index}}{{/getRowWidthTextDown}}</xsl:attribute>{{percentage}}
								</text>

							<text font-size="0.8em" font-weight="bold" fill="white">
								<xsl:attribute name="x">{{#getRowWidthText inversePercentage}}{{/getRowWidthText}}</xsl:attribute>
								<xsl:attribute name="y">{{#getRowWidthTextDown @index}}{{/getRowWidthTextDown}}</xsl:attribute>{{this.inversePercentage}}
							</text>-->
							
						

					{{/each}}
					</svg>
				</script>	
           
			</body>
		</html>
	</xsl:template>
    
 	<xsl:template name="costHandlebarsTemplate">
		  <script id="cost-card-template" type="text/x-handlebars-template">
              <div class="col-xs-12">
                  <div class="col-md-5 costApp"><xsl:attribute name="eas-id">{{this.id}}</xsl:attribute>
                 <b> {{this.name}}</b>
                  <div class="appAction">{{this.action}}</div><br/>
                  {{#each this.otherChanges}} 
                    <div class="subServiceName">{{this.service}}</div><div class="subAppName">{{this.appname}}</div><div class="subAction pull-right">{{this.action}}</div><br/>{{/each}}
                  </div>
                  <div class="col-md-2 fullCost costNum"><xsl:attribute name="data-cost">{{this.cost}}</xsl:attribute><xsl:attribute name="eas-id">{{this.id}}</xsl:attribute>{{this.costValue}}</div>
                   
                  <div class="col-md-3 fullspend costNum"><xsl:attribute name="data-spend">{{this.scenarioCost}}</xsl:attribute><xsl:attribute name="eas-id">{{this.id}}</xsl:attribute>{{this.scenarioCost}}</div>
                  <div class="col-md-1 costNumNoBorder"><xsl:attribute name="eas-id">{{this.id}}</xsl:attribute>
                     
                        <i class="fa fa-trash removeApp "><xsl:attribute name="data-aid">{{this.id}}</xsl:attribute></i>
                        
                </div> 
              </div>
              <div class="clearfix"></div>
            </script>
        </xsl:template>
    
	
    
	<xsl:template name="AppCardHandlebarsTemplate">
		<script id="app-card-template" type="text/x-handlebars-template">
            <div>
                <xsl:attribute name="class">carddiv {{this.codebaseID}} s{{this.statusID}} appCard_Container</xsl:attribute>
                <xsl:attribute name="id">{{this.id}}</xsl:attribute>
                <xsl:attribute name="data-num">{{this.num}}</xsl:attribute>
                <xsl:attribute name="data-cost">{{this.cost}}</xsl:attribute>
                <xsl:attribute name="data-interface">{{this.totalIntegrations}}</xsl:attribute>
                <xsl:attribute name="data-prime">{{#prime}}true{{/prime}}{{^prime}}false{{/prime}}</xsl:attribute>
               
			<div class="appCard_Top">
				<div class="appCard_TopLeft small bg-midgrey fontBold">
					<div class="appCard_Label">{{{name}}}</div>
				</div>
				<div class="appCard_TopRight">
					<div class="appCard_Label alignCentre">{{#switch}}
                    <i class="fa fa-exchange textBlue left-5"><xsl:attribute name="onclick">selectApp('{{this.id}}');getAllApps();$("#application").val('{{this.id}}').prop('selected', true).change()</xsl:attribute></i>{{/switch}}</div>
				</div>
			</div>
			<div class="appCard_Middle">
				<div class="appCard_Section25pc appCard_Divider alert-success"><xsl:attribute name="style">background-color:{{costColour}}</xsl:attribute>
					<div class="appCard_Label xxsmall">
						<i class="fa fa-copy right-5"/>{{getScore score}}%
					</div>
				</div>
				<div class="appCard_Section25pc appCard_Divider">
					<div class="appCard_Label xxsmall">
						<i class="fa essicon-radialdots right-5"/>{{services.length}}
					</div>
				</div>
				<div class="appCard_Section25pc appCard_Divider">
					<div class="appCard_Label xxsmall">
						<i class="fa essicon-boxesdiagonal right-5"/>{{processesSupporting}}
					</div>
				</div>
				<div class="appCard_Section25pc">
					<div class="appCard_Label xxsmall">
						<i class="fa essicon-connections right-5"/>{{totalIntegrations}}
					</div>
				</div>
			</div>
            <div class="appCard_Middle">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Capabilities</div>
				</div>
				<div class="appCard_Section25pc appCard_Divider">
					<div class="appCard_Label xxsmall">
						<i class="fa essicon-target right-5"/>{{commodity}}
					</div>
				</div>
				<div class="appCard_Section25pc appCard_Divider">
					<div class="appCard_Label xxsmall">
						<i class="fa essicon-valuechain right-5"/>{{differentiating}}
					</div>
				</div>
			</div>
			<div class="appCard_Middle">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Service Match</div>
				</div>
				<div class="appCard_Section50pc displayTable">
					<div class="appCard_Label xxsmall">{{num}}
						<i class="fa fa-info-circle left-5"></i>
						<div class="text-default small hiddenDiv">
							<h5>Matched Services</h5>
							<ul class="small fa-ul">
								{{#each matchedServices}}<li><i class="fa fa-li essicon-radialdots"/>{{this.name}}</li>{{/each}}
							</ul>
							
						</div>	
					</div>
				</div>
			</div>
			<div class="appCard_Middle">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Codebase</div></div>
				<div class="appCard_Section50pc displayTable">
					<div class="appCard_Label xxsmall">{{nameSubString codebase}}</div>
				</div>
			</div>
			<div class="appCard_Middle">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Lifecycle</div>
				</div>
				<div class="appCard_Section50pc displayTable">
					<div class="appCard_Label xxsmall">{{nameSubString status}}</div>
				</div>
			</div>
			<div class="appCard_Bottom">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Annual Cost</div>
				</div>
				<div class="appCard_Section50pc displayTable">
                    <div class="appCard_Label xxsmall">{{currency}}{{getCost cost}}</div>
                    <div style="float:right">
                        <i style="color:#a67fcd"><xsl:attribute name="class">fa fa-question-circle appCompareButton right-5</xsl:attribute><xsl:attribute name="easid">{{id}}</xsl:attribute></i>
                    	</div>
				</div>
			</div>
		
		
		</div>
        </script>
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
    <xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/> 
        <xsl:param name="viewerAPIPathApps"/> 
        
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>'; 
        var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
       
       var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
//console.log(apiDataSetURL);    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
//console.log(this.responseText);  
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                            $('#ess-data-gen-alert').hide();
                        }
                    };
                    xmlhttp.onerror = function () {
                        reject(false);
                    };
                    xmlhttp.open("GET", apiDataSetURL, true);
                    xmlhttp.send();
                } else {
                    reject(false);
                }
            });
        };
       
        $('#show').hide();
           
              var currency;
              var fteRate;
              var appJSON2=[];
              var serviceJSON=[]
              var allStatus
              var comparisons=[];
              var appScenarioArray=[];
              var appoptions;  
  
              var appSum;  
              
              var services; 
              var servicesList; 
              var focusServices;       
              var focusedServices=0;  
              var focusProcesses=[];
              var clickedArray=[];
              var optionApps=[];
              var primeType=false;
              var optionCount=0;
              var optionCounter=0;
              var dynamicAppFilterDefs;
              
               function selectNewApp(){
            
                  $("#appServs").empty();
                  alli=$(".servicesNew").val();
                  var selitems=[];	
                  $('.servicesNew option:selected').each(function(){ selitems.push({"selectId":$(this).attr('name'),"name":$(this).text()}) });	
                  focusServices=selitems;
                  focusedServices=focusServices.length;
          
                  $("#appServs > tbody").empty();          
                                  <![CDATA[ $("#appServs").append("<tbody>");]]>
                                  for(i=0; i &lt; focusServices.length;i++){                                         
                                   <![CDATA[ $("#appServs").append("<li class='servs'><i class='fa fa-li essicon-radialdots'></i> "+focusServices[i].name+"</li>"); ]]>                                        
                                  }
                  getAllApps();
                  }
                       
               function selectApp(appl){
                  $("#appServs").empty();
                              focusServices=[];  
                              focusServicesWithProcess=[];  
                              focusProcesses=[]; 
                              count=0;
                                  var appSelected = appoptions.filter(function(d) {
                                          return d.key === appl;
                                      });
  
                              $("#appServs > tbody").empty();          
                                  <![CDATA[ $("#appServs").append("<ul>");]]>
                                    console.log('appSelected',appSelected)
                                  appSelected.forEach(function(item) {
                                    console.log('item',item)
                                      services= item.values[0].allServices;     
                                      services.forEach(function(item){
                                        console.log('item2',item)
                                        if(item.serviceId!=''){
                                          focusServices.push({"selectId":item.serviceId});     
                                          var servSelectedApps = serviceJSON.filter(function(d) {
  
                                          return d.serviceId === item.serviceId;
                                      });
                                    
           
                                      console.log('servSelectedApps',servSelectedApps)
                                  var appsUsingService = servSelectedApps[0].applications;
                                  var appsCount = (appsUsingService.length)-1;
                                  count=count+1;        
                                                                                             
                                   <![CDATA[ $("#appServs").append("<li class='servs'><i class='fa fa-li essicon-radialdots'></i> "+item.service+"</li>"); ]]>                     
                                    focusServicesWithProcess.push(item.processes);
                                     }
                                  });
  
                                  });
                              focusedServices=count; 
 
                  for(i=0;i&lt;focusServicesWithProcess.length;i++){
                      focusServicesWithProcess[i].forEach(function(item) {focusProcesses.push(item.process)});
                  };
              };        
                                   
             
              function getRelevantApps(){
 
                        Apps=[];
      
                              for(i=0;i &lt; serviceJSON.length;i++){
                              if(focusServices){
                               for(j=0;j &lt; focusServices.length;j++){
                                 if(serviceJSON[i].serviceId==focusServices[j].selectId){
                                      for(k=0;k &lt; serviceJSON[i].applications.length;k++){
                                          Apps.push(serviceJSON[i].applications[k]);
                                          }
                                      }
                                  }
                                }
                             }
                      }
              
              
              
              function getAllApps(){
 
                      $('#key').show();
                              d3.selectAll('.carddiv')
                              .remove()
                              var html=''; 
                
                           getRelevantApps();
 
                          var temp=[];
                          var uniqueApps=Apps.filter((x, i)=> {
                            if (temp.indexOf(x.id) &lt; 0) {
                              temp.push(x.id);
                              return true;
                            }
                            return false;
                          });

                            for(i=0;i &lt; uniqueApps.length;i++){
                              
                              var num=0;
                              var numsOfServs='';
                              if(uniqueApps[i] === 'Unknown'){}else{
              
                              var thisapp = appJSON2.filter(function (el) {   
           
                                    return el.id ===uniqueApps[i].id;
  
                                      });
                              var businessProcMap=[];
                              var keyapp='';
                              var prime=false;
                              var servicesHTML=''; 
                              var switchApp = '';                        
                              var svcMatch=[];
                              for(j=0;j &lt; thisapp[0].allServices.length;j++){
                                  for(k=0;k &lt; focusServices.length;k++){ 
                                      if(thisapp[0].allServices[j].serviceId==focusServices[k].selectId){ 
                                              num = num+1;         
                                              svcMatch.push({"id":thisapp[0].allServices[j].serviceId, "name":thisapp[0].allServices[j].service})
                                          for(l=0;l&lt;focusProcesses.length;l++)
                                                  {
                                             if(thisapp[0].allServices[j].processes){
                                              for(m=0;m &lt; thisapp[0].allServices[j].processes.length;m++){
                                             
                                                  if(thisapp[0].allServices[j].processes[m].process===focusProcesses[l]){
                                                      businessProcMap.push(thisapp[0].application)
                                                        }
                                                          }
                                                      }
                                                  }
                                              }
                                          }
                                      }
                                      thisapp[0]['matchedServices']= svcMatch                                         
                                  }  
                           
                              appid = thisapp[0].id;
                              score=((num/thisapp[0].allServices.length)*100);

                              var colour;
                              if(score &lt; 25){colour='#f5a5a5'}else if(score &gt; 75){colour='#97f0bd'} else {colour='#f5d79d'};
                              appS=[];                    
                              for(j=0;j &lt; thisapp[0].services.length;j++)
                                  {for(k=0;k &lt; focusServices.length;k++)
                                      {
                                          if(thisapp[0].services[j].serviceId==focusServices[k].selectId)
                                          {appS.push({"selectId":thisapp[0].services[j].serviceId,"name":thisapp[0].services[j].service})} 
                                      }  
                                  };
 
                              if(thisapp[0].services.length &lt;= num){
                              thisapp[0]['switch']=true}else{thisapp[0]['switch']=false}
                              thisapp[0]['costColour']=colour;
                              thisapp[0]['servicesUsed']=appS;
                              thisapp[0]['num']=num;
                              thisapp[0]['commodity']=thisapp[0].capsCount;
                              thisapp[0]['differentiating']=thisapp[0].capsValue;
                              thisapp[0]['numServicesUsed']=thisapp[0].services.length;
                              thisapp[0]['costValue']=currency+parseInt(thisapp[0].cost).toLocaleString()
                              thisapp[0]['serviceMatch']=appS;
                              thisapp[0]['currency']=currency;
                              thisapp[0]['interface']=thisapp[0].services;
                              thisapp[0]['url']='report?XML=reportXML.xml&amp;PMA='+thisapp[0].id+'&amp;cl=en-gb&amp;XSL=application/core_al_app_provider_summary.xsl';
                              thisapp[0]['score']=score;
                     
                              $("#cardsBlock").append(appCardTemplate(thisapp[0]));
              

                              const boxes = document.querySelectorAll('.carddiv');
                              let maxHeight = 0;
                              boxes.forEach(box => {
                                const height = box.clientHeight;
                                if (height > maxHeight) {
                                  maxHeight = height;
                                }
                              });
                              
                              // set the height of all boxes to the tallest height
                              boxes.forEach(box => {
                                box.style.height = `${maxHeight}px`;
                              });

                              clickedArray.forEach(function(d){
                                    $('.clicked'+d.id).css('color','green');
                                  });
                              };

                              $(".appCompareButtonFocus").on("click", function ()
                                    { 
                                        let selected = $("#application").val(); 
                                
                                        getModalInfo(selected)
                                    });

                              $(".appCompareButton").on("click", function ()
                                    {
                                     
                                        let selected = $(this).attr('easid')
                                 
                                        
                                        getModalInfo(selected)
                                    });

                                 
                                
                              focusApp=$("#application").val(); 
                              $('#'+focusApp).hide()
                             
                      
                              var $wrapper = $('#cardsBlock');
  
                                  $wrapper.find('.carddiv').sort(function(a, b) {
                                     return +b.dataset.num - +a.dataset.num;
                                  })
                                  .appendTo($wrapper);
                      
                              <!-- set sliders --> 
  
                              var highestNum = $(".carddiv").map(function() {
                                  return $(this).data('num');
                              }).get();//get all data values in an array
  
                              var highest = Math.max.apply(Math, highestNum);//find the highest value from them
                              $('.carddiv').filter(function(){
                                  return $(this).data('num') == highest;//return the highest div
                              });
  
                             output.innerHTML = 0;
  
                              $('#myRange').attr("max", highest);
  
                              var highestCostVal = $(".carddiv").map(function() {
                                  return $(this).data('cost');
                              }).get();//get all data values in an array
  
                              var highestCost = Math.max.apply(Math, highestCostVal);//find the highest value from them
                              $('.carddiv').filter(function(){
                                  return $(this).data('cost') == highestCost;//return the highest div
                              });
  
                              costoutput.innerHTML = 0;
                              $('#myCostRange').attr("max", highestCost);
  
                             var highestInterfaceVal = $(".carddiv").map(function() {
                                  return $(this).data('interface');
                              }).get();//get all data values in an array
  
                              var highestinterface = Math.max.apply(Math, highestInterfaceVal);//find the highest value from them
                              $('.carddiv').filter(function(){
                                  return $(this).data('interface') == highestinterface;//return the highest div
                              });
  
                              interfaceoutput.innerHTML = 0;
                              $('#myInterfaceRange').attr("max", highestinterface);
  // start ########
                       

                    // end ###################          

                          
                      };
                    
                      function getModalInfo(appId){
                                let appToShow =appJSON2.filter((d)=>{
                                            return d.id==appId;	
                                        })
                                       
                                        let appsOverlap=[] 
                                        let worker=appToShow[0].overlappingApplications
                                         
                                        worker.forEach((svc)=>{
                                            svc.apps.forEach((app)=>{
                                                console.log('app',app)
                                            let appName=appJSON2.find((e)=>{
                                                return e.id==app.id;
                                            })
                                            console.log('appName',appName)
                                            app['name']=appName.name;
                                            appsOverlap.push(app);
                                            })
                                        }) 

                                        var servCount = d3.nest()
                                        .key(function(d) { return d.name; })
                                        .rollup(function(v) { return v.length; })
                                        .entries(appsOverlap); 
                                        servCount.sort((a,b) => b.value - a.value);
console.log('servCount',servCount)
                                       getMax=d3.max(servCount, d => d.value)

                                        servCount.forEach((d)=>{
                                            if(getMax - d.value &lt; 2){
                                                if(d.key != appToShow[0].application){
                                                d['candidate']='Yes';
                                                }
                                            }
                                        })
                                        console.log('appToShow[0]',appToShow[0])
                                        console.log('appToShow[0].application',appToShow[0].application)
                                        appToShow[0]['appMap']=servCount;
                                  
                                        $('#appData').html(appTemplate(appToShow[0]));
                                        $('#appPanel').show( "blind",  { direction: 'down', mode: 'show' },200 );
                                        
                                        //$('#appModal').modal('show');
                                        $('.closePanelButton').on('click',function(){
                                           
                                            $('#appPanel').hide();
                                        })
                                         
                                        $('#recalc').on('click', function(){
                                            
                                            let daysperInt=$('#daysInt').val();  
                                            let daysperProc=$('#procdaysInt').val();
                                            let fterate=$('#rate').val(); 
                                            let integrations=$('#daysInt').attr('int'); 
                                            let procDays=$('#procdaysInt').attr('intProc'); 
                                            
                                            
                                            let newTotal= ((integrations*daysperInt)+(procDays*daysperProc))*fterate;
                                            let newDaysTotal=(integrations*daysperInt)+(procDays*daysperProc);
                                            $('#effort').text(currency+parseInt(newTotal).toLocaleString());
                                            $('#effort').attr('cost',newTotal);
                                            $('#dayseffort').text(newDaysTotal);
                                            
                                        }) 
 
                               }                      


              function calcCost(){
                  
   
                var costMetrics = d3.nest()
                    .key(function(d) { return d.name; })
                    .rollup(function(v) { return {
                      total: d3.sum(v, function(d) { return d.cost; })
                    }; })
                    .entries(optionApps);

                var spendMetrics = d3.nest()
                    .key(function(d) { return d.name; })
                    .rollup(function(v) { return {
                      total: d3.sum(v, function(d) {return parseInt(d.scenarioCostNum); })
                    }; })
                    .entries(optionApps); 
 
                    let sum =0
                      if(costMetrics[0]){
                        costMetrics.forEach((d)=>{
                            sum=sum+d.value.total
                        }) 
                          } 
                          let spend=0;

                        if(spendMetrics[0]){
                              spendMetrics.forEach((d)=>{
                                spend=spend+d.value.total
                            })  
                          };


                  $('#totalSaving').text(currency+" "+Math.round(sum).toLocaleString());
                  optionApps['optionSaving']=currency+" "+Math.round(sum).toLocaleString() 
                  optionApps['optionSpend']=currency+" "+Math.round(spend).toLocaleString() 
                  percentNum=(sum/appSum)*100
                  $('#percentSaving').text(Math.round(percentNum)+'%');
                  optionApps['optionPercent']=Math.round(percentNum)+'%'
              }
              
              function showPrime(ele){
              if (ele === 'off')
              {;primeType=false;}
              else
              {;primeType=true}
              updateCards();
              }
               
              function ResetAll(){
            
              $('#myRange').attr('value',1);;
              $('#myCostRange').attr('value',0);
              $('#myInterfaceRange').attr('value',0);
              $('#inverse').attr('checked',true);
              $('#ticks').val(null).trigger('change');
              $('#SLs').val(null).trigger('change');
              updateCards();
              }
              
              $('.inverse').on('change',function(){
                updateCards();
              })
           
              
              function updateCards(){
                               
                redrawView()
                   
              }
             
              
               function hideClass(thisVal){ 
                  $('.'+thisVal).hide();            
                      }
              
               function showClass(thisVal){ ;
                  $('.'+thisVal).show();
                      }
  var allScenarios, ideasArray;
        $('document').ready(function () {
            $('#compBox').hide();
            appFragment = $("#app-template").html();
            appTemplate = Handlebars.compile(appFragment);	

            Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
                return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
            });	
            
            Handlebars.registerHelper('calcEffort', function(arg1,arg2, arg3, arg4, arg5) {
               
                return (((parseInt(arg1)*arg4)+(parseInt(arg2)*arg5))*fteRate).toLocaleString();
            });	
            Handlebars.registerHelper('calcEffortSimple', function(arg1,arg2, arg3, arg4, arg5) { 
                return (((parseInt(arg1)*arg4)+(parseInt(arg2)*arg5))*fteRate);
            });	
            
            Handlebars.registerHelper('calcDaysEffort', function(arg1,arg2,arg3, arg4) {
                return (parseInt(arg1)*arg3)+ (parseInt(arg2)*arg4);
            });	
            Handlebars.registerHelper('calcComplexity', function(obj) { 
                let score=obj.complexity; 
                if(score &lt;20){
                    return '<div class="ess-tag"><xsl:attribute name="style">color:#fff;background-color:#4aba57</xsl:attribute><i class="fa fa-line-chart right-5"/>Low Application Complexity</div>';
                }else if(score &lt;60){
                    return '<div class="ess-tag"><xsl:attribute name="style">color:#fff;background-color:#f0a843</xsl:attribute><i class="fa fa-line-chart right-5"/>Medium Application Complexity</div>'
                }else{
                return '<div class="ess-tag"><xsl:attribute name="style">color:#fff;background-color:#e04031</xsl:attribute><i class="fa fa-line-chart right-5"/>High Application Complexity</div>';
                }
            });	

            Handlebars.registerHelper('calcComplexitySimple', function(obj) { 
                let score=obj.complexity; 
                if(score &lt;20){
                    return '<small><div class="ess-tag"><xsl:attribute name="style">color:#fff;background-color:#4aba57</xsl:attribute><i class="fa fa-line-chart right-5 fa-sm"/>Low</div></small>';
                }else if(score &lt;60){
                    return '<small><div class="ess-tag"><xsl:attribute name="style">color:#fff;background-color:#f0a843</xsl:attribute><i class="fa fa-line-chart right-5  fa-sm"/>Medium</div></small>'
                }else{
                return '<small><div class="ess-tag"><xsl:attribute name="style">color:#fff;background-color:#e04031</xsl:attribute><i class="fa fa-line-chart right-5  fa-sm"/>High</div></small>';
                }
            });

            Handlebars.registerHelper('drawDots', function(arg1) {
                let str='';
                for(let i=0;i&lt;arg1;i++){
                    str=str+'<i class="fa fa-circle dots"></i>'
                }
                return str;
            });	
       //OPTON 1: Call the API request function multiple times (once for each required API Report), then render the view based on the returned data
            Promise.all([
                promise_loadViewerAPIData(viewAPIData),
                promise_loadViewerAPIData(viewAPIDataApps),
                 
            ])
            .then(function(responses) {
                //after the data is retrieved, set the global variable for the dataset and render the view elements from the returned JSON data (e.g. via handlebars templates)
                let viewAPIData = responses[0];
                let appsData = responses[1];
                //render the view elements from the first API Report
            
                //render the view elements from the second API Report
             

              appJSON=viewAPIData.applications;
              appJSON2=appsData.applications;
              if(appJSON2.length&gt;250){ 
                $('#insightTab').remove(); 
              }
              serviceJSON=viewAPIData.services;
              codebaseJSON=viewAPIData.codebase;
              currency=viewAPIData.currency; 
              filters=appsData.filters;
 
              filters.sort((a, b) => (a.id > b.id) ? 1 : -1) 
                dynamicAppFilterDefs=filters?.map(function(filterdef){
                    return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
                });
          
              if(fteRate){} else{fteRate=600}
              let life=appsData.filters.find((l)=>{
                return l.slotName=='lifecycle_status_application_provider';

                }) 
               let codebase= appsData.filters.find((l)=>{
                return l.slotName=='ap_codebase_status';

                }) 
              for (const a of appJSON2) {

                a['totalIntegrations']=parseInt(a.inI)+parseInt(a.outI);
                a['scenarioCostNum']=((a.totalIntegrations*4)+(a.physP.length*2))*600;
                a['scenarioCost'] = currency+a.scenarioCostNum;
                a['processesSupporting']=a.physP.length;
                a['complexity']=(a.totalIntegrations+a.processesSupporting)*a.services.length
              
                let lifeVal=life.values.find((e)=>{
                    return e.id == a.lifecycle_status_application_provider
                })
       
                if(lifeVal){
                a['status']=lifeVal.name;
                }else{
                    a['status']='Not Set'
                }

                let codeVal=codebase.values.find((e)=>{
                    return e.id == a.ap_codebase_status
                })
       
                if(codeVal){
                a['codebase']=codeVal.name;
                }else{
                    a['status']='Not Set'
                }
                const match = appJSON.find((b) => a.id === b.id);
                if (match) {
                    if(match.cost){
                        a.cost = match.cost;
                    }
                     
                    if(match.services){ 
                        a['allServices'] = match.services
                    }
                    a['overlappingApplications']=match.overlappingApplications;
                    a['processList']=match.processList;
                }
                
              }
            
              if(appJSON.length&lt;100){
                scenarioBuilder(appJSON2)
              }

              $('#rate').val(fteRate)
             
              $('#appPanel').hide();
 <!-- v1           appoptions = d3.nest()
                            .key(function(d) { return d.id; })
                            .entries(appJSON);               

            appSum = appJSON.reduce(function(sum, d) {
                  return sum + parseInt(d.cost);
                }, 0);
-->
                appoptions = d3.nest()
                .key(function(d) { return d.id; })
                .entries(appJSON2);               

                appSum = appJSON2.reduce(function(sum, d) {
                    return sum + parseInt(d.cost);
                }, 0);    
 
            services =d3.nest()
                .key(function(d) { return d.service; })
                .entries(serviceJSON);  
   
                services.forEach((s)=>{ 
                   let match= serviceJSON.find((sv)=>{
                        return s.key==sv.service
                    })  
                    s['id']=match.serviceId;
                })
        
            servicesList=services
            allStatus=  appJSON2.map(function (d) {return d.status;}) ;  
       
            let unique = allStatus.filter((item, i, ar) => ar.indexOf(item) === i)
			unique=sortList(unique);
  
            for(i=0;i &lt; unique.length; i++){
                $('#SLs').append('<option id="s'+unique[i].replace(/\s/g, '')+'" name="s'+unique[i].replace(/\s/g, '')+'" value="'+unique[i]+'">'+unique[i]+'</option>');
            }


            $('#SLs').on('change',function(){
                updateCards();
            });
            $('#ticks').on('change',function(){
                updateCards();
            });

            for(i=0;i&lt; appJSON2.length; i++){
                $('#application').append('<option name="'+appJSON2[i].id+'" value="'+appJSON2[i].id+'">'+appJSON2[i].name+'</option>');
            }
            
            for(i=0;i&lt; serviceJSON.length; i++){
                $('#selBox').append('<option name="'+serviceJSON[i].serviceId+'" value="'+serviceJSON[i].serviceId+'">'+serviceJSON[i].service+'</option>');
            }

            for(i=0;i&lt; codebaseJSON.length; i++){
                $('#ticks').append('<option name="'+codebaseJSON[i].id+'" value="'+codebaseJSON[i].id+'">'+codebaseJSON[i].name+'</option>');
            }
              

  function sortList(arr){
            arr.sort(function(a, b){
						if(a &lt; b) { return -1; }
						if(a > b) { return 1; }
						ret;
            });
            return arr
  }          

    $('#application').on('change', function(){
        let thisApp=$(this).val();
    $('.appCompareButtonFocus').show();
        selectApp(thisApp);
        getAllApps();
        showInfoTooltips();
    });

    $(document).on("click", '.sendApp', function(){
                                
        $('#mainPageTabs a[href="#cost"]').effect("highlight", {color: '#d3d3d3'}, 1000);
      theColourIs = $(this).css("color");
     
     //var thisApp=$(this).parent().parent().parent().parent()[0].id;
        let thisApp= $(this).attr('easappid')
   
        let thisAppType= $(this).attr('eastypeid')
        var getApp=appJSON2.find(function(d){   
            return d.id==thisApp; 
        });


        let otherChanges=[]
if(thisAppType=='Scenario'){
        let thisScenario=appScenarioArray.find((f)=>{
            return f.app2==thisApp;
        })

        console.log('appScenarioArray send',appScenarioArray)

        var getScenApp=appJSON2.find(function(d){   
            return d.id==thisScenario.app1; 
        });
        console.log('getScenApp',getScenApp)
        
     
        console.log('matchedOpportunity',matchedOpportunity) 
        otherChanges.push({"svcid":"", "service":"Primary", "id": getScenApp.id,"appname": getScenApp.name, "action":"Enhance"})
            thisScenario.differences?.forEach((f)=>{
              
               if(f.options){
                   if(f.options[0]){
                   f.options[0]['action']="Enhance";
                   f.options[0]['id']=f.options[0].appid;
                   otherChanges.push({"svcid":f.serviceId, "service":f.service, "id": f.options[0].appid,"appname": f.options[0].appName, "action":"Enhance"})
                   }
               }
           }) 
        clickedArray.push({"id":thisApp,"action":"Retire", "otherChanges":otherChanges});
  
        console.log('otherChanges',otherChanges)
}
 
      if(theColourIs==='rgb(211, 211, 211)'){
          $(this).css('color','green');
      
        let formatSpend=parseInt(getApp.scenarioCostNum).toLocaleString();
            getApp['scenarioCost']=currency+formatSpend; 
            getApp["costValue"]=currency+" "+Math.round(getApp.cost).toLocaleString() 
            getApp["otherChanges"]=otherChanges;
            getApp["action"]='Retire';
 
        optionApps.push(getApp);
     
        $("#costBlock").append(costCardTemplate(getApp));
          
    <!--  var costApp=appJSON2.filter(function(d){
              if(d.id===thisApp){    
              return d;
              }
          });
      
      let formatSpend=parseInt(costApp[0].scenarioCostNum).toLocaleString();
      costApp[0]['scenarioCost']=currency+formatSpend;-->

      
    <!--  calcCost();-->

        $('.removeApp').off().on("click", function(){ 
          item2remove=$(this).data('aid'); 
    
          var index = clickedArray.findIndex(item => item.id === item2remove); // Find the index of the object with the matching 'id' property
            if (index > -1) {
                clickedArray.splice(index, 1); // Remove the object from the array
               
            }

             
      <!--
            var index = clickedArray.indexOf(item2remove.id);
              if (index > -1) {
                clickedArray.splice(index, 1);
          }
          -->
          $('.clicked'+item2remove).css('color','#d3d3d3');
          $(this).parent().parent().remove();
          

var filtered = optionApps.filter(function(value, i, arr){
      return arr[i].id != item2remove;
  });
 
optionApps=filtered;
var newArray=filtered; 
<!--calcCost();-->
          });
     }
else if(theColourIs==='rgb(0, 128, 0)'){
  $(this).css('color','#d3d3d3');
item2remove=thisApp;
    var index = clickedArray.findIndex(item => item.id === item2remove.id); // Find the index of the object with the matching 'id' property
    if (index > -1) {
        clickedArray.splice(index, 1); // Remove the object from the array
      
    }
          
         $('[eas-id="'+thisApp+'"]').remove();
          

var filtered = optionApps.filter(function(value, i, arr){
      return arr[i].id != item2remove.id;
  });

optionApps=filtered;
var newArray=filtered; 
<!-- calcCost();  -->          
}
      else {}
          
      })

var carriedApps = JSON.parse(sessionStorage.getItem("context"));
                    if(carriedApps){
                        if(carriedApps.Composite_Application_Provider.length &gt; 0){
                            //if only one don't show basket 
                            if(carriedApps.Composite_Application_Provider.length==1){ 
                        
                            $('#application').val(carriedApps.Composite_Application_Provider[0]); // Select the option 
                            $('#application').trigger('change');
                            }else{
                            $('#carriedApps').show()
                            var selectArray=[];
          console.log('carriedApps',carriedApps)
						carriedApps.Composite_Application_Provider.forEach(function(d){
					
							var thisApp=appJSON2.filter(function(e){
								return e.id==d;
							});
					    selectArray.push({val : thisApp[0].id, text: thisApp[0].name});
					 
						});
                        console.log('selectArray',selectArray)    
					selectArray.sort(function(a, b){
						if(a.text &lt; b.text) { return -1; }
						if(a.text > b.text) { return 1; }
						return 0;
					})
					selectArray.unshift({val : '', text: 'choose'});
					var sel = $('&lt;select id="carriedSelect">').appendTo('#selPlace');
					$(selectArray).each(function() {
					 sel.append($("&lt;option>").attr('value',this.val).text(this.text));
					});
					
							};
					
					$('#carriedSelect').change(function(){
						selectApp($(this).val());
						getAllApps();
						showInfoTooltips()
					$('#'+$(this).val()).hide();
					
					});	
                    };	
                    $('#carriedSelect').select2();
					};


                  
                  //  let allFilters=[...responses[0].filters, ...responses[1].filters];
                   essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS', 'ACTOR_TO_ROLE_RELATION','Product_Concept', 'Business_Domain'], '', true);
                
			           $('#homeTab').on('click', function(){
                        matchedOpportunity=[];
                    })
		
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });

            function compareApps(apps1, apps2) {
                let missing=[];
                let count = 0;
                for (let i = 0; i &lt; apps1.length; i++) {
                  for (let j = 0; j &lt; apps2.length; j++) { 
                    if (apps1[i].serviceId === apps2[j].serviceId) {
                      count++; 
                    } 
                  }
                }

                const totalapps = apps1.length + apps2.length - count;
                const matchPercentage = count / apps1.length * 100;
                const inversePercentage= count / apps2.length * 100;
                return { count, matchPercentage, inversePercentage };
              }
      
          function scenarioBuilder(data){
          
            let scenarioArray=[];
            // loop through all pairs of people and count the number of people who have similar apps
                let numMatches = 0;
                for (let i = 0; i &lt; data.length - 1; i++) {
                    for (let j = i + 1; j &lt; data.length; j++) {
               
                          let uniqueArray1 = data[i].allServices.filter(obj => !data[j].allServices.find(o => o.serviceId === obj.serviceId));
                          let uniqueArray2 = data[j].allServices.filter(obj => !data[i].allServices.find(o => o.serviceId === obj.serviceId));
                     
                        let { count, matchPercentage, inversePercentage } = compareApps(data[i].allServices, data[j].allServices);
                        
                        if (count > 0) {
                        numMatches++;
                    scenarioArray.push({"app1": data[i].id,"app2": data[j].id, "overlap":count, "percentage": matchPercentage.toFixed(2), "inversePercentage":inversePercentage.toFixed(2) ,"complexity": data[i].complexity, "differences":uniqueArray1});
                        }
                
                    }
                }

                var scenarios1 = d3.nest()
                    .key(function(d) { return d.app1; }) 
                    .entries(scenarioArray);
                     
                    scenarios1 = scenarios1.map(obj => ({ ...obj }));
                    

                    var scenarios2 = d3.nest()
                    .key(function(d) { return d.app2; }) 
                    .entries(scenarioArray);
                    scenarios2 = scenarios2.map(obj => ({ ...obj, type: "to" }));
                   
                    scenarios2.forEach((d)=>{
                        let scenario2Temp=[]
                        d.values.forEach((e)=>{
                            const { app1, app2, ...rest } = e;
                            const swappedObj = { app1: app2, app2: app1, ...rest };
                            scenario2Temp.push(swappedObj)
                        })
                        d.values=scenario2Temp;
                    })
                
                    allScenarios=[...scenarios1, ...scenarios2]
                   
                    const highestPercentageByCategory = {};
                    allScenarios.forEach(group => {
                        
                        const highestPercentageObj = d3.max(group.values, d => Number(d.percentage));
                       
                        highestPercentageByCategory[group.key] = highestPercentageObj; 
                      });

                      const result = Object.values(
                        allScenarios.reduce((acc, curr) => {
                          if (!acc[curr.key]) {
                            acc[curr.key] = { key: curr.key, values: [...curr.values] };
                          } else {
                            acc[curr.key].values = acc[curr.key].values.concat(curr.values);
                          }
                          return acc;
                        }, {})
                      ).map(obj => ({ ...obj, values: obj.values.flat() }));
                       
                      allScenarios=result;

                       ideasArray=[];
                      const keys = Object.keys(highestPercentageByCategory);
 
                      keys.forEach((e)=>{ 
                            let match=data.find((f)=>{
                                return e ==f.id;
                            })
                     
                            let complexityScore=0;
                            if(match.complexity &lt; 20){ complexityScore=1}
                            else if(match.complexity &lt; 40){ complexityScore=2}
                            else if(match.complexity &lt; 60){ complexityScore=3}
                            else if(match.complexity &lt; 100){ complexityScore=4}
                            else { complexityScore=5}
            
                            ideasArray.push({"id":match.id, "name":match.name, "mapping": highestPercentageByCategory[e]/100, "complexity": complexityScore, "cost":match.cost}) 
     
                        
                        })
                   
                    let highestScore = ideasArray.reduce(function(prev, current) {
                        return (parseInt(prev.cost) > parseInt(current.cost)) ? prev : current
                      });

                    var costBig=30/highestScore.cost;
 
   
                    // Set up the dimensions of the chart
                  
                    // Set up the dimensions of the chart
                    var margin = {top: 20, right: 40, bottom: 30, left: 40},
                        width = window.innerWidth - margin.left - margin.right - 50,
                        height = 200 - margin.top - margin.bottom;
                    
              
                    // Create the SVG element that will hold the chart
                    var svg = d3.select("#chart").append("svg")
                        .attr("width", width + margin.left + margin.right)
                        .attr("height", height + margin.top + margin.bottom)
                      .append("g")
                        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
                    
                    // Load the data from the array
                    var data = ideasArray;
                    // Set up the scales for the X and Y axes
                    var x = d3.scaleLinear()
                        .domain([0, 1])
                        .range([0, width]);
                    var y = d3.scaleLinear()
                        .domain([0, 5])
                        .range([height, 0]);
                    
                    // Create the X axis
                    var xAxis = d3.axisBottom(x)
                        .tickFormat(d3.format(".0%"));
                    svg.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis);
                    
                    // Create the Y axis
                    var yAxis = d3.axisLeft(y)
                        .ticks(5);
                    svg.append("g")
                        .attr("class", "y axis")
                        .call(yAxis);
                    
                    // Create the bubbles
                    var bubbles = svg.selectAll(".bubble")
                        .data(data)
                        .enter()
                        .append("g");

                        bubbles.append("circle")
                        .attr("class", "bubble")
                        .attr("cx", function(d) { return x(d.mapping); })
                        .attr("cy", function(d) { return y(d.complexity); })
                        .attr("r", function(d) { 
   
                                return costBig*parseInt(d.cost); })
                        .on("click", function(d) { 
                           
                           focusApp=allScenarios.find((e)=>{
                            return e.key==d.id;
                           })
                           $('#compBox').show();
                           getData(focusApp)
                            
                          });

                        bubbles.append("text")
                        .attr("class", "bubble-label")
                        .attr("x", function(d) { return x(d.mapping); })
                        .attr("y", function(d) { return y(d.complexity); })
                        .text(function(d) { return d.name; });
                   
                    // Create the tooltip
                    var tooltip = d3.select("body").append("div")
                        .attr("class", "tooltip")
                        .style("opacity", 0);

                    function ticked() { 
                        bubbles.selectAll(".bubble")
                            .attr("cx", function(d) {  return d.x; })
                            .attr("cy", function(d) {  return d.y; });
                        bubbles.selectAll(".bubble-label")
                            .attr("x", function(d) { return d.x; })
                            .attr("y", function(d) { return d.y; });
                          }
                
               // Set up the simulation to position the bubbles
                    var simulation = d3.forceSimulation(data)
                    .force("x", d3.forceX(function(d) { return x(d.mapping); }).strength(0.05))
                    .force("y", d3.forceY(function(d) { return y(d.complexity); }).strength(0.05))
                    .force("collide", d3.forceCollide(12))
                    .on("tick", ticked)
                    .stop();
                    simulation.restart(); 
                    // Start the simulation
                    for (var i = 0; i &lt; 100; ++i){   
                     simulation.tick()
                    };
                                        
                    // Position the bubbles based on the simulation
 
                    svg.append("text")
                        .attr("class", "axis-label")
                        .attr("text-anchor", "middle")
                        .attr("transform", "rotate(-90)")
                        .attr("x", 0 - (height / 2))
                        .attr("y", 12)
                        .text("Complexity");
                
                    // Add the horizontal label for 'replaceability'
                    svg.append("text")
                        .attr("class", "axis-label")
                        .attr("text-anchor", "middle")
                        .attr("x", width / 2)
                        .attr("y", 175)
                        .text("Opportunity");
        }

        function getData(app){
            appScenarioArray=[];
            let mappings=[];
            let thisApp=appJSON2.find((e)=>{
                return e.id==app.key
            }) 
            console.log('app',app)
            app.values.forEach((d)=>{
                let matches=appJSON2.find((e)=>{
                    return e.id==d.app2
                })
                if(matches){ 
                
                mappings.push({"app": thisApp.name, "app1id":d.app1,"app2id":d.app2, "percentage":d.percentage, "app2":matches.name,  "inversePercentage":d.inversePercentage})
                }
            })
          
            let matchApp=appJSON2.find((e)=>{
                return e.id==app.key
            })

            app['name']=matchApp.name;
            $('#clickedApp').text(thisApp.name)
           
            mappings['ht']=mappings.length;
 
            svgwidth=  $('#comparison').width();
            $('#comparison').html(lineSVGTemplate(mappings))

        }

        });

var redrawView=function(){
  
    essResetRMChanges();
 
  appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
  geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
  visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
  prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept'); 
   

  scopedApps = essScopeResources(appJSON2, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef].concat(dynamicAppFilterDefs));
 

  services=($('#myRange').val());
  costs= ($('#myCostRange').val());
  servs= ($('#myRange').val());
  codebase= ($('#ticks').val());
  interfaces=($('#myInterfaceRange').val());
  statusVals=($('#SLs').val());
  
  thisAppCost = scopedApps.resources.filter(function (el) {  
                          if($('#inverse').is(":checked") == false){
                              return parseInt(el.cost) &lt;= costs;
                              } 
                              else
                              {
                              return parseInt(el.cost) &gt;= costs;
                              }
                          });

  
  if(codebase.length &gt; 0){
  thisAppCode = thisAppCost.filter(function (el) {  
                 
            for(var i=0;i &lt; codebase.length; i++){   
                if(codebase[i] === el.ap_codebase_status[0]){
                    return el;
                    }
                else if(codebase[i]==='Not Defined' &amp;&amp; el.codebase ==='Not Defined'){     return el;}
                }
                });
          }
          else
          {
              thisAppCode = thisAppCost;
          } 
          if(statusVals.length &gt; 0){
          thisAppStatus = thisAppCode.filter(function (el) {  
                       
                for(var i=0;i &lt; statusVals.length; i++){  
                if(statusVals[i] == el.status){ 
                    return el;
                    }
                }
                });
              }
          else{
          thisAppStatus=thisAppCode;
          }
     
          if(focusServices?.length&gt;0){
          thisAppServices = thisAppStatus.filter(function (el) {  
                              num=0;
                              for(j=0;j &lt; el.allServices.length;j++){
                                  if(focusServices){
                                      for(k=0;k &lt; focusServices.length;k++){ 
                                          if(el.allServices[j].serviceId==focusServices[k].selectId){
                                              num = num+1;       
                                              }
                                          }
                                          }  
                                      }
                                  if(num &gt;= servs){
                                      return el;
                                      }
                                  });
                }
            else{
                    thisAppServices=thisAppStatus
                } 
        thisAppInterfaces =thisAppServices.filter(function (el) {
                                      return parseInt(el.totalIntegrations) &gt;= interfaces;
                                      }); 
          $('.carddiv').hide(); 
  
          for(var i=0; i &lt; thisAppInterfaces.length; i++){
                  $('#'+thisAppInterfaces[i].id).show();
                  
                  if(primeType===true){$('.carddiv[data-prime=false]').hide()}
                  }
          focusApp=$("#application").val();; 
              $('#'+focusApp).hide();
              
          showInfoTooltips()

}
        
    </xsl:template>  

</xsl:stylesheet>
