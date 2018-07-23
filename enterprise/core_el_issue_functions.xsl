<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
	<!--
        * Copyright (c)2008 Enterprise Architecture Solutions ltd.
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
	<!-- 03.12.2014 JP - A set of common functions nad templates for assessment of applications -->
	<xsl:import href="../common/core_utilities.xsl"/>

	<xsl:variable name="allIssues" select="/node()/simple_instance[type = 'Issue']"/>
	<xsl:variable name="allIssueCategpries" select="/node()/simple_instance[name = $allIssues/own_slot_value[slot_reference = 'issue_categories']/value]"/>
	<xsl:variable name="allIssueImpacts" select="/node()/simple_instance[name = $allIssues/own_slot_value[slot_reference = 'issue_impact']/value]"/>
	<xsl:variable name="allIssueRelatedBusElements" select="/node()/simple_instance[name = $allIssues/own_slot_value[slot_reference = 'related_business_elements']/value]"/>
	<xsl:variable name="allIssueRelatedAppElements" select="/node()/simple_instance[name = $allIssues/own_slot_value[slot_reference = 'related_application_elements']/value]"/>
	<xsl:variable name="allIssueRelatedInfoDataElements" select="/node()/simple_instance[name = $allIssues/own_slot_value[slot_reference = 'related_information_elements']/value]"/>
	<xsl:variable name="allIssueRelatedTechElements" select="/node()/simple_instance[name = $allIssues/own_slot_value[slot_reference = 'related_technology_elements']/value]"/>
	<xsl:variable name="allIssueRelatedElements" select="$allIssueRelatedBusElements union $allIssueRelatedAppElements union $allIssueRelatedInfoDataElements union $allIssueRelatedInfoDataElements"/>
	<xsl:variable name="allIssueMitigatingPlans" select="/node()/simple_instance[name = $allIssues/own_slot_value[slot_reference = 'resolved_by']/value]"/>



	<xsl:template name="RenderIssuesTable">
		<xsl:param name="relatedElement"/>

		<xsl:variable name="relevantUssues" select="$allIssues[own_slot_value[slot_reference = ('related_business_elements', 'related_application_elements', 'related_information_elements', 'related_technology_elements')]/value = $relatedElement/name]"/>

		<!--Setup Related Issues Section-->
		<div class="col-xs-12">
			<div class="sectionIcon">
				<i class="fa fa-exclamation icon-section icon-color"/>
			</div>

			<h2 class="text-primary">
				<xsl:value-of select="eas:i18n('Related Issues')"/>
			</h2>

			<div class="content-section">
				<xsl:choose>
					<xsl:when test="count($relevantUssues) = 0">
						<em>
							<xsl:value-of select="eas:i18n('No related issues captured')"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<p><xsl:value-of select="eas:i18n('The following issues have been identified for')"/>&#160; <xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$relatedElement"/></xsl:call-template>.</p>

						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th class="cellWidth-20pc">
										<xsl:value-of select="eas:i18n('Issue')"/>
									</th>
									<th class="cellWidth-20pc">
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
									<th class="cellWidth-20pc">
										<xsl:value-of select="eas:i18n('Category')"/>
									</th>
									<th class="cellWidth-5pc">
										<xsl:value-of select="eas:i18n('Priority')"/>
									</th>
									<th class="cellWidth-15pc">
										<xsl:value-of select="eas:i18n('Impact')"/>
									</th>
									<th class="cellWidth-20pc">
										<xsl:value-of select="eas:i18n('Other Impacted Elements')"/>
									</th>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates select="$relevantUssues" mode="RenderIssueRow">
									<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									<xsl:with-param name="currentElement" select="$relatedElement"/>
								</xsl:apply-templates>
							</tbody>
						</table>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<hr/>
		</div>

	</xsl:template>


	<!-- render an Application Service table row  -->
	<xsl:template match="node()" mode="RenderIssueRow">
		<xsl:param name="currentElement"/>
		<xsl:variable name="issue" select="current()"/>


		<xsl:variable name="issueCategpries" select="$allIssueCategpries[name = $issue/own_slot_value[slot_reference = 'issue_categories']/value]"/>
		<xsl:variable name="issueImpacts" select="$allIssueImpacts[name = $issue/own_slot_value[slot_reference = 'issue_impact']/value]"/>
		<xsl:variable name="issueOtherRelatedElements" select="($allIssueRelatedElements except $currentElement)[name = $issue/own_slot_value[slot_reference = ('related_business_elements', 'related_application_elements', 'related_information_elements', 'related_technology_elements')]/value]"/>
		<xsl:variable name="issuePriority" select="$issue/own_slot_value[slot_reference = 'issue_priority']/value"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$issue"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$issue"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($issueCategpries) > 0">
						<ul>
							<xsl:for-each select="$issueCategpries">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($issuePriority) > 0">
						<xsl:value-of select="$issuePriority"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($issueImpacts) > 0">
						<ul>
							<xsl:for-each select="$issueImpacts">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($issueOtherRelatedElements) > 0">
						<ul>
							<xsl:for-each select="$issueOtherRelatedElements">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>


</xsl:stylesheet>
