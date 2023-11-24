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
				<script src="js/FileSaver.min.js?release=6.19"/>
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
									<span class="text-darkgrey">Launchpad Export - Technology Reference</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-4">
                            <p>
                                <a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/l4plus_tech_reference_export.xsl&amp;CT=application/ms-excel&amp;FILE=technology_reference.xml&amp;cl=en-gb">
    
                                    <div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Download Technology Reference as Excel</div>
                                </a><br/>
                                 <a class="noUL" href="integration/plus/Technology_Reference_Import.zip" download="Technology_Reference_Import.zip">
    
                                    <div class="downloadBtn btn btn-default bg-secondary text-white small bottom-10">Download Technology Reference Import Specification</div>
                                </a><br/>
                                 <a href="integration/plus/LaunchpadPlus-Technology_Reference_worksheet.docx" download="LaunchpadPlus-Technology_Reference_worksheet.docx"><h4><i class="fa fa-book"></i> Documentation</h4></a> 
                            </p>
						</div>
            <div class="col-md-8">
                    <p style="font-size:12pt">
                        Data to support the Strategic Technology Product Selector and technology reference models<br/>
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
                            <td>Applications to Technology Products</td>
                            <td>Lists for use in drop down in the main sheets.</td>
                        </tr>  
                        <tr>
                            <td>Tech Reference Archs</td>
                            <td>Reference architectures for the drop downs in the Technology Product Selector.</td>
                        </tr> 
                        <tr>
                            <td>Tech Ref Arch Svc Quals</td>
                            <td>Service qualities to apply to each reference architecture, e.g. Scalability.</td>
                        </tr> 
                        <tr>
                            <td>Tech Reference Models</td>
                            <td>The technology components that the reference architectures use.</td>
                        </tr> 
                        <tr>
                            <td>App to Tech Products</td>
                            <td>Maps the technology products to components and to applications. <br/>
							<small>Note: This sheet does not export from the repository and should be used for loading data only</small></td>
                        </tr> 
                        <tr>
                            <td>Technology Service Qualities</td>
                            <td>Qualities to map to technologies, e.g. Lead Time</td>
                        </tr> 
                        <tr>
                            <td>Tech Service Qual Vals</td>
                            <td>The values for each quality, e.g. for Lead Time: 1 day, 1 week, 1 month, 3 months</td>
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
