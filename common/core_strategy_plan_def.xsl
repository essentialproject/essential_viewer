<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>
	<xsl:variable name="currentPlan" select="/node()/simple_instance[name = $param1]"/>
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

	<!-- 16.04.2008 JWC - Stylesheet to render definition and details report about a Strategic plan -->
	<xsl:template match="knowledge_base">
		<html xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt">
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Essential Architecture Manager - Strategic Plan Specification')"/>
				</title>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$currentPlan" mode="Page_Body"/>
				<!-- PAGE BODY ENDS HERE -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template match="node()" mode="Page_Body">
		<!-- Get the name of the application provider -->
		<xsl:variable name="planName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<table cellspacing="1" cellpadding="0" width="100%">
			<tr>
				<td height="10px"/>
			</tr>
			<tr>
				<td class="mainheader" colspan="2" height="23"><xsl:value-of select="eas:i18n('Strategic Plan Specification')"/>:&#160; <span style="font-weight: 400"><xsl:apply-templates mode="RenderStrategicPlanName" select="$planName"/></span></td>
			</tr>
			<tr>
				<td class="introText">The following table provides details for the <xsl:apply-templates mode="RenderStrategicPlanName" select="$planName"/> strategic plan</td>
			</tr>
			<tr>
				<td class="text">Strategic plans make architectural statements about elements of the architecture, e.g. that something is or will be strategic</td>
			</tr>
			<tr>
				<td class="empty" width="60%">
					<tr>
						<td>&#160;</td>
					</tr>
					<table cellpadding="10" width="60%" border="0">
						<tr>
							<td width="50%">
								<!-- 16.04.2008 JWC - draw the heading and make slot for plans section -->
								<table width="100%">
									<tr>
										<td class="mappingYWhite" width="300" height="20px" colspan="2"><img src="images/calendar5.gif" width="31" height="34"/>&#160;Strategic Planning</td>
									</tr>
									<tr>
										<td width="100%">
											<table width="100%" bgcolor="#D6DDE5">
												<th align="left"/>

												<tr>
													<td class="cap" style="text-align: left" width="48%">
														<span style="font-size: 8pt">
															<b>
																<xsl:value-of select="eas:i18n('Description')"/>
															</b>
														</span>
													</td>
													<td class="easCell" style="text-align: left" width="52%">
														<span style="font-size: 8pt">
															<xsl:value-of select="own_slot_value[slot_reference = 'description']/value"/>
														</span>
													</td>
												</tr>
												<tr>
													<td class="cap" style="text-align: left" width="48%">
														<span style="font-size: 8pt">
															<b>Strategic Plan For:</b>
														</span>
													</td>
													<td class="easCell" style="text-align: left" width="52%">
														<span style="font-size: 8pt">
															<xsl:apply-templates select="own_slot_value[slot_reference = 'strategic_plan_for_element']/value" mode="RenderInstanceName"> </xsl:apply-templates>
														</span>
													</td>
												</tr>
												<tr>
													<td class="cap" style="text-align: left" width="48%">
														<span style="font-size: 8pt">
															<b>Plan Status</b>
														</span>
													</td>
													<td class="easCell" style="text-align: left" width="52%">
														<span style="font-size: 8pt">
															<b>
																<xsl:apply-templates select="own_slot_value[slot_reference = 'strategic_plan_status']/value" mode="RenderEnumerationDisplayName"/>
															</b>
														</span>
													</td>
												</tr>
												<tr>
													<td class="cap" style="text-align: left" width="48%">
														<span style="font-size: 8pt">
															<b>Strategic Plan Action</b>
														</span>
													</td>
													<td class="easCell" style="text-align: left" width="52%">
														<span style="font-size: 8pt">
															<xsl:apply-templates select="own_slot_value[slot_reference = 'strategic_planning_action']/value" mode="RenderEnumerationDisplayName"> </xsl:apply-templates>
														</span>
													</td>
												</tr>

												<tr>
													<td class="cap" style="text-align: left" width="44%" height="21">
														<b>Comments</b>
													</td>
													<td class="easCell" style="text-align: left" width="50%" height="21">
														<span style="font-size: 8pt">
															<xsl:variable name="aComment" select="own_slot_value[slot_reference = 'strategic_plan_comments']/value"/>
															<xsl:choose>
																<xsl:when test="string($aComment)">
																	<xsl:value-of select="$aComment"/>
																</xsl:when>
																<xsl:otherwise>-</xsl:otherwise>
															</xsl:choose>
														</span>
													</td>
												</tr>
												<tr>
													<td class="cap" style="text-align: left" width="44%">
														<b>Plan valid from date</b>
													</td>
													<td class="easCell" style="text-align: left" width="50%">
														<span style="font-size: 8pt">
															<xsl:variable name="aFromDate" select="own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value"/>
															<xsl:choose>
																<xsl:when test="string($aFromDate)">
																	<xsl:value-of select="$aFromDate"/>
																</xsl:when>
																<xsl:otherwise>
																	<i>No information</i>
																</xsl:otherwise>
															</xsl:choose>
														</span>
													</td>
												</tr>
												<tr>
													<td class="cap" style="text-align: left" width="44%">
														<b>Plan valid to date</b>
													</td>
													<td class="easCell" style="text-align: left" width="50%">
														<span style="font-size: 8pt">

															<xsl:variable name="aToDate" select="own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value"/>
															<xsl:choose>
																<xsl:when test="string($aToDate)">
																	<xsl:value-of select="$aToDate"/>
																</xsl:when>
																<xsl:otherwise>
																	<i>No information</i>
																</xsl:otherwise>
															</xsl:choose>
														</span>
													</td>
												</tr>
												<!-- Depends on other plans -->
												<tr>
													<td class="cap" style="text-align: left" width="44%">
														<b>Depends on plans</b>
													</td>
													<td class="easCell" style="text-align: left" width="50%">
														<xsl:variable name="aDependsOnPlans" select="own_slot_value[slot_reference = 'depends_on_strategic_plans']/value"/>
														<xsl:if test="count($aDependsOnPlans) > 0">
															<xsl:apply-templates mode="RenderPlanLinks" select="$aDependsOnPlans"/>
														</xsl:if>
													</td>
												</tr>

												<!-- Supports other plans -->
												<tr>
													<td class="cap" style="text-align: left" width="44%">
														<b>Supports plans</b>
													</td>
													<td class="easCell" style="text-align: left" width="50%">
														<xsl:variable name="aSupportsPlans" select="own_slot_value[slot_reference = 'supports_strategic_plan']/value"/>
														<xsl:if test="count($aSupportsPlans) > 0">
															<xsl:apply-templates mode="RenderPlanLinks" select="$aSupportsPlans"/>
														</xsl:if>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!-- Template to render an entry of a dependent or supporting plan -->
	<xsl:template match="node()" mode="RenderPlanLinks">
		<xsl:variable name="aPlan" select="/node()/simple_instance[name = current()]"/>
		<img src="images/green.png" width="5" height="5"/>&#160; <a>
			<xsl:attribute name="href"><xsl:text>report?XML=reportXML.xml&amp;XSL=common/core_strategy_plan_def.xsl&amp;PMA=</xsl:text>
				<xsl:value-of select="current()"/>
			</xsl:attribute>
			<xsl:apply-templates mode="RenderStrategicPlanName" select="$aPlan/own_slot_value[slot_reference = 'name']/value"/>
		</a>
		<br/>
	</xsl:template>

</xsl:stylesheet>
