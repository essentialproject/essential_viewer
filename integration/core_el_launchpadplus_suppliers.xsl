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
									<span class="text-darkgrey">Launchpad Export - Supplier Contract Management</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-4">
                            <p>
                                <a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/l4plus_supplier_management.xsl&amp;CT=application/ms-excel&amp;FILE=supplier_management.xml&amp;cl=en-gb">
                                    <div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Download Supplier Management as Excel</div>
                                </a><br/>
                                <a class="noUL" href="https://enterprise-architecture.org/downloads_area/Suppliers_Contracts_Import_Spec_23_2_22.zip" download="Suppliers_Contracts_Import_Specv1a.zip">
                                    <div class="downloadBtn btn btn-default bg-secondary text-white small bottom-10">Download Supplier Management Import Specification</div>
                                </a><br/>                                     
                                    <a href="https://enterprise-architecture.org/downloads_area/Using_the_Supplier_Contracts_Launchpad_Plus.docx" download="Using_the_Supplier_Contracts_Launchpad_Plus.docx"><h4><i class="fa fa-book"></i> Documentation</h4></a> 
                            </p>
						</div>
            <div class="col-md-8">
                    <p style="font-size:12pt">
                        Data to support the Supplier Contract Management views<br/>
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
                                <td>REF Orgs - Contract Owner</td>
                                <td>A reference list of organisations that might own a contract</td>
                            </tr>
                           
                            <tr>
                                <td>REF Business Processes</td>
                                <td>A reference list of the business processes that have been exported from the repository</td>
                            </tr>
                            <tr>
                                <td>REF Applications</td>
                                <td>A reference list of the applications that have been exported from the repository</td>
                            </tr>
                            <tr>
                                <td>REF Technology Products</td>
                                <td>A reference list of the technology products that have been exported from the repository</td>
                            </tr>
                            <tr>
                                <td>Contract Types</td>
                                <td>A reference list of types of contracts</td>
                            </tr>
                            <tr>
                                <td>Renewal Types</td>
                                <td>A reference list of types of renewals</td>
                            </tr>
                            <tr>
                                <td>Unit Types</td>
                                <td>A reference list of types of contract units</td>
                            </tr>
                            <tr>
                                <td>Contracts</td>
                                <td>Captures the contracts related to a supplier, for multiple documents use the repository (or the editor in Cloud/Docker)</td>
                            </tr>
                            <tr>
                                <td>Contract Components</td>
                                <td>Captures the individual components for a  contract, for example the applications/technologies covered, cost etc.</td>
                            </tr>
                            <tr>
                                <td>Supplier Relation Status</td>
                                <td>A reference list of Supplier status</td>
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
