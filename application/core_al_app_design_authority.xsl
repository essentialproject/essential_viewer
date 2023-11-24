<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"  xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>
	<xsl:param name="param2"/>
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="productRoles" select="node()/simple_instance[type='Technology_Product_Role']"/>
    <xsl:variable name="products" select="node()/simple_instance[type='Technology_Product']"/>	
    <xsl:variable name="roles" select="node()/simple_instance[type='Technology_Component']"/>	
    <xsl:variable name="apps" select="node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]"/>	
    <xsl:variable name="approles" select="node()/simple_instance[type='Application_Provider_Role']"/>	
    <xsl:variable name="appservices" select="node()/simple_instance[type='Application_Service']"/>	    
    <xsl:variable name="lifecycleStatus" select="node()/simple_instance[type='Lifecycle_Status']"/>	 
    <xsl:variable name="appUsage" select="node()/simple_instance[type='Static_Application_Provider_Usage']"/>
    <xsl:variable name="appUsageArch" select="node()/simple_instance[type='Static_Application_Provider_Architecture']"/>
	<xsl:variable name="techStandard" select="node()/simple_instance[type='Technology_Provider_Standard_Specification']"/>
	<xsl:variable name="appStandard" select="node()/simple_instance[type='Application_Provider_Standard_Specification']"/>
	<xsl:variable name="standardStrength" select="node()/simple_instance[type='Standard_Strength']"/>
	<xsl:variable name="standardStrengthStyle" select="node()/simple_instance[type='Element_Style'][name=$standardStrength/own_slot_value[slot_reference='element_styling_classes']/value]"/>
    <xsl:variable name="appInterface" select="node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']"/>
    <xsl:variable name="busPrinciples" select="node()/simple_instance[type='Business_Principle']"/>
    <xsl:variable name="appPrinciples" select="node()/simple_instance[type='Application_Architecture_Principle']"/>
    <xsl:variable name="techPrinciples" select="node()/simple_instance[type='Technology_Architecture_Principle']"/>
    <xsl:variable name="infoPrinciples" select="node()/simple_instance[type='Information_Architecture_Principle']"/>   
	<xsl:variable name="allPrinciples" select="$busPrinciples union $appPrinciples union $techPrinciples union $infoPrinciples"/>   
    <xsl:variable name="goals" select="node()/simple_instance[type=('Business_Goal','Application_Architecture_Goal','Information_Architecture_Goal','Technology_Architecture_Goal')]"/> 
    <xsl:variable name="objectives" select="node()/simple_instance[type=('Business_Objective','Application_Architecture_Objective','Information_Architecture_Objective','Technology_Architecture_Objective')][name=$goals/own_slot_value[slot_reference='goal_supported_by_objectives']/value]"/>  	
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
	<xsl:variable name="isEIPMode">
			<xsl:choose>
				<xsl:when test="$eipMode = 'true'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
                <script src="js/d3/d3_4-11/d3.min.js?release=6.19"/>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Design Authority')"/></title>
				<script src="js/FileSaver.min.js?release=6.19"/>
                <style>
                	 .fade-in {
                            opacity: 1;
                            animation-name: fadeInOpacity;
                            animation-iteration-count: 1;
                            animation-timing-function: ease-in;
                            animation-duration: 2s;
                        }
                        @keyframes fadeInOpacity {
                            0% {
                                opacity: 0;
                            }
                            100% {
                                opacity: 1;
                            }
                        }
					.tdcoltitletop {
						border-bottom:1pt solid #656565;
						color:#656565;
						font-size:1.1em
					}
					.tdcoltitle {
						border-bottom:1pt solid #656565;
						color:#656565;
						font-size:1.1em;
						padding-top: 10px
					}
						.tdcol {
						border-bottom:0pt solid #656565;
						color:#000000;
						font-size:1.0em
					}
                 <!--#principleDIV {
                    border: 1px solid #d3d3d3;
                    font-size:9pt;
                    margin-bottom:5px;
                    margin-right:3px;
                    -webkit-animation: mymove 5s ; /* Chrome, Safari, Opera */
                    animation: mymove 10s ;
                }-->

                /* Chrome, Safari, Opera */
                @-webkit-keyframes mymove {
                    50% {border-radius: 10px;}
                }

                /* Standard syntax */
                @keyframes mymove {
                    50% {border-radius: 10px;}
                }   
				.appCellDefault {
					color:white;
					text-align: center;
					border-radius: 4px;
					font-size:9pt
				}
				.status {
					
					border-radius: 4px;
					padding: 2px 4px;
					text-align: center;
				}
				.productPopup {
					border:1pt solid #ccc;
					border-radius:4px;
					box-shadow: 0 2px 4px rgba(0,0,0,.25);
					background-color:#ffffff;
					width:300px;
					display:none;
					padding:5px
				}
				.techProdStatus {
					cursor: pointer;
				}
				
				<!--#summary-layout label {
					text-transform: uppercase;
					border-bottom: 1px solid #ccc;
					display: block;
					font-size: 1.1em;
					color: #666;
				}-->
			</style>
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
									<span class="text-darkgrey">Design Authority</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
	                    <div class="col-xs-12">
							<ul class="nav nav-tabs">
							  	<li class="active"><a data-toggle="tab" href="#strategy"><xsl:value-of select="eas:i18n('Strategy')"/></a></li>
								<li><a data-toggle="tab" href="#principles"><xsl:value-of select="eas:i18n('Principles')"/></a></li>
							  	<li><a data-toggle="tab" href="#change"><xsl:value-of select="eas:i18n('Change')"/></a></li>
								<li><a data-toggle="tab" href="#summary" class="summary"><xsl:value-of select="eas:i18n('Summary')"/></a></li>
							</ul>
							<div class="tab-content">
								<div id="strategy" class="tab-pane fade in active">
									<div class="row top-15">
										<div class="col-md-6">
											<div class="panel panel-default">
												<div class="panel-heading">
													<h3 class="panel-title"><xsl:value-of select="eas:i18n('Details')"/></h3>
												</div>
												<div class="panel-body">
													<label><xsl:value-of select="eas:i18n('Title')"/></label>
													<input type="text" id="title" class="form-control bottom-15"/>
													<label><xsl:value-of select="eas:i18n('Owner')"/></label>
													<input type="text" id="owner" class="form-control bottom-15"></input>
													<label><xsl:value-of select="eas:i18n('Narrative')"/></label>
													<textarea id="narrative" name="narrative" rows="4" cols="75" class="form-control bottom-15"/>
													<label><xsl:value-of select="eas:i18n('Estimated Cost')"/></label>
													<input type="text" id="cost" class="form-control"/>
												</div>
											</div>
										</div>
										<div class="col-md-6">
											<div class="panel panel-default">
												<div class="panel-heading">
													<h3 class="panel-title"><xsl:value-of select="eas:i18n('Goals')"/></h3>
												</div>
												<div class="panel-body">
													<div id="gls" class="top-10"/>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div id="principles" class="tab-pane fade in">
									<div class="row top-15">
										<div class="col-xs-12" id="sortable">
										 	<div class="panel panel-default">
												<div class="panel-heading">
													<h3 class="panel-title"><xsl:value-of select="eas:i18n('Principles Adhering To')"/></h3>
												</div>
												<div class="panel-body">
													<table class="table principleTable">
														<thead>
															<tr>
																<th><xsl:value-of select="eas:i18n('Principle')"/></th>
																<th><xsl:value-of select="eas:i18n('Adherence')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:apply-templates select="$busPrinciples" mode="getPrinciples"/>
															<xsl:apply-templates select="$appPrinciples" mode="getPrinciples"/>
															<xsl:apply-templates select="$techPrinciples" mode="getPrinciples"/>
															<xsl:apply-templates select="$infoPrinciples" mode="getPrinciples"/>
														</tbody>
													</table>
												</div>
										 	</div>
										</div>
									</div>
								</div>
			
					  			<div id="change" class="tab-pane fade in">					
					                <div class="row top-15">
					                    <div class="col-md-6" >
					                        <div class="panel panel-default">
					                        	<div class="panel-heading">
													<h3 class="panel-title"><xsl:value-of select="eas:i18n('Impacted Elements')"/></h3>
												</div>
												<div class="panel-body">
													<div class="row">
														<div class="col-xs-6">
								                            <label><xsl:value-of select="eas:i18n('Application')"/></label>
								                            <div class="form-group" >
								                                <div>
									                            	<select id="application" onchange="document.getElementById('serv').style.display='block';" class="form-control" style="width:100%">
									                                	<option></option>
									                                </select>
								                                </div>
								                                <div id="serv" class="top-10 hiddenDiv">
								                                    <label>Application Service</label>
								                                	<div>
								                                		<select id="appservice" class="form-control appService"  style="width:100%">
								                                		<option></option>
								                                	</select>
								                                	</div>
								                                </div>    
								                            </div>    
						                            		<button type="button" onclick="addApp();getScore();initPopovers();" class="btn btn-info"><xsl:value-of select="eas:i18n('Add Application')"/></button>
						                       			</div>    
							                        	<div class="col-xs-6">   
							                           		<label><xsl:value-of select="eas:i18n('Technology Component')"/></label>
							                            	<div class="form-group">
							                            		<div>
									                             	<select id="technologyComponents" onchange="setProducts(this.value,this.value);document.getElementById('prod').style.display='block';" class="form-control" style="width:100%">
									                             		<option></option>
									                             	</select>
							                            		</div>
								                            	<div id="prod" class="top-10 hiddenDiv">
								                            		<label>Technology Product</label>
								                            		<div>
										                             	<select id="technologyProducts" class="technologyProducts form-control" style="width:100%">
										                                	<option></option>
										                            	</select>
								                            		</div>
									                            </div>
							                            	</div>    
							                            	<button type="button" onclick="addTech();getScore()" class="btn btn-info"><xsl:value-of select="eas:i18n('Add Product')"/></button>
														</div>								                       
						                      		</div>
												</div>
											</div>
					                        
					                    </div>
					                    <!--  may use depending on feedback        
					                         <div class="col-xs-12" id="apps" style="border: 1pt solid #d3d3d3;border-radius:3px;margin-top:15px;padding-bottom:15px;display:none">
					                              <h3>Application Details</h3>
					                        
					                         </div>    
					                    -->    
					            
					                    <div class="col-xs-6" id="adherence_summary">
					                        <div class="panel panel-default">
					                        	<div class="panel-heading">
													<h3 class="panel-title"><xsl:value-of select="eas:i18n('Adherence Summary')"/><button type="button" id="clear" class="btn btn-xs btn-info pull-right"><xsl:value-of select="eas:i18n('Clear All')"/></button></h3>
												</div>
					                        	<div class="panel-body">                       
						                            <table class="table">
						                                <thead>
						                                	<tr>
						                                		<th>&#160;</th>
						                                		<th  style="width:30%"><xsl:value-of select="eas:i18n('Application')"/></th>
						                                		<th  style="width:45%"><xsl:value-of select="eas:i18n('Service')"/></th>
						                                		<th class="statushead fade-in" style="color:#d3d3d3;text-align: center;width:20%"><xsl:value-of select="eas:i18n('Standard')"/></th>
						                                		<th></th>
						                                	</tr>
						                                </thead>
						                                <tbody id="appsToBeUsed"></tbody>
						                            </table>
					                    
					                        		<hr/>
						                            <table class="table">
						                                <thead>
						                                	<tr>
						                                		<th>&#160;</th>
						                                		<th style="width:30%"><xsl:value-of select="eas:i18n('Technology')"/></th>
						                                		<th style="width:45%"><xsl:value-of select="eas:i18n('Product')"/></th>
						                                		<th class="statushead fade-in" style="color:#d3d3d3;text-align: center;width:20%"><xsl:value-of select="eas:i18n('Status')"/></th>
						                                		<th></th>
						                                	</tr>
						                                </thead>
						                                <tbody id="productsToBeUsed"></tbody>
						                            </table>
					                           		<hr/>
					                 				<!--<div id="answerscore" style="font-size;19pt;border-radius: 20px;text-align:center;padding:3px;display: inline-block"></div> -->
													<span id="answer" class="label large uppercase"><xsl:value-of select="eas:i18n('Waiver Required')"/></span>
					                        	</div>
					                     	</div>
					                    </div>
					                </div>
								</div>
								<div id="summary" class="tab-pane fade in">
									<div class="row top-15">
										<div class="col-xs-12">
											<div class="panel panel-default">
												<div class="panel-heading">
													<h3 class="panel-title"><xsl:value-of select="eas:i18n('Design Authority Summary')"/></h3>
												</div>
												<div class="panel-body">
													<div id="summPage" class="top-10"/>
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
                <xsl:apply-templates select="$roles" mode="setStrategicDivs"/>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<xsl:call-template name="pageScripts" ></xsl:call-template>
			</body>	
			
<script id="goals-template" type="text/x-handlebars-template">
	<table class="table table-condensed">
		<thead>
			<tr>
				<th>&#160;</th>
				<th><xsl:value-of select="eas:i18n('Goal')"/></th>
				<th><xsl:value-of select="eas:i18n('Objectives')"/></th>
			</tr>
		</thead>
		<tbody>
			{{#each this}}
			<tr>
				<td width="32px">
					<input type="checkbox" class="goalTick">
						<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
					</input>
				</td>
				<td>{{this.name}}</td>
				<td>
					<ul>
					{{#each this.objectives}}
						<li>{{this.name}}</li>
					{{/each}}
					</ul>
				</td>
			</tr>
			{{/each}}
		</tbody>
	</table>
</script>
<script id="table-template" type="text/x-handlebars-template">
<Column ss:AutoFitWidth="0" ss:Width="120"/>
   <Column ss:AutoFitWidth="0" ss:Width="130"/>
   <Column ss:AutoFitWidth="0" ss:Width="11"/>
   <Column ss:AutoFitWidth="0" ss:Width="120"/>
   <Column ss:AutoFitWidth="0" ss:Width="144"/>
   <Row ss:Height="24">
    <Cell ss:StyleID="s65"><Data ss:Type="String"><xsl:value-of select="eas:i18n('Design Authority Summary')"/></Data></Cell>
   </Row>
   <Row ss:Height="21">
    <Cell ss:StyleID="s86"><Data ss:Type="String">Title</Data></Cell>
	   <Cell ss:StyleID="s77"><Data ss:Type="String">{{this.title}}</Data></Cell>
    <Cell ss:StyleID="s77"/>
    <Cell ss:StyleID="s86"><Data ss:Type="String">Owner</Data></Cell>
	 <Cell ss:StyleID="s104"><Data ss:Type="String">{{this.owner}}</Data></Cell>
    <Cell ss:StyleID="s104"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:StyleID="s63"/>
    <Cell ss:StyleID="s66"/>
    <Cell ss:StyleID="s66"/>
    <Cell ss:StyleID="s63"/>
    <Cell ss:StyleID="s68"/>
    <Cell ss:StyleID="s68"/>
   </Row>
   <Row ss:Height="21">
    <Cell ss:StyleID="s86"><Data ss:Type="String">Overview</Data></Cell>
	<Cell ss:StyleID="s77"><Data ss:Type="String">{{this.narrative}}</Data></Cell>
    <Cell ss:StyleID="s77"/>
    <Cell ss:StyleID="s86"><Data ss:Type="String">Cost</Data></Cell>
     <Cell ss:StyleID="s104"><Data ss:Type="String">{{this.cost}}</Data></Cell>
    <Cell ss:StyleID="s104"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:StyleID="s63"/>
    <Cell ss:StyleID="s72"/>
    <Cell ss:StyleID="s72"/>
    <Cell ss:StyleID="s63"/>
    <Cell ss:StyleID="s73"/>
    <Cell ss:StyleID="s73"/>
   </Row>
   <Row ss:Height="21">
    <Cell ss:StyleID="s93"><Data ss:Type="String">Goals</Data></Cell>
    <Cell ss:StyleID="s94"/>
    <Cell ss:StyleID="s77"/>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Principles</Data></Cell>
    <Cell ss:StyleID="s94"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="90">
    <Cell ss:MergeAcross="1" ss:StyleID="m105553429871332"><Data ss:Type="String">{{#each this.goals}}{{this.name}}&#10;{{/each}}</Data></Cell>
	   <Cell ss:Index="4" ss:MergeAcross="1" ss:StyleID="m105553429871352"><Data ss:Type="String"> {{#each this.principles}}{{this.name}} ({{this.state}})&#10;{{/each}}</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
   <Row ss:Height="21">
    <Cell ss:StyleID="s93"><Data ss:Type="String">Applications</Data></Cell>
    <Cell ss:StyleID="s94"/>
    <Cell ss:StyleID="s77"/>
    <Cell ss:StyleID="s93"><Data ss:Type="String">Technology</Data></Cell>
    <Cell ss:StyleID="s97"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="92">
	   <Cell ss:MergeAcross="1" ss:StyleID="m105553429871332"><Data ss:Type="String">{{#each this.applications}}{{this.app}} ({{this.service}}):{{this.status}}&#10;{{/each}}</Data></Cell>
	   <Cell ss:Index="4" ss:MergeAcross="1" ss:StyleID="m105553429871352"><Data ss:Type="String">{{#each this.technology}}{{this.comp}} ({{this.product}}):{{this.status}}&#10;{{/each}}</Data></Cell>
   </Row>
   <Row ss:Index="12" ss:Height="21">
    <Cell ss:StyleID="s93"><Data ss:Type="String">Outcome</Data></Cell>
    <Cell ss:StyleID="s94"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="35">
	   <Cell ss:MergeAcross="1" ss:StyleID="m105553429871352"><Data ss:Type="String">{{this.overall}}</Data></Cell>
   </Row>
   <Row ss:Index="16">
    <Cell><Data ss:Type="String">Waiver Granted</Data></Cell>
    <Cell><Data ss:Type="String">Y/N</Data></Cell>
   </Row>
   <Row ss:Index="18">
    <Cell><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row>
    <Cell><Data ss:Type="String">Signed</Data></Cell>
    <Cell ss:StyleID="s108"/>
   </Row>
   <Row>
    <Cell><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row>
    <Cell><Data ss:Type="String">Date</Data></Cell>
   </Row>			
			</script>
			
			
<script id="summary-template" type="text/x-handlebars-template">
	<div id="summary-layout">
		<div class="row bottom-30">
			<div class="col-md-4">
				<label><xsl:value-of select="eas:i18n('Title')"/></label>
				<div>
					<input readonly="readonly" type="text" class="form-control" placeholder="None Defined" >
						<xsl:attribute name="value">{{this.title}}</xsl:attribute>
					</input>
				</div>
			</div>
			<div class="col-md-4">
				<label><xsl:value-of select="eas:i18n('Owner')"/></label>
				<div>
					<input readonly="readonly" type="text" class="form-control" placeholder="None Defined" >
						<xsl:attribute name="value">{{this.owner}}</xsl:attribute>
					</input>
				</div>
			</div>
			<div class="col-md-4">
				<label><xsl:value-of select="eas:i18n('Date')"/></label>
				<div id="printDate"></div>
			</div>
		</div>
		<div class="row bottom-30">
			<div class="col-md-8">
				<label><xsl:value-of select="eas:i18n('Overview')"/></label>
				<div>
					<input readonly="readonly" type="text" class="form-control" placeholder="None Defined" >
						<xsl:attribute name="value">{{this.narrative}}</xsl:attribute>
					</input>
				</div>
			</div>
			<div class="col-md-4">
				<label><xsl:value-of select="eas:i18n('Cost')"/></label>
				<div>
					<input readonly="readonly" type="text" class="form-control" placeholder="None Defined" >
						<xsl:attribute name="value">{{this.cost}}</xsl:attribute>
					</input>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12">
				<hr/>
			</div>
			<div class="col-xs-12">
				<label><xsl:value-of select="eas:i18n('Goals and Principles')"/></label>
				<table class="table table-condensed top-10">
					<thead>
						<tr>
							<th><xsl:value-of select="eas:i18n('Goals')"/></th>
							<th><xsl:value-of select="eas:i18n('Principles')"/></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								{{#if this.goals}}
									<ul class="fa-ul">
										{{#each this.goals}}
										<li><i class="fa fa-li fa-circle-o" style="color:#62b7d6"></i>{{this.name}}</li>
										{{/each}}
									</ul>
								{{else}}
								<div><em>None Defined</em></div>
								{{/if}}
							</td>
							<td>
								{{#if this.principles}}
									<ul class="fa-ul">
										{{#each this.principles}}
											{{#ifEquals this.state 'No'}}
												<li><i class="fa fa-li fa-exclamation-circle text-danger"></i>{{this.name}}</li>
											{{/ifEquals}}
											{{#ifEquals this.state 'Yes'}}
												<li><i class="fa fa-li fa-check-square-o text-success"></i>{{this.name}}</li>
											{{/ifEquals}}
										{{/each}}
									</ul>
										{{else}}
									<div><em>None Defined</em></div>
								{{/if}}
							</td>
						</tr>
					</tbody>
				</table>			
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12">
				<hr/>
			</div>
			<div class="col-md-6">
				<label><xsl:value-of select="eas:i18n('Applications')"/></label>
				<div>
					{{#if this.applications}}
						<ul class="fa-ul">
							{{#each this.applications}}
								<li>
									<i class="fa fa-li fa-circle">
										<xsl:attribute name="style">color:{{this.colour}}</xsl:attribute>
									</i>
									<span>{{this.app}} ({{this.service}})</span>
									<span class="label label-sm left-5"><xsl:attribute name="style">background-color: {{#if this.colour}}{{this.colour}}{{else}}#d3d3d3{{/if}}</xsl:attribute>{{this.status}}</span>
								</li>
							{{/each}}
						</ul>
					{{else}}
						<div><em>None Defined</em></div>
					{{/if}}
				</div>
			</div>
			<div class="col-md-6">
				<label><xsl:value-of select="eas:i18n('Technology')"/></label>
				<div>
					{{#if this.technology}}
						<ul class="fa-ul">
						{{#each this.technology}}
							<li>
								<i class="fa fa-li fa-circle">
									<xsl:attribute name="style">color:{{this.colour}}</xsl:attribute>
								</i>
								<span>{{this.comp}} ({{this.product}})</span>
								<span class="label label-sm left-5"><xsl:attribute name="style">background-color: {{#if this.colour}}{{this.colour}}{{else}}#d3d3d3{{/if}}</xsl:attribute>{{this.status}}</span>
							</li>					
						{{/each}}
						</ul>
						{{else}}
							<div><em>None Defined</em></div>
					{{/if}}
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12">
				<hr/>
			</div>
			<div class="col-xs-12 bottom-15">
				<label><xsl:value-of select="eas:i18n('Overall Status')"/></label>
				<div class="label large uppercase">
					<xsl:attribute name="style">background-color: {{this.colour}}</xsl:attribute>
					{{this.overall}}
				</div>
			<!--	<xsl:if test="$isEIPMode = 'true'"> -->
					<xsl:text> </xsl:text>
					<button class="btn btn-sm btn-success pull-right left-20" id="setDecision"><xsl:value-of select="eas:i18n('Submit Decision')"/>
					</button> <xsl:text> </xsl:text>
			<!--	</xsl:if> -->
				<button class="btn btn-sm btn-info pull-right" id="genExcel"><i class="fa fa-file-excel-o right-5"/><xsl:value-of select="eas:i18n('Download Excel Summary')"/></button>
			</div>
		</div>
	</div>
	
<!--<div class="col-xs-9 top-30">
		<table>
		<tr><td width="10%" class="tdcoltitletop">Title</td><td width="40%" class="tdcol">{{this.title}}</td><td width="10%" class="tdcoltitletop">Owner</td><td width="40%" class="tdcol">{{this.owner}}</td></tr>	
		<tr><td width="10%" class="tdcoltitletop">Overview</td><td width="40%" class="tdcol">{{this.narrative}}</td><td width="10%" class="tdcoltitletop">Cost</td><td width="40%" class="tdcol">{{this.cost}}</td></tr>	
	</table>
	<table>
		<tr><td colspan="2" class="tdcoltitle">Goals</td><td colspan="2" class="tdcoltitle">Principles</td></tr>	
		<tr><td colspan="2" class="tdcol">
			{{#if this.goals}}
			{{#each this.goals}}
			<i class="fa fa-circle-o" style="color:#62b7d6"></i> {{this.name}}<br/>
			{{/each}}
			{{else}}
			None Defined
			{{/if}}
			</td>
			<td colspan="2" class="tdcol">
			{{#if this.principles}}
			{{#each this.principles}}
			{{#ifEquals this.state 'No'}}<i class="fa fa-exclamation-circle" style="color:red"></i>{{/ifEquals}}{{#ifEquals this.state 'Yes'}}<i class="fa fa-check-square-o" style="color:green"></i>{{/ifEquals}} {{this.name}}<br/>
			{{/each}}
				{{else}}
			None Defined
			{{/if}}
			</td>
		</tr>	
<!-\-		<tr><td colspan="4" class="tdcoltitle">Principles</td></tr>
		<tr><td colspan="4" class="tdcol">
				{{#if this.principles}}
			{{#each this.principles}}
			{{this.name}}:{{this.state}}<br/>
			{{/each}}
				{{else}}
			None Defined
			{{/if}}
			</td></tr>	
	-\->	<tr><td colspan="4" class="tdcoltitle">Applications</td></tr>	
		<tr><td colspan="4" class="tdcol">
			{{#if this.applications}}
			{{#each this.applications}}
			<i><xsl:attribute name="class">fa fa-circle</xsl:attribute><xsl:attribute name="style">color:{{this.colour}}</xsl:attribute></i> <xsl:text> </xsl:text><button class="btn btn-info btn-sm" style="margin-top:4px">{{this.app}} ({{this.service}})</button><button class="btn btn-sm"><xsl:attribute name="style">margin-top:4px;border-bottom:2pt solid {{this.colour}}</xsl:attribute>{{this.status}}</button><br/>
			{{/each}}
			{{else}}
			None Defined
			{{/if}}
			</td></tr>	
		<tr><td colspan="4" class="tdcoltitle">Technology</td></tr>	
		<tr><td colspan="4" class="tdcol">
			{{#if this.technology}}
			{{#each this.technology}}
			<i><xsl:attribute name="class">fa fa-circle</xsl:attribute><xsl:attribute name="style">color:{{this.colour}}</xsl:attribute></i><xsl:text> </xsl:text><button class="btn btn-info btn-sm" style="margin-top:4px">{{this.comp}} ({{this.product}})</button> <button class="btn btn-sm"><xsl:attribute name="style">margin-top:4px;border-bottom:2pt solid {{this.colour}}</xsl:attribute>{{this.status}}</button><br/>
			{{/each}}
			{{else}}
			None Defined
			{{/if}}
			</td></tr>	
		<tr><td colspan="4" class="tdcol" style="text-align:center"><br/><button class="btn"><xsl:attribute name="style">background-color: {{this.colour}}</xsl:attribute>{{this.overall}}</button> <xsl:text> </xsl:text><button class="btn btn-info" id="genExcel">Excel</button></td></tr>		
		</table>
	</div>
	<div class="col-xs-3">
		Date:<span id="printDate"></span>	
	</div>-->
</script>			
		</html>
	</xsl:template>
	
	<xsl:template name="pageScripts">
		<script type="text/javascript">  
			
	         function reSort(){
			
			
	                var mylist = $('#sortable');
	
	                var listitems = mylist.children('div').get();
	
	                listitems.sort(function(a, b) {
	                    var compA = parseFloat($(a).attr('id'));
	                    var compB = parseFloat($(b).attr('id'));
	                    return (compA &gt; compB) ? -1 : (compA &lt; compB) ? 1 : 0;
	                });        
	
	                $.each(listitems, function(idx, itm) {  
	        
	                    mylist.append(itm);     
	              
	                });
	        
	            };</script>

<script>

	var now=new Date();
	//console.log(today)
	var day = ("0" + now.getDate()).slice(-2);
var month = ("0" + (now.getMonth() + 1)).slice(-2);

var today = now.getFullYear()+"-"+(month)+"-"+(day) ;


	var goals=[<xsl:apply-templates select="$goals" mode="goals"/>];
	console.log(goals)
		
	Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
	//console.log(arg1+":"+arg2)
    return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
});

	var summaryTech=[];
	var summaryApp=[];
	var principles=[];
	var goalsList=[];			
		  var offStrategy=[];		
	      var styles=[<xsl:apply-templates select="$standardStrengthStyle" mode="getStyles"/>];  
		var principlesList=[<xsl:apply-templates select="$allPrinciples" mode="objectives"/>]		
	            var score = 0;
	            var scoreval=0;
	            var noval=0;
	            var noway = 0;
	            var id=0;
	            var item_counter=0;
	            
	        function addTech(){
	            var comp= document.getElementById('technologyComponents').value;
	            var product=document.getElementById('technologyProducts').value;
	            var status= document.getElementById('technologyProducts').selectedIndex;
	             
	            var list= techJSON.filter(function (el) {
	                            return el.component == comp
	                                            });
				
	            var thisstatus = list[status].standard;
				var thistechvalue = list[status].value;
	            var statusClass = list[status].classColour;
				
				if(thistechvalue &gt;3){
					offStrategy.push(list[status].roleid);
					};
				
				var techstatusClassFilter=styles.filter(function(d){
						return d.id == list[status].colour;
				});
				  item_counter=item_counter+1;
	   			if(techstatusClassFilter.length==0){
					if(thisstatus.length ==0){thisstatus='Off Strategy'
						var findstatusClass=styles.filter(function(d){return d.name=='View Styling for Off Strategy'});
						statusClass='bg-darkred-80';
						thistechvalue=10;
						sessionStorage.setItem(list[status].roleid, 'True');
						offStrategy.push(list[status].roleid);
                        }
						techstatusClassFilter.push({"textColour":"#000","color":"#d3d3d3","thisstatus":thisstatus});
					}
			if(thisstatus=='Off Strategy'){
				techstatusClassFilter[0].colour='#d03838';
				techstatusClassFilter[0].textColour='#ffffff';
				};
				daAPIList.push({"id":list[status].roleid, "className":"Technology_Provider_Role"}); 
			summaryTech.push({"comp":comp,"product":product,"status":thisstatus,"id":list[status].roleid, "class":statusClass,"colour":techstatusClassFilter[0].colour,"textcolour":techstatusClassFilter[0].textColour})
	
				console.log(summaryTech)
	            var productRowHTML = '<tr id="' + id + '">' +
            			'<td><i class='fa fa-server'></i></td>' +
            			'<td>' + comp + '</td>' +
            			'<td>' + product + '</td>' +
            			'<td>' +
            				'<button class="btn btn-xs techProdStatus ' +statusClass + '" onclick="popup(&quot;' + comp + '&quot;)" style="background-color:'+techstatusClassFilter[0].colour+';color:'+techstatusClassFilter[0].textColour+'" easscore="'+thistechvalue+'">' + 
            					thisstatus + '<i class="fa fa-info-circle left-5"/>' + 
            				'</button>' +
            			'</td>' +
            			'<td  style='cursor:pointer'>' +
            				'<i class="fa fa-times removebutton" easid="'+list[status].roleid+'"></i></td>' +
            		'</tr>';
	            
            	$("#productsToBeUsed").append(productRowHTML);
										
				
				

	            };
	      var daAPIList=[];      
	            function addApp(){
	              var app= document.getElementById('application').value;
	              var service=document.getElementById('appservice').value;
	              var appstatus= document.getElementById('appservice').selectedIndex;
	             
	            var applist= appJSON.filter(function (el) {
	                            return el.application == app
	                                            });
	
	            var thisappstatus = applist[appstatus].standard;
				var thisvalue = applist[appstatus].value;
	            var statusClass;
	            var thisscore;
				var statusClassFilter=styles.filter(function(d){
						return d.id == applist[appstatus].colour;
				});
 
				if(statusClassFilter.length==0){
					if(thisappstatus.length ==0){thisappstatus='Off Strategy'
						var findstatusClass=styles.filter(function(d){return d.name=='View Styling for Off Strategy'});
						statusClass='bg-darkred-80';
						thisvalue=10;

                        }
						statusClassFilter.push({"textColour":"#000","color":"#d3d3d3","thisstatus":thisappstatus});
					}
				
		      	if(thisvalue &gt;4){
					offStrategy.push(applist[appstatus].roleid);
					};
				
 				if(thisappstatus=='Off Strategy'){
					statusClassFilter[0].colour='#d03838';
					statusClassFilter[0].textColour='#ffffff';
				};

				daAPIList.push({"id":applist[appstatus].roleid, "className":"Application_Provider_Role"}); 
	          	summaryApp.push({"app":app,"service":service,"status":thisappstatus,"id":applist[appstatus].roleid,"class":statusClass,"colour":statusClassFilter[0].colour,"textcolour":statusClassFilter[0].textColour})  
	            
	            item_counter=item_counter+1;
	            
	            var appRowHTML = '<tr id="' + item_counter + '">' +
            			'<td>' +
            				'<i class='fa fa-desktop' />' +
            			'</td>' +
            			'<td>'+ app +
            				'<i class="fa fa-info-circle left-5" data-toggle="popover"/>' +
            				'<div class="popover" id="app' + item_counter + '">' +
            					'<strong>'+ applist[appstatus].application + '</strong>' +
            					'<br/>' +
            					'<div class="small">' +
	            					'<strong>Status</strong>:' + thisappstatus + 
	            					'<br/>' +
	            					'<strong>Interfaces In</strong>: '+ applist[appstatus].interfacesin + 
	            					'<br/>' +
	            					'<strong>Interfaces Out</strong>: '+ applist[appstatus].interfacesout + 
	            				'</div>' +
            				'</div>' +
            			'</td>' +
            			'<td>' + service + '</td>' +
            			'<td>' +
            				'<button class="btn btn-xs ' +statusClass + '" style="background-color:'+statusClassFilter[0].colour+';color:'+statusClassFilter[0].textColour+'">' + thisappstatus + '</button>' +
            			'</td>' +
            			'<td style="cursor:pointer"> 
            				 <i class="fa fa-times removebutton" easid="'+applist[appstatus].roleid+'"></i> 
            			 </td>' +
            		'</tr>';
	            

            	$("#appsToBeUsed").append(appRowHTML);
	                        
	            };
	                                       
	            function showDiv(appdiv){
	                document.getElementById(appdiv).style.display='block';
	            }
	            
	            function hideDiv(appdiv){
	                document.getElementById(appdiv).style.display='none';
	            }
	            
	             $(document).on('click', 'i.removebutton', function () {
					 removeItem($(this).attr('easid'));


					 getScore();
	                 $(this).closest('tr').remove();
				item_counter=item_counter-1;
	                 return false;
	             });
	             
function removeItem(thisid){
				console.log('remove'+thisid)
				const index = offStrategy.indexOf(thisid);
					if (index > -1) {
					  offStrategy.splice(index, 1);
					};
					console.log(offStrategy)
			
					daAPIList.indexOf(thisid);
					if (index > -1) {
						daAPIList.splice(index, 1);
					};
					console.log(daAPIList)


				summaryTech=summaryTech.filter(function(d){
						//console.log(d.id+":"+thisid)
					return d.id!==thisid;	
				 });
			  	summaryApp=summaryApp.filter(function(d){
						//console.log(d.id+":"+thisid)
					return d.id!==thisid;	
				 });
		//console.log(summaryApp)
			};
             	
function addItem(thisid){
				offStrategy.push(thisid);
				};				
				function initPopovers(){
					$('.fa-info-circle').click(function(evt) {
						$('[role="tooltip"]').remove();
						evt.stopPropagation();
					});
					$('.fa-info-circle').popover({
						container: 'body',
						html: true,
						trigger: 'click',
						placement: 'auto',
						content: function(){
							return $(this).next().html();
						}
					});
				}
	            
	
	            function getValueByKey(key, data,status) {
	                        var i, len = data.length;
	
	                        for (i = 0; i &lt; len; i++) {
	                            if (data[i].product = key) {
	                                var ind = data.indexOf(data[i].product);
	                                 return data[i].status;
	                            }
	                        }
	
	                        return -1;
	                    };
	        
	
	               var techJSON=[<xsl:apply-templates select="$productRoles" mode="getOptions"/>];
	                var options = d3.nest()
	                .key(function(d) { return d.component; })
	                .entries(techJSON);
	                               
	                var compbox = document.getElementById("technologyComponents");
	                    options.forEach(function(item){
	                        var opt = document.createElement("option");
	                        opt.value = item.key;
	                        opt.textContent = item.key;
	                        compbox.appendChild(opt);
	                    });
	                
	                    function SortList(listname) { 
	                        var $r = $(listname + " option"); 
	                        $r.sort(function(a, b) { 
	                            return (a.value &lt; b.value) ? -1 : (a.value &gt; b.value) ? 1 : 0;
	                        // if you do not have value attribute for option use the text value. Replace the above line of code with the one below.
	                        //return (a.value &lt; b.value) ? -1 : (a.value &gt; b.value) ? 1 : 0;
	                        }); 
	                        $($r).remove(); 
	                        $(listname).append($($r)); 
	                    } ;
	                
	              var appJSON=[<xsl:apply-templates select="$approles" mode="getAppOptions"/>]; 
	                var appoptions = d3.nest()
	                .key(function(d) { return d.application; })
	                .entries(appJSON);
	                                             
	                 var appcompbox = document.getElementById("application");
	                    appoptions.forEach(function(item){
	                        var opt = document.createElement("option");
	                        opt.value = item.key;
	                        opt.textContent = item.key;
	                        appcompbox.appendChild(opt);
	                    });
	                
	                
	            function setProducts(comp){
	                    var techbox = document.getElementById("technologyProducts");
	                
	                var list= techJSON.filter(function (el) {
	                            return el.component == comp
	                                            });
	
	                    $('#technologyProducts').empty()
						let str='';
						list.forEach(function(item){
						str=str+'<option value="'+item.product+'" id="'+item.status+'" title="'+item.roleid+'" >'+item.product+'</option>';
	
							});
							console.log(str)
							$('#technologyProducts').append(str);   
						};
						
					 	
	              function setService(app){
					$(".appService").empty();
		 
 
	                    var appbox = document.getElementById("appservice");
						console.log(app);     
	                let servicelist;    
					let getSelect = new Promise(function(myResolve, myReject) {
					// "Producing Code" (May take some time)
					servicelist= appJSON.filter(function (el) {
	                            return el.application == app
	                                            });
	
						console.log(servicelist);
					myResolve(); // when successful
					myReject();  // when error
					});

					// "Consuming Code" (Must wait for a fulfilled Promise)
					getSelect.then(
					function(value) { 
						let str='';
						servicelist.forEach(function(item){
						str=str+'<option value="'+item.service+'" id="'+item.status+'" >'+item.service+'</option>';
	
							});
							console.log(str)
							$('.appService').append(str);   
						},
					function(error) { /* code if some error */ }
					);        
												

	                
	                    };                              
	                SortList('#technologyComponents');
	                $("#technologyComponents").val($("#technologyComponents option:first").val());
	                SortList('#application');
	                $("#application").val($("#application option:first").val());     
	
	                
	                function getScore(){
	                   	var state;
	                    var colour;
						console.log(offStrategy)
	                    if(offStrategy.length &gt; 0){
	                        state = 'Waiver Required';colour='#ffc62c';
	                        }else{
							state = 'Permitted';colour='#24b724';
						}
	                    
	                    document.getElementById('answer').textContent = state;
	                    if(item_counter&gt;0){$("#answer").show();}else{$("#answer").hide()};
	                    $("#answer").css("background-color",colour);
	                    $("#answerscore").css("background-color","#ffffff");
						
	                };
	            
	              $("#clear").click(function(){
	                    $("#appsToBeUsed tr").remove();
	                    $("#productsToBeUsed tr").remove();
	                    $("input:checked").removeAttr("checked");
	                    $("input").filter('[value=na]').prop('checked', true);
	                    $(".principleTable").css('background-color','#fff');
	                    document.getElementById('answer').textContent = '';
	                    $("#answer").css("font-size", "0pt");
	                    $("#answer").css("background-color","#ffffff");
	                    $("#answer").css("box-shadow","none");
	                    $("#answerscore").css("font-size", "0pt");
	                    $("#answerscore").css("background-color","#ffffff");
	                    offStrategy=[];	
	                    item_counter = 0;
	                    });
	
	            function popup(comp){
	                  comp = comp.replace(/ /g,'');
	                  comp = comp.replace('.','');
	                  comp = comp.replace('#','');   
	                  comp = comp.replace('&amp;','');
	                  $("#"+comp).css("display", "block");
	                  $("#"+comp).css("position", "absolute"); 
	                  $("#"+comp).css("top", "30%"); 
	                  $("#"+comp).css("left", "70%"); 
	                                        }; 
	                  
	            function closepop(comp){
	                    comp = comp.replace(/ /g,'');
	                    comp = comp.replace('.','');
	                    comp = comp.replace('#','');   
	                    comp = comp.replace('&amp;','');
	                    $("#"+comp).css("display", "none");
	                 
	                        };
	                
	            $("#createDoc").click(function(){
	                  var appsdata = [];
	                  var techdata = [];
	                    $('#appsToBeUsed').find('tr').each(function (rowIndex, r) {
	                        var cols = [];
	                        $(this).find('td').each(function (colIndex, c) {
	                            cols.push(c.textContent);
	                        });
	                        appsdata.push(cols);
	                    });
	             $('#productsToBeUsed').find('tr').each(function (rowIndex, r) {
	                        var cols = [];
	                        $(this).find('td').each(function (colIndex, c) {
	                            cols.push(c.textContent);
	                        });
	                        techdata.push(cols);
	                    });
	            
	            var inputValues = $('.principle').map(function() {
	                    if ($(this).is(':checked')){
	                        radioValue=$(this).val();
	                        parentValue=$(this).parent().attr('name');                
	                        return parentValue + '|' +radioValue;      
	                        };        
	                    
	                }).toArray();
	              
	            window.open('report?XML=reportXML.xml&amp;PMA='+inputValues+'&amp;PMA2='+appsdata+'&amp;PMA3='+techdata+'&amp;XSL=application/da_excel_generator.xsl');
	     
	    
	                    return appsdata; return techdata;
	          });
	            var principleVals = [];
	            function scorerNo(id){
	              principleVals.push(id);
	         
	            }
	            
	           
	            jQuery(window).bind(
	                "beforeunload", 
	                 function() { 
	                    sessionStorage.clear();
	                }
	            );
	
	
	
	$(document).ready(function() {                    
		var goalsPanel   = $("#goals-template").html();
		goalsTemplate = Handlebars.compile(goalsPanel);
		var summaryPanel   = $("#summary-template").html();
		summaryTemplate = Handlebars.compile(summaryPanel);
		var excelPanel   = $("#table-template").html();
		excelTemplate = Handlebars.compile(excelPanel);
		$('#application').select2();
		$('#technologyComponents').select2();
	//	$('#appservice').select2();
	//	$('#technologyProducts').select2();
		//console.log(today)
$('#application').on('change',function(){
	console.log($(this).val());
setService($(this).val());

})
	
        $('.fa-info-circle').click(function() {
            $('[role="tooltip"]').remove();
        });
        $('.fa-info-circle').popover({
            container: 'body',
            html: true,
            trigger: 'click',
            content: function(){
                return $(this).next().html();
            }
        });
	
	
	$('#gls').append(goalsTemplate(goals));
	
	//console.log('principlesList');//console.log(principlesList);
	
	$('.principle').click(function(){
	//console.log('principlesList');//console.log(principlesList);
	var selectedItem= $(this).attr('easid');

	if($(this).val()=='yes'){
	var thisPrinciple = principlesList.filter(function(d){
			return d.id==selectedItem;
		})
	thisPrinciple[0]['state']='Yes';
	
	principles.push(thisPrinciple[0])
	}
	else if($(this).val()=='no'){
	var thisPrinciple = principlesList.filter(function(d){
			return d.id==selectedItem;
		})
	thisPrinciple[0]['state']='No';
	principles.push(thisPrinciple[0])
	}
	else
	{
	principles = principles.filter(function(d){
			return d.id!==selectedItem;
		})
	}
 
    principles = principles.filter((arr, index, self) =>
    index === self.findIndex((t) => (t.id === arr.id)))

	});
	
	$('.goalTick').on('change',function(){
	var thisgl =$(this).attr('easid');
	if($(this).is(':checked')){
		var thisgoal=goals.filter(function(d){
		//console.log(d.id+":"+thisgl);
			return d.id == thisgl;
		});
 
		  goalsList.push(thisgoal[0])
		  daAPIList.push({"id":thisgoal[0].id,"className":thisgoal[0].type})
      }else
	{   goalsList=goalsList.filter(function(d){
			return d.id !== thisgl;
		})
		daAPIList=daAPIList.filter(function(d){
			return d.id !== thisgl;
		})
		console.log('gl')
		console.log(daAPIList)
	}
 
	});

	 $('.summary').click(function(d){
		var page={};
		page['owner']=$('#owner').val();
		page['title']=$('#title').val();
		page['narrative']=$('#narrative').val();
		page['cost']=$('#cost').val();
		page['goals']=goalsList;
		page['principles']=principles;
		page['applications']=summaryApp;
		page['technology']=summaryTech;
		page['overall']= $('#answer').text();
	 	state =$('#answer').text();
		if(state=='Waiver Required'){page['colour']='#ffc62c';                   }
		else{
		page['colour']='#24b724';}
	 
	 console.log(page);
	$('#summPage').empty();
	$('#summPage').append(summaryTemplate(page));
	$('#printDate').text(today);

 
		var worksheetHead='&lt;Worksheet ss:Name="All">&lt;Names>&lt;NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=All!R2C1:R2C22" ss:Hidden="1"/>&lt;NamedRange ss:Name="Table0_1" ss:RefersTo="=All!R2C1:R2C22"/>&lt;/Names>&lt;Table ss:ExpandedColumnCount="22" x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="53" ss:DefaultRowHeight="15">';				
					
	
		var xmlhead, xmlfoot;
		getXML('application/design_authority_head.xml').then(function(response){
		xmlhead=response;	

		}).then(function(response){
		getXML('application/design_authority_foot.xml').then(function(response){
		xmlfoot=response;	
		ExcelArray=[];
		ExcelString=xmlhead+worksheetHead+excelTemplate(page)+'&lt;/Table>'+xmlfoot;
		ExcelArray.push(ExcelString)
	 
		//console.log(ExcelArray[0])	
		});

 	$('#genExcel').click(function(){
	  
	var blob = new Blob([ExcelArray[0]], {type: "text/xml"});
	saveAs(blob, "da_export.xml");
	  });
		});
	});

	$(document).on('click', '#setDecision',function(){
							console.log('setdec')
				let projName=$('#title').val()
				let statusName=$('#answer').text()	
				let narrative=$('#narrative').text()	
				let decdate=moment().format('YYYY-MM-DD')	
				let idStr= projName.substring(0,3)+'-'+decdate.substring(2,4)+	decdate.substring(5,8)+decdate.substring(8,11)
				
				console.log(daAPIList)
				
				let decision = {"name":projName,
								"className": "Enterprise_Decision",
								"decision_result": {
									"className": "Decision_Result",
									"name": statusName},
								"description":narrative,	
								"decision_date_iso_8601":decdate,
								"governance_reference":idStr.replace(/\s/g, ''),
								"decision_elements":daAPIList
								};
				 
				console.log(decision);
				$('#setDecision').text('Submitting...');
				$('#setDecision').removeClass('btn-success');
				$('#setDecision').addClass('btn-primary');
				$('#setDecision').prop('disabled', true);
			 //essPromise_createAPIElement('/essential-utility/v2',decision,'v3/instances','Decision')
			 essPromise_createAPIElement('/essential-utility/v3',decision,'instances','Decision')
			 .then(function(response){
				 $('#setDecision').text('Submit Decision');
				 $('#setDecision').removeClass('btn-primary');
				$('#setDecision').addClass('btn-success');
				$('#setDecision').prop('disabled', false);
				 console.log('Decision Created with elements');
				 console.log(response);
			 });
			 //essPromise_createAPIElement(' /essential-utility/v2/instance',decision,'/v3/instances','Decision')
			
				});

 
                    });	
	
	var getXML = function promise_getExcelXML(excelXML_URL) {
    return new Promise(
    function (resolve, reject) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 &amp;&amp; this.status == 200) {
                //console.log(prefixString);
                resolve(this.responseText);
            }
        };
        xmlhttp.onerror = function () {
            reject(false);
        };
        xmlhttp.open("GET", excelXML_URL, true);
        xmlhttp.send();
    });
};	
	            </script>
	</xsl:template>
	<xsl:template match="node()" mode="goals">
		<xsl:variable name="thisObj" select="$objectives[name=current()/own_slot_value[slot_reference = 'goal_supported_by_objectives']/value]"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>",
	"type":"<xsl:value-of select="current()/type"/>",	   
	"objectives":[<xsl:apply-templates select="$thisObj" mode="objectives"/>]	}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="objectives">
	 
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
    <xsl:template match="node()" mode="getOptions">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thislifecycle" select="current()/own_slot_value[slot_reference='strategic_lifecycle_status']/value"/>
        <xsl:variable name="thisproduct" select="$products[own_slot_value[slot_reference='implements_technology_components']/value=$this/name]"/>
        <xsl:variable name="thisstatus" select="$lifecycleStatus[name=$thislifecycle]/own_slot_value[slot_reference='enumeration_value']/value"/>
		<xsl:variable name="thisStandard" select="$techStandard[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=$this/name]"/> 
		<xsl:variable name="thisStandardStrength" select="$standardStrength[name=$thisStandard/own_slot_value[slot_reference='sm_standard_strength']/value]"/>  
        <xsl:if test="$thisproduct">
     {"product":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$thisproduct"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>", "component":"<xsl:value-of select="$roles[own_slot_value[slot_reference='realised_by_technology_products']/value=$this/name]/own_slot_value[slot_reference='name']/value"/>", "roleid":"<xsl:value-of select="$this/name"/>", "status":"<xsl:value-of select="$thisstatus"/><xsl:if test="not($thisstatus)">Not Known</xsl:if>","standard":"<xsl:value-of select="$thisStandardStrength/own_slot_value[slot_reference='name']/value"></xsl:value-of>","colour":"<xsl:value-of select="$thisStandardStrength/own_slot_value[slot_reference='element_styling_classes']/value"/>",
	 "value":"<xsl:value-of select="$thisStandardStrength/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>"},
          </xsl:if>
    </xsl:template>
    
    <xsl:template match="node()" mode="getAppOptions">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thislifecycle" select="current()/own_slot_value[slot_reference='apr_lifecycle_status']/value"/>
        <xsl:variable name="thisstatus" select="$lifecycleStatus[name=$thislifecycle]/own_slot_value[slot_reference='enumeration_value']/value"/>
        <xsl:variable name="thisapp" select="$apps[own_slot_value[slot_reference='provides_application_services']/value=$this/name]"/>
        <xsl:variable name="thisappnode" select="$apps[own_slot_value[slot_reference='provides_application_services']/value=$this/name]"/>
        <xsl:variable name="thisservice" select="$appservices[own_slot_value[slot_reference='provided_by_application_provider_roles']/value=$this/name]/own_slot_value[slot_reference='name']/value"/>   
		<xsl:variable name="thisStandard" select="$appStandard[own_slot_value[slot_reference='aps_standard_app_provider_role']/value=$this/name]"/> 
		<xsl:variable name="thisStandardStrength" select="$standardStrength[name=$thisStandard/own_slot_value[slot_reference='sm_standard_strength']/value]"/>  
        <xsl:if test="$thisapp">	
			
			
     {"application":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$thisapp"></xsl:with-param>
					<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
				</xsl:call-template>", "roleid":"<xsl:value-of select="current()/name"/>", "service":"<xsl:value-of select="$thisservice"/><xsl:if test="not($thisservice)">Unnamed Service</xsl:if>", <xsl:apply-templates select="$thisappnode" mode="interfaces"/>, "status":"<xsl:value-of select="$thisstatus"/><xsl:if test="not($thisstatus)">Not Known</xsl:if>","standard":"<xsl:value-of select="$thisStandardStrength/own_slot_value[slot_reference='name']/value"></xsl:value-of>","colour":"<xsl:value-of select="$thisStandardStrength/own_slot_value[slot_reference='element_styling_classes']/value"/>",
	 "value":"<xsl:value-of select="$thisStandardStrength/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>"},
          </xsl:if>
    </xsl:template>
    
    <xsl:template match="node()" mode="interfaces">
     <xsl:variable name="this" select="current()"/> 
     <xsl:variable name="subApps" select="$apps[name = $this/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
	<xsl:variable name="subSubApps" select="$apps[name = $subApps/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
	<xsl:variable name="currentApp" select="$this union $subApps union $subSubApps"/>
     <xsl:variable name="thisUsage" select="$appUsage[own_slot_value[slot_reference='static_usage_of_app_provider']/value=$currentApp/name]"></xsl:variable>
     <!--
    <xsl:variable name="thisUsage" select="$appUsage[own_slot_value[slot_reference='static_usage_of_app_provider']/value=$this/name]"></xsl:variable>

<xsl:variable name="thisarch" select="$appUsageArch[static_app_provider_architecture_elements]"></xsl:variable>  not sure i need -->
     <xsl:variable name="thisrelFrom" select="$appInterface[own_slot_value[slot_reference=':FROM']/value=$thisUsage/name]"></xsl:variable> 
      <xsl:variable name="thisrelTo" select="$appInterface[own_slot_value[slot_reference=':TO']/value=$thisUsage/name]"></xsl:variable>   
        "interfacesin":"<xsl:value-of select="count($thisrelFrom)"/>","interfacesout":"<xsl:value-of select="count($thisrelTo)"/>"        
    </xsl:template>
    
<xsl:template match="node()" mode="setStrategicDivs">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thiscomp" select="$this/own_slot_value[slot_reference='name']/value"/>
        <xsl:variable name="thisrole" select="$productRoles[own_slot_value[slot_reference='implementing_technology_component']/value=$this/name]"/>
        
        <div id="{translate(translate(translate(translate($thiscomp,' ',''),'.',''),'&amp;',''),'#','')}" class="productPopup">
            <h4><strong>Strategic Products</strong></h4>
        	<ul class="fa-ul">
            	<xsl:apply-templates select="$thisrole" mode="stratProducts"/>
        	</ul>
         <div style="width:100%;text-align:right;cursor:pointer" onClick="document.getElementById('{translate(translate(translate(translate($thiscomp,' ',''),'.',''),'&amp;',''),'#','')}').style.display='none'">Close</div>
    
    </div>
</xsl:template>    
 
    
<xsl:template match="node()" mode="stratProducts">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thislifecycle" select="$this/own_slot_value[slot_reference='strategic_lifecycle_status']/value"/>
        <xsl:variable name="thisstatus" select="$lifecycleStatus[name=$thislifecycle]/own_slot_value[slot_reference='enumeration_value']/value"/>
        <xsl:variable name="thisprods" select="$products[own_slot_value[slot_reference='implements_technology_components']/value=$this/name]"/>
	    <xsl:if test="$thisstatus='Production'">
	        <li>
				<i class="fa fa-li fa-caret-right"></i>
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$thisprods"></xsl:with-param>
					<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
				</xsl:call-template>
	    		 
	        </li>
	    </xsl:if>
       
</xsl:template>       
    
<xsl:template match="node()" mode="principles">

    "<xsl:value-of select="own_slot_value[slot_reference='name']/value"/>"<xsl:if test="not(position()=last())">,</xsl:if>
    
</xsl:template>    
 <xsl:template match="node()" mode="getPrinciples">
     <xsl:variable name="formid"><xsl:value-of select="position()"/><xsl:value-of select="name"/></xsl:variable>
     <xsl:variable name="principleName"><xsl:value-of select="translate(own_slot_value[slot_reference='name']/value, ' ','')"/></xsl:variable>
 	
 	<tr>
 		<td>
 			<xsl:call-template name="RenderInstanceLink">
 				<xsl:with-param name="theSubjectInstance" select="current()"/>
 			</xsl:call-template>
 		</td>
 		<td>
 			<form class="form-inline">
 				<div class="form-group principleDIV" id="form{$formid}a" style="form-inline">
                    <label name="{$principleName}"></label>
                    <input class="principle" type="radio" name="{$formid}radio" id="form{$formid}1" value="yes" easvalue="0" onchange="this.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.id=3;$(this).closest('tr').css('backgroundColor','#ccffa9');reSort();removeItem($(this).attr('easid'));getScore();"><xsl:attribute name="easid"><xsl:value-of select="current()/name"></xsl:value-of></xsl:attribute> Yes</input>
                </div>
                <div class="form-group">
                    <label name="{$principleName}"></label> 
                    <input class="form-check-input principle" type="radio" name="{$formid}radio" id="form{$formid}2" value="no" onchange="this.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.id=2;$(this).closest('tr').css('backgroundColor','#fff0a9');addItem($(this).attr('easid'));getScore();"><xsl:attribute name="easid"><xsl:value-of select="current()/name"></xsl:value-of></xsl:attribute> No</input>
               </div>
                <div class="form-group">
                    <label name="{$principleName}"></label>
                    <input class="form-check-input principle" type="radio" name="{$formid}radio" id="form{$formid}3" value="na" checked="true" onchange="this.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.id=3;$(this).closest('tr').css('backgroundColor','rgba(255, 255, 255, 0)');removeItem($(this).attr('easid'));getScore();"><xsl:attribute name="easid"><xsl:value-of select="current()/name"></xsl:value-of></xsl:attribute> N/A</input>   
                </div>
 			</form>
 		</td>
 	</tr>
</xsl:template>  
<xsl:template match="node()" mode="getStyles">
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>", "colour":"<xsl:value-of select="current()/own_slot_value[slot_reference='element_style_colour']/value"/>","textColour":"<xsl:value-of select="current()/own_slot_value[slot_reference='element_style_text_colour']/value"/>","classColour":"<xsl:value-of select="current()/own_slot_value[slot_reference='element_style_class']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>	
</xsl:stylesheet>
