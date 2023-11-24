<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<xsl:variable name="allClasses" select="/node()/class[type = ':ESSENTIAL-CLASS' and own_slot_value[slot_reference = ':ROLE']/value = 'Concrete']"/>
	<xsl:variable name="allReportMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="linkClasses" select="$allClasses[name = $allReportMenus/own_slot_value[slot_reference = 'report_menu_class']/value]/name"/>
	<xsl:variable name="allSlots" select="/node()/slot"/>

	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="thisObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="thisObjectClass " select="/node()/class[name = $thisObject/type]"/>
	<xsl:variable name="thisclassslots">
		<xsl:apply-templates select="$thisObject/own_slot_value" mode="seqslots"/>
	</xsl:variable>
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
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


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
				<title>Instance Overview</title>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Class Browser')"/></span>
								</h1>
								<xsl:text> </xsl:text>
								<h3><xsl:value-of select="eas:i18n('Enter Instance ID ')"/><xsl:text> </xsl:text><input name="classid" onChange="window.location='report?XML=reportXML.xml&amp;XSL=integration/instance_overview.xsl&amp;PMA='+this.value"/>
								</h3>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary"><xsl:value-of select="eas:i18n('Instance Information')"/></h2>
							<div class="content-section">
								<h3><strong><xsl:value-of select="eas:i18n('Selected Object')"/></strong>:<xsl:text> </xsl:text><xsl:value-of select="$thisObject/own_slot_value[slot_reference = 'name']/value"/></h3>
								<h3><strong><xsl:value-of select="eas:i18n('Object Type')"/></strong>:<xsl:text> </xsl:text><xsl:value-of select="$thisObject/type"/></h3>
								<h3><strong><xsl:value-of select="eas:i18n('ID ')"/><xsl:value-of select="$param1"/></strong></h3>
								<table class="table table-bordered table-striped">
									<th><xsl:value-of select="eas:i18n('Slot Name')"/></th>
									<th><xsl:value-of select="eas:i18n('Slot Value')"/></th>
									<th><xsl:value-of select="eas:i18n('Target Object Name')"/></th>
									<xsl:apply-templates select="$thisObject/own_slot_value" mode="slots">
										<xsl:sort select="slot_reference" order="ascending"/>
									</xsl:apply-templates>
								</table>

								<h3><xsl:value-of select="eas:i18n('Potential Slots not Populated')"/></h3>
								<table class="table table-bordered table-striped">
									<th><xsl:value-of select="eas:i18n('Slot Name')"/></th>
									<xsl:apply-templates select="$thisObjectClass/template_slot" mode="classslots">
										<xsl:sort select="." order="ascending"/>
									</xsl:apply-templates>
								</table>
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
	<xsl:template match="node()" mode="slots">
		<xsl:variable name="target" select="value"/>
		<tr>
			<td>
				<xsl:value-of select="slot_reference"/>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$target">
						<li>
							<xsl:value-of select="current()"/>
						</li>
					</xsl:for-each>
				</ul>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$target">
						<xsl:variable name="currentID" select="/node()/simple_instance[name = current()]"/>
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentID"/>
							</xsl:call-template>
							<xsl:value-of select="$currentID/own_slot_value[slot_reference = 'relation_name']/value"/>
						</li>
					</xsl:for-each>
				</ul>

			</td>
		</tr>

	</xsl:template>

	<xsl:template match="node()" mode="classslots">
		<xsl:variable name="thissuperObject" select="../superclass"/>
		<xsl:variable name="this" select="."/>
		<xsl:if test="position() = 1">
			<xsl:if test="../superclass">
				<xsl:apply-templates select="/node()/class[name = $thissuperObject]/template_slot" mode="classslots"/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="not(contains($thisclassslots, $this))">
			<tr>
				<td>
					<xsl:value-of select="."/>
				</td>
			</tr>
		</xsl:if>

	</xsl:template>



</xsl:stylesheet>
