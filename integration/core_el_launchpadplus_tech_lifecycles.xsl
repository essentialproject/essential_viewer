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
									<span class="text-darkgrey">Launchpad Export - Application Interface Dependency</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-3">
			     <p>
                    <a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/l4plus_technology_lifecycle_export.xsl&amp;CT=application/ms-excel&amp;FILE=technology_lifecycles.xml&amp;cl=en-gb">

                        <div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Download Technology Lifecycles as Excel</div>
                    </a><br/>
                    <a class="noUL" href="integration/plus/tech_lifecycles_IMPORTSPECv1a.zip" download="tech_lifecycles_IMPORTSPECv1a.zip">

                        <div class="downloadBtn btn btn-default bg-secondary text-white small bottom-10">Download Technology Lifecycles Import Specification</div>
                        </a><br/>
                    
                     <a href="integration/plus/Using_the_Tech-Lifecycle_Launchpad_Plus.docx" download="Using_the_Tech-Lifecycle_Launchpad_Plus.docx"><h4><i class="fa fa-book"></i> Documentation</h4></a> 
                   
                 </p>   
                        </div>
                        <div class="col-md-9">
                        <p>
                            The technology lifecycle view allows you to map lifecycles for both vendor and/or internal lifecycles.
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
                                    <td>Tech Prod Vendor Lifecycle</td>
                                    <td>Vendor lifecycles for the technology products</td>
                                </tr>  
                                <tr>
                                    <td>Tech Prod Internal Lifecycle</td>
                                    <td>Internal lifecycles and dates, duplicate the whole row for a new lifecycle status and date</td>
                                </tr> 
                                <tr>
                                    <td>Internal Tech Prod Lifecycle</td>
                                    <td>Set your internal lifecycles and colours, sequence is important for ordering</td>
                                </tr> 
                                <tr>
                                    <td>Ref</td>
                                    <td>Set colours for the vendor lifecycles.</td>
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
