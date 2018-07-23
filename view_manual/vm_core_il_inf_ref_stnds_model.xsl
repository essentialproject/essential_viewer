<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!--
		* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
	 	* This file is part of Essential Architecture Manager, 
	 	* the Essential Architecture Meta-Model and The Essential Project.
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


	<xsl:template match="pro:knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>View Manual: Data Reference and Standards Model</title>
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
									<span class="text-primary">View Manual: </span>
									<span class="text-darkgrey">Data Reference and Standards Model</span>
								</h1>
							</div>
						</div>
						<!--Setup View Purpose Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-question-circle icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">View Purpose</h2>
							</div>
							<div class="content-section">To inform stakeholders regarding the data assets of an enterprise in a consistent manner that will enable re-use and data sharing. </div>
							<hr/>
						</div>



						<!--Setup View Definition Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-info-circle icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">View Description</h2>
							</div>
							<div class="content-section">A model that defines the Data Subjects and relationships, data definitions and interoperability standards used in the enterprise. </div>
							<hr/>
						</div>


						<!--Setup Top Level Meta-Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">Top Level Meta-Model</h2>
							</div>
							<div class="content-section">
								<div class="alignRight">
									<img src="view_manual/vm_images/vm_legend.png" alt="Meta-Model Legend"/>
								</div>
								<br/>
								<img src="view_manual/vm_images/data_ref_model_MM_top.png" alt="Data Reference Model Meta-Model Top Level"/>
							</div>
							<hr/>
						</div>


						<!--Setup Drill Down Meta-Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">Drill Down Meta-Model</h2>
							</div>
							<div class="content-section">
								<br/>
								<img src="view_manual/vm_images/data_ref_model_MM_drill.png" alt="Data Reference Model Meta-Model Drill Down"/>
							</div>
							<hr/>
						</div>




						<!--Setup Modelling Requirements Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Modelling Requirements</h2>
							<div class="content-section">
								<p>Guidelines for the modelling requirements</p>
								<ul>
									<li>Name and Description <span class="impact">must</span> be completed for all classes shown</li>
									<li>If no additional slots are indicated, then just name and description are required</li>
									<li>Mandatory slots are shown in <span class="textColourRed impact">red</span>, these are <strong>required</strong> for the view to work</li>
									<li>Mandatory slots with an option, i.e. Individual Role OR Group Role, are shown in <span class="textColourGreen impact">green</span>, these are <strong>required</strong> for the view to work</li>
									<li>Optional slots are shown in <span class="impact">black</span>. The report will work without these but there may be some blank fields.</li>
									<li>The "classified as" slot is automatically completed except where noted</li>
								</ul>
								<br/>
								<h3>Top Level</h3>
								<table class="table table-bordered table-striped ">
									<thead>
										<tr>

											<th class="cellWidth-30pc">Navigation</th>
											<th class="cellWidth-30pc">Essential Class</th>
											<th class="cellWidth-40pc">Additional Slots</th>
										</tr>
									</thead>
									<tbody>

										<tr>

											<td>Business/Conceptual</td>
											<td>Business Domain</td>
											<td><span class="textColourRed">Classified as</span> (see view set up instructions)</td>
										</tr>

										<tr>
											<td rowspan="3">Information/Conceptual</td>
											<td rowspan="3">Information Concept</td>
											<td class="textColourRed">Supporting Data Subjects</td>
										</tr>

										<tr>
											<td class="textColourRed">Business Domains</td>
										</tr>

										<tr>
											<td class="textColourRed">Information Views</td>
										</tr>

										<tr>
											<td rowspan="2">Information/Conceptual</td>
											<td rowspan="2">Information View</td>
											<td class="textColourRed">Information View Name</td>
										</tr>

										<tr>
											<td class="textColourRed">Refinement of Concept</td>
										</tr>

										<tr>
											<td>Information/Conceptual</td>
											<td>Data Subject</td>
											<td>&#160;</td>
										</tr>
									</tbody>
								</table>
								<h3>Drill Down</h3>
								<table class="table table-bordered table-striped ">
									<thead>
										<tr>

											<th class="cellWidth-30pc">Navigation</th>
											<th class="cellWidth-30pc">Essential Class</th>
											<th class="cellWidth-40pc">Additional Slots</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td rowspan="3">Information/Conceptual</td>
											<td rowspan="3">Information View</td>
											<td class="textColourRed">Information View Name</td>
										</tr>

										<tr>
											<td class="textColourRed">Refinement Of Concepts</td>
										</tr>

										<tr>
											<td class="textColourRed">Supporting Data Objects</td>
										</tr>

										<tr>
											<td rowspan="3">Information/Logical</td>
											<td rowspan="3">Data Object</td>
											<td class="textColourRed">Data Attributes</td>
										</tr>

										<tr>
											<td>Data Category</td>
										</tr>

										<tr>
											<td class="textColourRed">Data Subjects</td>
										</tr>

										<tr>
											<td rowspan="3">Information/Logical</td>
											<td rowspan="3">Data Object Attribute</td>
											<td class="textColourRed">Data Object</td>
										</tr>

										<tr>
											<td class="textColourRed">Data Type</td>
										</tr>

										<tr>
											<td>Data Attribute Cardinality</td>
										</tr>

										<tr>
											<td rowspan="2">EA Support / Data Management</td>
											<td rowspan="2">Data Standard</td>
											<td class="textColourRed">Data Standard Owning Organisation</td>
										</tr>

										<tr>
											<td class="textColourRed">Data Object Standards</td>
										</tr>

										<tr>
											<td rowspan="4">EA Support / Data Management</td>
											<td rowspan="4">Data Object Standard Specification</td>
											<td class="textColourRed">Data Standard</td>
										</tr>

										<tr>
											<td class="textColourRed">Standardised Data Object</td>
										</tr>

										<tr>
											<td>Standard Name for Data Object</td>
										</tr>

										<tr>
											<td>Standard Definition for Data Object</td>
										</tr>
									</tbody>
								</table>

							</div>
							<hr/>
						</div>

						<!--Setup Setup Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">Setup Instructions</h2>
							</div>
							<div class="content-section">
								<p>For this view to render successfully, each Domain needs to be assigned to a Business Domain Layer to dictate the order in which they will appear on the view.</p>
								<p> The Information Concepts appear within the Domains. First you need to define which Layer each Business Domain will be in.</p>
								<p> There are then two ways to complete this set-up:-</p>
								<br/>
								<ol>
									<li>Model for all Business Domains:- <ol>
											<li>Navigate to <em>EA Support/Taxonomy Term</em></li>
											<li>You will see six pre-defined layers - <em>Business Domain Layer::Business Domain Layer 1(-6)</em></li>
											<li>In the <em>Classified Elements </em>slot of each layer select <strong>ADD</strong> and assign the appropriate Business Domains for that layer.</li>
											<li>Each Domain should only be assigned to one layer.</li>
											<li>Complete this for each of the six layers. Note: You can put more than one Domain in each layer, the order on the report within the layer is then arbitrary.</li>
										</ol>
									</li>
									<li>Assign as you are modelling the Business Domains:- <ol>
											<li>When you are adding a Business Domain click ADD in the <em>Classified As </em>slot and select the appropriate layer for that Domain.</li>
											<li>Each Domain should only be assigned to one layer.</li>
										</ol>
									</li>
								</ol>
							</div>
							<hr/>
						</div>




						<!--Setup Screenshot Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">Screenshot</h2>
							</div>
							<div class="content-section">
								<br/>
								<img class="screenshotFrame" src="view_manual/vm_images/data_ref_model_SS.png" alt="Data Reference Model"/>
							</div>
							<hr/>
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
