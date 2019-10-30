<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<!--<xsl:include href="../information/menus/core_data_object_menu.xsl" />-->

	<xsl:output method="html"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

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
	<!-- 21.08.2010 JP  First Created	 -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Data_Subject', 'Data_Object')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->


	<xsl:variable name="allDataSubjects" select="/node()/simple_instance[type = 'Data_Subject']"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[type = 'Data_Object']"/>
    <xsl:variable name="allOrphanDataObjects" select="$allDataObjects[not(own_slot_value[slot_reference='defined_by_data_subject']/value=$allDataSubjects/name)]"/>
    
	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Data Catalogue by Name')"/>
	</xsl:variable>
	<xsl:variable name="dataListByCategoryCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Data Catalogue by Data Category')]"/>


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<!--script to support smooth scroll back to top of page-->
				<script type="text/javascript">
					$(document).ready(function() {
					    $('a[href=#top]').click(function(){
					        $('html, body').animate({scrollTop:0}, 'slow');
					        return false;
					    });
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
								<!--<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Name')"/>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$dataListByCategoryCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Data Category'"/>
										</xsl:call-template>
									</span>
								</div>-->
							</div>
						</div>

						<!--Setup Description Section-->
					</div>
					<div class="row">
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
                                
                                <xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>
							<p><xsl:value-of select="eas:i18n('Click on one of the Data Objects below to navigate to the required view')"/>.</p>
							<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:&#160;</div>
							<div class="AlphabetQuickJumpLinks hidden-xs">
								
								<!-- Build a list of the names of the elements to be sorted -->
								<xsl:variable name="anInFocusInstances" select="$allDataObjects"></xsl:variable>
								
								<!-- Get the names of the in-focus instances -->
								<xsl:variable name="anIndexList" select="$anInFocusInstances/own_slot_value[slot_reference='name']/value"></xsl:variable>																		
								
								<!-- Generate the index based on the set of elements in the indexList -->																			
								<xsl:call-template name="eas:renderIndex">
									<xsl:with-param name="theIndexList" select="$anIndexList"></xsl:with-param>
									<xsl:with-param name="theInFocusInstances" select="$anInFocusInstances"></xsl:with-param>
								</xsl:call-template>
								
								<a class="AlphabetLinks" href="#section_number">#</a>
							</div>
							<div class="clear"/>

							<a id="section_number"/>

							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'0'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'1'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'2'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'3'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'4'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'5'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'6'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'7'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'8'"/>
							</xsl:call-template>
							<xsl:call-template name="Index">
								<xsl:with-param name="letter" select="'9'"/>
							</xsl:call-template>


						</div>
						<div class="clear"/>

					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>

		</html>
	</xsl:template>


	<xsl:template name="Index">
		<xsl:param name="letter"/>

		<div class="alphabetSectionHeader">
			<h2 class="text-primary">
				<xsl:value-of select="$letter"/>
			</h2>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_</xsl:text>
		<xsl:value-of select="$letter"/>
		<xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>

		<!-- DATA SUBJECTS START HERE -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:apply-templates mode="DataSubject" select="$allDataSubjects[(starts-with(upper-case(own_slot_value[slot_reference = 'name']/value), $letter)) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="DataSubject" select="$allDataSubjects[(starts-with(upper-case(own_slot_value[slot_reference = 'name']/value), $letter))]">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
        <br/>
        <xsl:if test="$allOrphanDataObjects[(starts-with(upper-case(own_slot_value[slot_reference = 'name']/value), $letter))]">
        <h3>Data Objects with No Associated Data Subject</h3>
      
                <table class="table table-bordered table-striped">
							<tbody>
								<tr>
									<th class="cellWidth-25pc impact">Orphaned Data Object</th>
									<th class="cellWidth-75pc impact">
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
								</tr>
								<xsl:apply-templates mode="DataObject" select="$allOrphanDataObjects[(starts-with(upper-case(own_slot_value[slot_reference = 'name']/value), $letter))]">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                </xsl:apply-templates>
							</tbody>
						</table>
        </xsl:if>
		<!--<xsl:apply-templates select="$allDataSubjects[(starts-with(own_slot_value[slot_reference='name']/value, $letter))]" mode="DataSubject">
			<xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value" />
		</xsl:apply-templates>-->
		<!-- DATA SUBJECTS END HERE -->
		<br/>
		<div class="jumpToTopLink">
			<a href="#top">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
	</xsl:template>

	<xsl:template match="node()" mode="DataSubject">
		<xsl:variable name="dataSubjectID" select="current()/name"/>
		<h3>
			<!--Commented out to disable linking on subject for data provider model and other views which require a data object as a target-->
			<!--<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="targetReport" select="$targetReport"/>
				<xsl:with-param name="targetMenu" select="$targetMenu"/>
			</xsl:call-template>-->
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</h3>


		<!-- DATA OBJECTS START HERE -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="relevantDataObjects" select="$allDataObjects[(own_slot_value[slot_reference = 'defined_by_data_subject']/value = $dataSubjectID) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]"/>
				<xsl:choose>
					<xsl:when test="count($relevantDataObjects) > 0">
						<table class="table table-bordered table-striped">
							<tbody>
								<tr>
									<th class="cellWidth-25pc impact">Data Object</th>
									<th class="cellWidth-75pc impact">
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
								</tr>
								<xsl:apply-templates mode="DataObject" select="$relevantDataObjects">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</tbody>
						</table>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<em>No Data Objects defined</em>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="relevantDataObjects" select="$allDataObjects[own_slot_value[slot_reference = 'defined_by_data_subject']/value = $dataSubjectID]"/>
				<xsl:choose>
					<xsl:when test="count($relevantDataObjects) > 0">
						<table class="table table-bordered table-striped">

							<thead>
								<tr>
									<th class="cellWidth-25pc impact">Data Object</th>
									<th class="cellWidth-75pc impact">
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates mode="DataObject" select="$relevantDataObjects">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</tbody>
						</table>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<em>No Data Objects defined</em>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<xsl:template match="node()" mode="DataObject">
		<xsl:variable name="dataObjectName" select="own_slot_value[slot_reference = 'name']/value"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
	
	<!-- Render alphabetic catalogues -->
	<!-- Render the index keys, as a set of hyperlinks to sections of the catalogue that have instances
		Ordered alphabetically -->
	<xsl:template name="eas:renderIndex">
		<xsl:param name="theIndexList"></xsl:param>
		<xsl:param name="theInFocusInstances"></xsl:param>
		
		<!-- Generate the index based on the set of elements in the indexList -->																		
		<xsl:variable name="anIndexKeys" select="eas:getFirstCharacter($theIndexList)"></xsl:variable>									
		<xsl:call-template name="eas:renderIndexSections">
			<xsl:with-param name="theIndexOfNames" select="$anIndexKeys"></xsl:with-param>
		</xsl:call-template>
		
		<a class="AlphabetLinks" href="#section_number">#</a>
		
		<!-- Render each section of the index -->
		<xsl:for-each select="$anIndexKeys">
			<xsl:call-template name="Index">
				<xsl:with-param name="letter" select="current()"/>				
			</xsl:call-template>
			
		</xsl:for-each>
		
	</xsl:template>
	
	

</xsl:stylesheet>
