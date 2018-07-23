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
				<title>View Manual: Data Security Model</title>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary">View Manual: </span>
									<span class="text-darkgrey">Data Security Model</span>
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
								<div class="content-section">To inform stakeholders regarding the security and responsibilities of the data assets in a department in order to improve data accountability </div>
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
								<div class="content-section">A model that defines the security classification of Data Subjects and the roles in the organisation that need access thereto. </div>
								<hr/>
							</div>


							<!--Setup Meta-Model Section-->

							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">Meta-Model</h2>
								</div>
								<div>
									<div class="alignRight">
										<img src="view_manual/vm_images/vm_legend.png" alt="Meta-Model Legend"/>
									</div>
									<br/>
									<img src="view_manual/vm_images/data_sec_model_MM.png" alt="Data Security Model Meta-Model"/>
								</div>
								<hr/>
							</div>


							<!--Setup Modelling Requirements Section-->

							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">Modelling Requirements</h2>
								</div>
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

												<th class="cellWidth-20pc">Navigation</th>
												<th class="cellWidth-20pc">Essential Class</th>
												<th class="cellWidth-30pc">Additional Slots</th>
												<th class="cellWidth-30pc">Notes</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>Information / Conceptual</td>
												<td>Data Subject</td>
												<td class="textColourRed">Realised by data Objects</td>
												<td>&#160;</td>
											</tr>

											<tr>
												<td rowspan="2">Information / Logical</td>
												<td rowspan="2">Data Object</td>
												<td class="textColourRed">Data Subject</td>
												<td>&#160;</td>
											</tr>

											<tr>
												<td>Data Object Stakeholders</td>
												<td>&#160;</td>
											</tr>

											<tr>

												<td>Business/Logical</td>
												<td>Business Role / Individual OR Group</td>
												<td>&#160;</td>
												<td>&#160;</td>
											</tr>

											<tr>
												<td rowspan="3">EA Support / Security Management</td>
												<td rowspan="3">Security Policy</td>
												<td class="textColourRed">Policy Actors</td>
												<td>Populate with Business Role</td>
											</tr>

											<tr>
												<td class="textColourRed">Policy for Action</td>
												<td>&#160;</td>
											</tr>

											<tr>
												<td class="textColourRed">Policy Applies to Resources</td>
												<td>Populate with Data Object</td>
											</tr>

											<tr>

												<td>EA Support / Security Management</td>
												<td>Security Classification</td>
												<td class="textColourRed">Classified Information Resources</td>
												<td>&#160;</td>
											</tr>

											<tr>
												<td rowspan="3">EA Support / Data Management</td>
												<td rowspan="3">Data Management Policy</td>
												<td class="textColourRed">Data Management Responsibility</td>
												<td>Populate with a Data Stakeholder role - see Report set up instructions</td>
											</tr>

											<tr>
												<td class="textColourRed">Managed Data Object</td>
												<td>&#160;</td>
											</tr>

											<tr>
												<td class="textColourRed">Responsible Roles</td>
												<td>&#160;</td>
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
								<div>
									<ul>
										<li>This view needs all the different types of 'Data Stakeholder' to be defined and added up front. </li>
										<li>To do this:- <ul><li>Define all the different types of Data Stakeholder you have, i.e. Data Owner, Data Custodian, Data Quality Manager etc. </li>
												<li>Go to <em>Business Layer/Business Conceptual/Business Role Type</em> and <strong>CREATE </strong>a new instance of a <em>Business Role Type</em>.</li>
												<li>The name must be <strong>ADDED</strong> as <em>Data Stakeholder</em>.</li>
												<li>Click <strong>CREATE</strong> in the <em>Is Realised by Role </em>slot, select <em>Individual Business Role </em>and <strong>ADD</strong> the name of the new role, i.e. Data Owner</li></ul></li>
									</ul>
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
								<div>
									<br/>
									<img src="view_manual/vm_images/data_sec_model_SS.png" alt="Data Security Model" class="screenshotFrame"/>
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
