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
				<title>View Manual: Business Information Model</title>
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
									<span class="text-darkgrey">Business Information Model</span>
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
							<div class="content-section">
								<p>To inform stakeholders regarding the accountability and responsibility towards the services that are routinely rendered by an enterprise – be it an internal service or external service; and the business footprint to inform capacity and network design.</p>
							</div>
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
							<div class="content-section">
								<p>A model that defines the Organisational structure (hierarchical decomposition), the functions/service performed by each organisational unit, the geographic location where these organisation unit reside, and the responsible authority (owner) of these organisation units.</p>
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
								<img src="view_manual/vm_images/bus_inf_model_MM.png" alt="Business Information Model Meta-Model Top Level"/>
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

											<th class="cellWidth-30pc">Navigation</th>
											<th class="cellWidth-30pc">Essential Class</th>
											<th class="cellWidth-40pc">Additional Slots</th>
										</tr>
									</thead>
									<tbody>
										<tr>

											<td rowspan="2">Business/Logical</td>
											<td rowspan="2">Product Type</td>
											<td class="textColourRed">Sourced Externally</td>
										</tr>

										<tr>
											<td><span class="textColourRed">Static Product Type Dependencies</span> (see note 1 below)</td>
										</tr>

										<tr>

											<td>Business/Logical</td>
											<td>Static Product Type Architecture (see note 2 below)</td>
											<td class="textColourRed">Required Information</td>
										</tr>

										<tr>
											<td>Information/Logical</td>
											<td>Information View</td>
											<td>&#160;</td>
										</tr>
									</tbody>
								</table>
								<br/>
								<h4>Note:</h4>
								<ol>
									<li>The Static Product Type Dependencies are defined in a Static Product Type Architecture. If you have already defined a Static Product Type Architecture then simply link it here by clicking <strong>ADD</strong>. If not:-</li>
									<li>Click <strong>Create</strong> and then:- <ol>
											<li>Drag the Product Type boxes onto the diagram. </li>
											<li>Double click to add the Product Type details (don’t forget to give it a display label name).</li>
											<li>Add the dependencies by clicking and dragging from the Product Type that has a dependency on the other Product Type(s). This creates the ‘depends on’ relationship.</li>
											<li>Now double click on each arrow and complete the ‘Required Information’ field, to add the detail of what information is required in this relationship.</li>
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

							<h2 class="text-primary">Screenshot</h2>
							<div class="content-section">
								<br/>
								<img src="view_manual/vm_images/bus_inf_model_SS.png" alt="Business Information Model Screenshot" class="screenshotFrame"/>
							</div>
							<hr/>
						</div>


					</div>

					<!--Setup Closing Tags-->
				</div>





				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


</xsl:stylesheet>
