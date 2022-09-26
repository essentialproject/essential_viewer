<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">
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

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		 
		  
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/> 
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Launchpad Exporter</title> 
				<script src="js/FileSaver.min.js"/>
				<style>
				.minText {font-size:0.8em;
						  vertical-align: top;
							}
				.stepsHead {font-size:0.9em;
						  	horizontal-align: center;
							background-color:#393939;
							color:#fff}	
				.playBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					border-radius: 4px;
					width: 100%;
					margin-bottom: 10px;
					position: relative;
				}
				.notesBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					width:60%;
					border-radius: 4px; 
				}
				.playTitle{
					font-weight: 700;
					font-size: 110%;
				}
				.playDescription{
					font-size: 90%;
				}
				.playDocs {
					position: absolute;
					top: 5px;
					right: 5px;
				}
				.playSteps{
					display: none;
            }
           
				.playSteps > ul {
					<!--columns: 2;-->
				}

            .additional {
               color: #32a8a8;
            }
            .additionalShow {
               color: #32a8a8;
            }
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
									<span class="text-darkgrey">Launchpad Export - Strategy Planner Data Load</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-4">
						<p>
							<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/l4plus_strat_planner_export.xsl&amp;CT=application/ms-excel&amp;FILE=cust_journey_strat_planner.xml&amp;cl=en-gb">

								<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Download Strategy Planner as Excel</div>
							</a><br/>
							<a class="noUL" href="https://enterprise-architecture.org/downloads_area/Strategy_Planner_Import_v2.zip" download="Strategy_Planner_Import_v2.zip">

								<div class="downloadBtn btn btn-default bg-secondary text-white small bottom-10">Download Strategy Planner Import Specification</div>
							</a><br/>
							<br/>
                            <a href="https://enterprise-architecture.org/downloads_area/LaunchpadPlus-Strategy_Planner_and_Customer_Journeys.docx" download="LaunchpadPlus-Strategy_Planner_and_Customer_Journeys.docx"><h4><i class="fa fa-book"></i> Documentation</h4></a> 
				     
						</p>
						</div>
            <div class="col-md-8">
                <p>
                    The strategy planner download is used as part of the set up the Strategy Planner view, it creates customer journeys for that view 
                </p>
                <p>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <td>Sheet</td>
                            <td>Description</td>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>Physical Process  to Cust Serv Qual Values</td>
                            <td>Lists for use in drop down in the main sheets, ensure any scores you add in the pink tabs are best 10 to worst -10</td>
                        </tr>  
                        <tr>
                            <td>Value Streams</td>
                            <td>The value streams that will map to the customer journeys (via the value stages).</td>
                        </tr> 
                        <tr>
                            <td>Value Stages</td>
                            <td>The stages, which map to a value stream and are used in the customer journeys.</td>
                        </tr> 
                        <tr>
                            <td>Customer Journeys</td>
                            <td>The customer journeys and the products they support.</td>
                        </tr> 
                        <tr>
                            <td>Customer Journey Phases</td>
                            <td>Maps the phases and the customer journeys they support, plus the customer emotions at each phase</td>
                        </tr> 
                        <tr>
                            <td>CJPs to Value Stages</td>
                            <td>Simple mapping</td>
                        </tr> 
                        <tr>
                            <td>CJPs to Phys Procs</td>
                            <td>Simple mapping</td>
                        </tr> 
                        <tr>
                            <td>CJPs to Emotions</td>
                            <td>Simple mapping</td>
                        </tr>  
                        <tr>
                            <td>CJPs to Service Quality Values</td>
                            <td>Simple mapping</td>
                        </tr>  
                        </tbody>
                    </table>
                </p>
                </div>
						<!--Setup Closing Tags-->
					</div>
				</div>
 
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
 			
      </body>
		</html>
	</xsl:template>
</xsl:stylesheet>  
