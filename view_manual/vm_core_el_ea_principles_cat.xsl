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
				<title>View Manual: EA Principles Model</title>
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
									<span class="text-darkgrey">EA Principles Model</span>
								</h1>
							</div>
							<div class="row">
								<!--Setup View Purpose Section-->
								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa fa-question-circle icon-section icon-color"/>
									</div><div>
										<h2 class="text-primary">View Purpose</h2>
									</div><div> Principles are general rules and guidelines, intended to be enduring and seldom amended, that are used to govern and guide the way in which an organization sets about fulfilling its mission. </div>
									<hr/>
								</div>
								<!--Setup Desc Purpose Section-->
								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa fa-info-circle icon-section icon-color"/>
									</div><div>
										<h2 class="text-primary">View Description</h2>
									</div>
									<div class="content-section">
										<p> Enterprise Architecture principles are used to govern and guide enterprise architecture development and trade-off decisions (i.e. strategic planning, alignment, investment and macro design) of Information and ICT*, whereas Solution Architecture principles are used to govern and guide the mission of Software and System development (e.g. requirement analysis, technical design, construction, procurement, integration).</p>
										<p class="small">* <em>Does not include principles for the disciplines relating to organisational strategy, performance management and organizational development.</em>
										</p>
									</div>
									<hr/>
								</div>



								<!--Setup Meta-Model Section-->

								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
									</div>

									<h2 class="text-primary">Meta-Model</h2>

									<div class="content-section">
										<div class="alignRight">
											<img src="view_manual/vm_images/vm_legend.png" alt="Meta-Model Legend"/>
										</div>
										<br/>
										<img src="view_manual/vm_images/ea_principles_model_MM1.png" alt="EA Principles Model Meta-Model"/>
										<br/>
										<img src="view_manual/vm_images/ea_principles_model_MM2.png" alt="EA Principles Model Meta-Model"/>
									</div>
									<hr/>
								</div>

								<!--Setup Modelling Requirements Section-->
								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa fa-list-ul icon-section icon-color"/>
									</div><div>
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

													<th class="cellWidth-30pc">Navigation</th>
													<th class="cellWidth-30pc">Essential Class</th>
													<th class="cellWidth-40pc">Additional Slots</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td rowspan="5">Business/Conceptual</td>
													<td rowspan="5">Business Principle </td>
													<td>Business Implications</td>
												</tr>

												<tr>
													<td>Information Implications</td>
												</tr>

												<tr>
													<td>Application Implications</td>
												</tr>

												<tr>
													<td>Technology Implications</td>
												</tr>

												<tr>
													<td>Business Principle Rationale</td>
												</tr>

												<tr>
													<td rowspan="5">Information/Conceptual</td>
													<td rowspan="5">Information Architecture Principle</td>
													<td>Business Implications</td>
												</tr>

												<tr>
													<td>Information Implications</td>
												</tr>

												<tr>
													<td>Application Implications</td>
												</tr>

												<tr>
													<td>Technology Implications</td>
												</tr>

												<tr>
													<td>Information Principle Rationale</td>
												</tr>

												<tr>
													<td rowspan="5">Application/Conceptual</td>
													<td rowspan="5">Application Architecture Principle </td>
													<td>Business Implications</td>
												</tr>

												<tr>
													<td>Information Implications</td>
												</tr>

												<tr>
													<td>Application Implications</td>
												</tr>

												<tr>
													<td>Technology Implications</td>
												</tr>

												<tr>
													<td>Application Principle Rationale</td>
												</tr>

												<tr>
													<td rowspan="5">Technology/Conceptual</td>
													<td rowspan="5">Technology Architecture Principle</td>
													<td>Business Implications</td>
												</tr>

												<tr>
													<td>Information Implications</td>
												</tr>

												<tr>
													<td>Application Implications</td>
												</tr>

												<tr>
													<td>Technology Implications</td>
												</tr>

												<tr>
													<td>Technology Principle Rationale</td>
												</tr>
											</tbody>
										</table>
									</div>
									<hr/>
								</div>



								<!--Setup Screenshot Section-->
								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa fa-tablet icon-section icon-color"/>
									</div><div>
										<h2 class="text-primary">Screenshot</h2>
									</div>
									<div class="content-section">
										<img src="view_manual/vm_images/ea_principles_model_SS.png" alt="EA Principles Model" class="screenshotFrame"/>
									</div>
									<hr/>
								</div>



								<!--Setup Closing Tags-->
							</div>

						</div>

					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


</xsl:stylesheet>
