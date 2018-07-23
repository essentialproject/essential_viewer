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
				<title>View Manual: Application Change Analysis - Deficiency / Redundancy Gap</title>
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
									<span class="text-darkgrey">Application Change Analysis - Deficiency / Redundancy Gap</span>
								</h1>
							</div>
						</div>

						<!--Setup View Purpose Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-question-circle icon-section icon-color"/>
							</div>

							<h2 class="text-primary">View Purpose</h2>

							<div class="content-section">To inform stakeholders regarding the redundancies and deficiencies of applications in an enterprise. </div>
							<hr/>
						</div>




						<!--Setup View Definition Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-info-circle icon-section icon-color"/>
							</div>

							<h2 class="text-primary">View Description</h2>

							<div class="content-section">A model that indicates the deficiencies and opportunities for improvement that is derived from a comparison between the Baseline Architecture models and the Target Architecture models. </div>
							<hr/>
						</div>




						<!--Setup Meta-Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Meta-Model</h2><div>
								<div class="alignRight">
									<img src="view_manual/vm_images/vm_legend.png" alt="Meta-Model Legend"/>
								</div>
								<br/>
								<img src="view_manual/vm_images/app_gap_def_red_MM.png" alt="Application Change Analysis - Deficiency / Redundancy Gap Meta-Model"/>
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
											<th class="cellWidth-20pc">Navigation</th>
											<th class="cellWidth-20pc">Essential Class</th>
											<th class="cellWidth-30pc">Additional Slots</th>
											<th class="cellWidth-30pc">Notes</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>Application/Logical</td>
											<td>Application Provider</td>
											<td>&#160;</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td rowspan="5">EA Support/ Strategy Management</td>
											<td rowspan="5">Application Strategic Plan</td>
											<td class="textColourRed">Strategic Plan for Elements </td>
											<td>Populate with Application Provider</td>
										</tr>
										<tr>
											<td class="textColourRed">Strategic Planning Action</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td>Strategic Plan Valid From</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td>Strategic Plan Valid To</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td class="textColourRed">Depends On Strategic Plans</td>
											<td>Required if replacing one element with another i.e. the plan to remove a Site is dependent on the creation of another.</td>
										</tr>
										<tr>
											<td rowspan="3">EA Support/ Strategy Management</td>
											<td rowspan="3">Roadmap Model (See Note 1 and 2)</td>
											<td class="textColourRed">Start</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td class="textColourRed">Milestone</td>
											<td>Require at least one for each for a baseline and target architecture.</td>
										</tr>
										<tr>
											<td class="textColourRed">Roadmap Relations</td>
											<td>Double click on lines between milestones and populate supporting strategic plans field with previously defined application strategic plans</td>
										</tr>
										<tr>
											<td rowspan="2">EA Support/ Strategy Management</td>
											<td rowspan="2">Roadmap Milestone (See Note 2)</td>
											<td class="textColourRed">Display Label</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td class="textColourRed">Milestone Architecture State</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td rowspan="3">EA Support/ Strategy Management</td>
											<td rowspan="3">Architecture State (See Note 2)</td>
											<td class="textColourRed">State Valid From Date</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td class="textColourRed">State Valid To Date</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td class="textColourRed">Information logical Elements</td>
											<td>Populated with Application Provider</td>
										</tr>
										<tr>
											<td>Business/Conceptual</td>
											<td>Business Objectives</td>
											<td>&#160;</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td>Information/ Conceptual</td>
											<td>Information Architecture Objectives</td>
											<td>&#160;</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td>Application/ Conceptual</td>
											<td>Application Architecture Objectives</td>
											<td>&#160;</td>
											<td>&#160;</td>
										</tr>
										<tr>
											<td>Technology/ Conceptual</td>
											<td>Technology Architecture Objectives</td>
											<td>&#160;</td>
											<td>&#160;</td>
										</tr>
									</tbody>
								</table>
								<div class="verticalSpacer_10px"/>
								<h4>Note 1</h4>
								<p>You need to define the Roadmap Model. Do this by:-</p>
								<ul>
									<li>Dragging the Milestone and Timeline Point boxes onto the diagram. </li>
									<li>Double click to add the Milestone and Timeline Point details (don’t forget to give them a display label name).</li>
									<li>Add the Roadmap Relationships by clicking and dragging from one milestone to another.</li>
									<li>Now double click on the arrows between the milestones and populate the ‘Supporting Strategic Plans’ field with the previously defined Business Strategic Plans.</li>
								</ul>
								<h4>Note 2</h4>
								<p>These items should be re-used , ie created only once for all Business Gap Reports. The Business Roadmap should be created first and the Report Constant set up as detailed in the Business Roadmap View Manual.</p>
							</div>
							<hr/>
						</div>


						<!--Setup Planning Action Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Planning Action Configuration</h2>

							<div class="content-section">
								<p>The Gap Reports have a number of icons and colours to describe the type of change occuring between architecture states as shown in the example view on the following page. These are automatically set by the information that is entered in the Strategic plan.</p>
								<p>The Planning Action Legends, i.e. keep, enhance, replace are set as follows:</p>
								<strong>Keep</strong>
								<ul>
									<li>Requires Elements in both the baseline and target architecture states </li>
									<li>No strategic plans</li>
								</ul>
								<strong>Enhance </strong>
								<ul>
									<li>Requires Elements in both the baseline and target architecture states</li>
									<li>Requires a strategic plan whose planning action status is set to Enhance.</li>
								</ul>
								<strong>Replace </strong>
								<ul>
									<li>Requires Elements that have a strategic plan whose planning action is set to Decommission in the Baseline and Replace in the Target.</li>
									<li>The target strategic plans must be set to support the baseline strategic plan.</li>
								</ul>

								<p>The Element Colours, red, green and grey are set as follows:-</p>

								<strong>Red</strong>
								<ul>
									<li>These represent elements that are being decommissioned and will, therefore, only appear in the Baseline State. The Strategic Plan must have a strategic planning action set to “Switch Off”</li>
								</ul>
								<strong>Green</strong>
								<ul>
									<li>These represent new elements and will, therefore, only appear in the Target State. The Strategic Plan must have a planning action set to “Establish”</li>
								</ul>
								<strong>Grey</strong>
								<ul>
									<li>The change is determined by the legends, i.e. enhance or replace. Note, replace is not always red as the element may be replaced for this solution but still exist in the enterprise.</li>
								</ul>
								<br/>
								<img src="view_manual/vm_images/gap_report_example_SS.png" alt="Change Analysis Example" class="screenshotFrame"/>
							</div>
							<hr/>
						</div>




						<!--Setup Screenshot Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Screenshot</h2><div>
								<br/>
								<!--<img src="view_manual/vm_images/app_gap_def_red_SS.png" alt="Application Change Analysis - Deficiency / Redundancy Gap" class="screenshotFrame"/>-->
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
