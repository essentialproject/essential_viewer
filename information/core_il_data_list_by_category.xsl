<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>



	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<!--<xsl:param name="param1" />-->

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


	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Data_Subject')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Data Catalogue by Category')"/>
	</xsl:variable>
	<xsl:variable name="dataListByNameCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Data Catalogue by Name')]"/>
	<xsl:variable name="dataSubjects" select="/node()/simple_instance[type = 'Data_Subject']"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script type="text/javascript">
				$('document').ready(function(){
					 $(".blobModel_Header").vAlign();
					 $(".blobModel_Object").vAlign();
					 $(".blobModel_ObjectInactive").vAlign();
				});
				</script>

			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$dataListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Name'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Data Category')"/>
									</span>
								</div>
							</div>
						</div>


					</div>
					<div class="row">

						<div class="col-xs-12">
							<!--Setup Description Section-->
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>

							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('Click on one of the Data Subjects below to navigate to the required view')"/>.</p>
								<xsl:call-template name="RenderDataCategories"/>
							</div>
						</div>
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template name="RenderDataCategories">

		<xsl:variable name="dataCategories" select="/node()/simple_instance[(type = 'Data_Category')]"/>
		<xsl:for-each select="$dataCategories">
			<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
			<xsl:variable name="dataCat" select="current()"/>
			<xsl:variable name="dataCatLabel" select="$dataCat/own_slot_value[slot_reference = 'enumeration_value']/value"/>

			<xsl:variable name="dataCatStyle" select="'blobModel_Object impact backColour13 text-white'"/>

			<!--Conceptual Data Model Diagram Starts-->
			<div class="blobModel_Header backColour9">
				<h3 class="text-white">
					<xsl:value-of select="$dataCatLabel"/>
				</h3>
			</div>
			<!-- Generate the set of Data Subject cells -->
			<xsl:choose>
				<xsl:when test="string-length($viewScopeTermIds) > 0">
					<xsl:apply-templates mode="RenderDataSubject" select="$dataSubjects[(own_slot_value[slot_reference = 'data_category']/value = $dataCat/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
						<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:with-param name="divClass" select="$dataCatStyle"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="RenderDataSubject" select="$dataSubjects[own_slot_value[slot_reference = 'data_category']/value = $dataCat/name]">
						<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:with-param name="divClass" select="$dataCatStyle"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="not(position() = last())">
				<div class="verticalSpacer_20px"/>
			</xsl:if>

		</xsl:for-each>
	</xsl:template>


	<xsl:template name="CDM">

		<!--Conceptual Data Model Diagram Starts-->
		<div class="blobModel_Header backColour9">
			<h3 class="text-white">
				<xsl:value-of select="eas:i18n('Master Data')"/>
			</h3>
		</div>
		<!-- Filter the Master Data category -->
		<xsl:variable name="masterDataCat" select="/node()/simple_instance[(type = 'Data_Category') and (own_slot_value[slot_reference = 'name']/value = 'Master Data')]"/>
		<!-- Generate the set of Master Data cells -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:apply-templates mode="Master_Data" select="$dataSubjects[(own_slot_value[slot_reference = 'data_category']/value = $masterDataCat/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="Master_Data" select="$dataSubjects[own_slot_value[slot_reference = 'data_category']/value = $masterDataCat/name]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>

		<div class="verticalSpacer_20px"/>

		<div class="blobModel_Header backColour9">
			<h3 class="text-white">
				<xsl:value-of select="eas:i18n('Conditional Master Data')"/>
			</h3>
		</div>
		<!-- Filter the Master Data category -->
		<xsl:variable name="condMasterDataCat" select="/node()/simple_instance[(type = 'Data_Category') and (own_slot_value[slot_reference = 'name']/value = 'Conditional Master Data')]"/>
		<!-- Generate the set of Conditional Master Data cells -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:apply-templates mode="Cond_Master_Data" select="$dataSubjects[(own_slot_value[slot_reference = 'data_category']/value = $condMasterDataCat/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="Cond_Master_Data" select="$dataSubjects[own_slot_value[slot_reference = 'data_category']/value = $condMasterDataCat/name]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>


		<div class="verticalSpacer_20px"/>

		<div class="blobModel_Header backColour9">
			<h3 class="text-white">
				<xsl:value-of select="eas:i18n('Reference Data')"/>
			</h3>
		</div>
		<!-- Filter the Reference Data category -->
		<xsl:variable name="refDataCat" select="/node()/simple_instance[(type = 'Data_Category') and (own_slot_value[slot_reference = 'name']/value = 'Reference Data')]"/>
		<!-- Generate the set of Reference Data cells -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:apply-templates mode="Reference_Data" select="$dataSubjects[(own_slot_value[slot_reference = 'data_category']/value = $refDataCat/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="Reference_Data" select="$dataSubjects[own_slot_value[slot_reference = 'data_category']/value = $refDataCat/name]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>

		<div class="verticalSpacer_20px"/>

		<div class="blobModel_Header backColour3">
			<h3 class="text-white">Transactional Data</h3>
		</div>
		<!-- Generate the set of Transactional Data cells -->
		<xsl:variable name="transactionalDataCat" select="/node()/simple_instance[(type = 'Data_Category') and (own_slot_value[slot_reference = 'name']/value = 'Transactional Data')]"/>
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:apply-templates mode="Transactional_Data" select="$dataSubjects[(own_slot_value[slot_reference = 'data_category']/value = $transactionalDataCat/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="Transactional_Data" select="$dataSubjects[own_slot_value[slot_reference = 'data_category']/value = $transactionalDataCat/name]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>






	<!-- TEMPLATE TO CREATE A MASTER DATA CELL -->
	<xsl:template match="node()" mode="Master_Data">
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			<xsl:with-param name="targetMenu" select="$targetMenu"/>
			<xsl:with-param name="targetReport" select="$targetReport"/>
			<xsl:with-param name="divClass" select="'blobModel_Object backColour13 text-white impact'"/>
		</xsl:call-template>
		<!--<xsl:variable name="subjName" select="current()/own_slot_value[slot_reference='name']/value" />
		<xsl:variable name="url">
			<xsl:text>location.href='report?XML=reportXML.xml&amp;XSL=information/data_subject_summary.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="current()/name" />
			<xsl:text>&amp;LABEL=Data Subject Summary - </xsl:text>
			<xsl:value-of select="$subjName" />
			<xsl:text>';</xsl:text>
		</xsl:variable>

		<div class="blobModel_Object backColour13 text-white impact">
			<xsl:attribute name="onclick">
				<xsl:value-of select="$url" />
			</xsl:attribute>
			<xsl:value-of select="$subjName" />
		</div>-->

	</xsl:template>


	<!-- TEMPLATE TO CREATE A REFERENCE DATA CELL -->
	<xsl:template match="node()" mode="Reference_Data">
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			<xsl:with-param name="targetMenu" select="$targetMenu"/>
			<xsl:with-param name="targetReport" select="$targetReport"/>
			<xsl:with-param name="divClass" select="'blobModel_Object backColour13 text-white impact'"/>
		</xsl:call-template>
		<!--<xsl:variable name="subjName" select="current()/own_slot_value[slot_reference='name']/value" />
		<xsl:variable name="url">
			<xsl:text>location.href='report?XML=reportXML.xml&amp;XSL=information/data_subject_summary.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="current()/name" />
			<xsl:text>&amp;LABEL=Data Subject Summary - </xsl:text>
			<xsl:value-of select="$subjName" />
			<xsl:text>';</xsl:text>
		</xsl:variable>
		
		<div class="blobModel_Object backColour13 text-white impact">
			<xsl:attribute name="onclick">
				<xsl:value-of select="$url" />
			</xsl:attribute>
			<xsl:value-of select="$subjName" />
		</div>-->

	</xsl:template>


	<!-- TEMPLATE TO CREATE A CONDITIONAL MASTER DATA CELL -->
	<xsl:template match="node()" mode="Cond_Master_Data">
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			<xsl:with-param name="targetMenu" select="$targetMenu"/>
			<xsl:with-param name="targetReport" select="$targetReport"/>
			<xsl:with-param name="divClass" select="'blobModel_Object backColour13 text-white impact'"/>
		</xsl:call-template>
		<!--<xsl:variable name="subjName" select="current()/own_slot_value[slot_reference='name']/value" />
		<xsl:variable name="url">
			<xsl:text>location.href='report?XML=reportXML.xml&amp;XSL=information/data_subject_summary.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="current()/name" />
			<xsl:text>&amp;LABEL=Data Subject Summary - </xsl:text>
			<xsl:value-of select="$subjName" />
			<xsl:text>';</xsl:text>
		</xsl:variable>
		
		<div class="blobModel_Object backColour13 text-white impact">
			<xsl:attribute name="onclick">
				<xsl:value-of select="$url" />
			</xsl:attribute>
			<xsl:value-of select="$subjName" />
		</div>-->

	</xsl:template>

	<!-- TEMPLATE TO CREATE A TRANSACTIONAL DATA CELL -->
	<xsl:template match="node()" mode="Transactional_Data">
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			<xsl:with-param name="targetMenu" select="$targetMenu"/>
			<xsl:with-param name="targetReport" select="$targetReport"/>
			<xsl:with-param name="divClass" select="'blobModel_Object bg-midgrey text-white impact'"/>
		</xsl:call-template>
		<!--<xsl:variable name="subjName" select="current()/own_slot_value[slot_reference='name']/value" />
		<xsl:variable name="url">
			<xsl:text>location.href='report?XML=reportXML.xml&amp;XSL=information/data_subject_summary.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="current()/name" />
			<xsl:text>&amp;LABEL=Data Subject Summary - </xsl:text>
			<xsl:value-of select="$subjName" />
			<xsl:text>';</xsl:text>
		</xsl:variable>

		<div class="blobModel_Object backColour13 text-white impact">
			<xsl:attribute name="onclick">
				<xsl:value-of select="$url" />
			</xsl:attribute>
			<xsl:value-of select="$subjName" />
		</div>-->

	</xsl:template>

	<!-- TEMPLATE TO CREATE A DATA SUBJECT CELL -->
	<xsl:template match="node()" mode="RenderDataSubject">
		<xsl:param name="divClass"/>

		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			<xsl:with-param name="targetMenu" select="$targetMenu"/>
			<xsl:with-param name="targetReport" select="$targetReport"/>
			<xsl:with-param name="divClass" select="$divClass"/>
			<xsl:with-param name="anchorClass" select="'noUL'"/>
		</xsl:call-template>
	</xsl:template>




</xsl:stylesheet>
