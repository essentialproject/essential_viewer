<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<!--<xsl:include href="../application/menus/core_app_provider_menu.xsl" />-->


	<xsl:output method="html"/>

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
	<!-- 24.02.2014 JWC	Fixed rendering of applications that are not part of a family -->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="instanceClassName" select="'Application_Provider', 'Composite_Application_Provider'"/>
	<xsl:variable name="allInstances" select="/node()/simple_instance[supertype = $instanceClassName or type = $instanceClassName]"/>
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->


	<!-- START SPECIFIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="allApplicationFamilies" select="/node()/simple_instance[type = 'Application_Family']"/>
	<xsl:variable name="appListByName" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Application Provider Catalogue by Name')]"/>
	<xsl:variable name="appListAsTableCatalogue" select="eas:get_report_by_name('Core: Application Provider Catalogue as Table')"/>
	<!-- END SPECIFIC CATALOGUE SETUP VARIABES -->


	<xsl:template match="knowledge_base">
		<!-- SCOPE THE VIEW AS REQUIRED -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeInstances" select="$allInstances[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeInstances" select="$allInstances"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="inScopeInstances"/>
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Application Catalogue by Application Family')"/>
		</xsl:param>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script type="text/javascript" src="js/jquery.columnizer.js?release=6.19"/>
				<!--script to turn the app providers list into columns-->
				<script>				
					$(function(){					
						if (document.documentElement.clientWidth &gt; 767) {
							$('.catalogItems').columnize({columns: 2});
						}			
					});
				</script>
				<!--script to support smooth scroll back to top of page-->
				<script type="text/javascript">
					$(document).ready(function() {
					    $('a.topLink').click(function(){
					        $('html, body').animate({scrollTop:0}, 'slow');
					        return false;
					    });
					});
				</script>
			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, IF REQUIRED -->
				<xsl:call-template name="RenderInstanceLinkJavascript">
					<xsl:with-param name="instanceClassName" select="$instanceClassName"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
				</xsl:call-template>

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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theCatalogue" select="$appListByName"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="eas:i18n('Name')"/>
									</xsl:call-template>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Application Family')"/>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$appListAsTableCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="eas:i18n('Table')"/>
										</xsl:call-template>
									</span>
								</div>
							</div>
						</div>


						<!--Setup Description Section-->
					</div>
					<div class="row">
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Application Catalogue')"/>
								</h2>
							</div>
							<p><xsl:value-of select="eas:i18n('Please click on one of the Applications below')"/>.</p>
							<div>
								<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:</div>
								<div class="AlphabetQuickJumpLinks hidden-xs">
									<a class="AlphabetLinks" href="#section_A">
										<xsl:value-of select="eas:i18n('A')"/>
									</a>
									<a class="AlphabetLinks" href="#section_B">
										<xsl:value-of select="eas:i18n('B')"/>
									</a>
									<a class="AlphabetLinks" href="#section_C">
										<xsl:value-of select="eas:i18n('C')"/>
									</a>
									<a class="AlphabetLinks" href="#section_D">
										<xsl:value-of select="eas:i18n('D')"/>
									</a>
									<a class="AlphabetLinks" href="#section_E">
										<xsl:value-of select="eas:i18n('E')"/>
									</a>
									<a class="AlphabetLinks" href="#section_F">
										<xsl:value-of select="eas:i18n('F')"/>
									</a>
									<a class="AlphabetLinks" href="#section_G">
										<xsl:value-of select="eas:i18n('G')"/>
									</a>
									<a class="AlphabetLinks" href="#section_H">
										<xsl:value-of select="eas:i18n('H')"/>
									</a>
									<a class="AlphabetLinks" href="#section_I">
										<xsl:value-of select="eas:i18n('I')"/>
									</a>
									<a class="AlphabetLinks" href="#section_J">
										<xsl:value-of select="eas:i18n('J')"/>
									</a>
									<a class="AlphabetLinks" href="#section_K">
										<xsl:value-of select="eas:i18n('K')"/>
									</a>
									<a class="AlphabetLinks" href="#section_L">
										<xsl:value-of select="eas:i18n('L')"/>
									</a>
									<a class="AlphabetLinks" href="#section_M">
										<xsl:value-of select="eas:i18n('M')"/>
									</a>
									<a class="AlphabetLinks" href="#section_N">
										<xsl:value-of select="eas:i18n('N')"/>
									</a>
									<a class="AlphabetLinks" href="#section_O">
										<xsl:value-of select="eas:i18n('O')"/>
									</a>
									<a class="AlphabetLinks" href="#section_P">
										<xsl:value-of select="eas:i18n('P')"/>
									</a>
									<a class="AlphabetLinks" href="#section_Q">
										<xsl:value-of select="eas:i18n('Q')"/>
									</a>
									<a class="AlphabetLinks" href="#section_R">
										<xsl:value-of select="eas:i18n('R')"/>
									</a>
									<a class="AlphabetLinks" href="#section_S">
										<xsl:value-of select="eas:i18n('S')"/>
									</a>
									<a class="AlphabetLinks" href="#section_T">
										<xsl:value-of select="eas:i18n('T')"/>
									</a>
									<a class="AlphabetLinks" href="#section_U">
										<xsl:value-of select="eas:i18n('U')"/>
									</a>
									<a class="AlphabetLinks" href="#section_V">
										<xsl:value-of select="eas:i18n('V')"/>
									</a>
									<a class="AlphabetLinks" href="#section_W">
										<xsl:value-of select="eas:i18n('W')"/>
									</a>
									<a class="AlphabetLinks" href="#section_X">
										<xsl:value-of select="eas:i18n('X')"/>
									</a>
									<a class="AlphabetLinks" href="#section_Y">
										<xsl:value-of select="eas:i18n('Y')"/>
									</a>
									<a class="AlphabetLinks" href="#section_Z">
										<xsl:value-of select="eas:i18n('Z')"/>
									</a>
									<a class="AlphabetLinks" href="#section_number">#</a>
								</div>
								<div class="clear"/>



								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'A'"/>
									<xsl:with-param name="letterLow" select="'a'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'B'"/>
									<xsl:with-param name="letterLow" select="'b'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'C'"/>
									<xsl:with-param name="letterLow" select="'c'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'D'"/>
									<xsl:with-param name="letterLow" select="'d'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'E'"/>
									<xsl:with-param name="letterLow" select="'e'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'F'"/>
									<xsl:with-param name="letterLow" select="'f'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'G'"/>
									<xsl:with-param name="letterLow" select="'g'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'H'"/>
									<xsl:with-param name="letterLow" select="'h'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'I'"/>
									<xsl:with-param name="letterLow" select="'i'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'J'"/>
									<xsl:with-param name="letterLow" select="'j'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'K'"/>
									<xsl:with-param name="letterLow" select="'k'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'L'"/>
									<xsl:with-param name="letterLow" select="'l'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'M'"/>
									<xsl:with-param name="letterLow" select="'m'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'N'"/>
									<xsl:with-param name="letterLow" select="'n'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'O'"/>
									<xsl:with-param name="letterLow" select="'o'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'P'"/>
									<xsl:with-param name="letterLow" select="'p'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'Q'"/>
									<xsl:with-param name="letterLow" select="'q'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'R'"/>
									<xsl:with-param name="letterLow" select="'r'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'S'"/>
									<xsl:with-param name="letterLow" select="'s'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'T'"/>
									<xsl:with-param name="letterLow" select="'t'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'U'"/>
									<xsl:with-param name="letterLow" select="'u'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'V'"/>
									<xsl:with-param name="letterLow" select="'v'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'W'"/>
									<xsl:with-param name="letterLow" select="'w'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'X'"/>
									<xsl:with-param name="letterLow" select="'x'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'Y'"/>
									<xsl:with-param name="letterLow" select="'y'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'Z'"/>
									<xsl:with-param name="letterLow" select="'z'"/>
								</xsl:call-template>


								<a id="section_number"/>

								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'0'"/>
									<xsl:with-param name="letterLow" select="'0'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'1'"/>
									<xsl:with-param name="letterLow" select="'1'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'2'"/>
									<xsl:with-param name="letterLow" select="'2'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'3'"/>
									<xsl:with-param name="letterLow" select="'3'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'4'"/>
									<xsl:with-param name="letterLow" select="'4'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'5'"/>
									<xsl:with-param name="letterLow" select="'5'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'6'"/>
									<xsl:with-param name="letterLow" select="'6'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'7'"/>
									<xsl:with-param name="letterLow" select="'7'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'8'"/>
									<xsl:with-param name="letterLow" select="'8'"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="relevantInstances" select="$inScopeInstances"/>
									<xsl:with-param name="letterCap" select="'9'"/>
									<xsl:with-param name="letterLow" select="'9'"/>
								</xsl:call-template>

							</div>
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
		<xsl:param name="relevantInstances"/>
		<xsl:param name="letterCap"/>
		<xsl:param name="letterLow"/>
		<div class="alphabetSectionHeader">
			<h2 class="text-primary">
				<xsl:value-of select="$letterCap"/>
			</h2>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_</xsl:text>
		<xsl:value-of select="$letterCap"/>
		<xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
		<!-- APPLICATIONS START HERE -->

		<xsl:variable name="appList" select="$allApplicationFamilies[((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
		<xsl:if test="count($appList) > 0">
			<xsl:apply-templates select="$appList" mode="Applications">
				<xsl:with-param name="appLetterCap" select="$letterCap"/>
				<xsl:with-param name="appLetterLow" select="$letterLow"/>
				<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:with-param name="relevantInstances" select="$relevantInstances"/>
			</xsl:apply-templates>
		</xsl:if>

		<!-- Add any relevant orphaned application providers (not part of a family) -->
		<xsl:variable name="orphanApps" select="$relevantInstances[(not(count(own_slot_value[slot_reference = 'type_of_application']/value) > 0)) and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
		<xsl:if test="count($orphanApps) > 0">
			<h3>
				<xsl:value-of select="eas:i18n('Others (No Family Defined)')"/>
			</h3>
			<div class="catalogItems">
				<ul>
					<xsl:apply-templates select="$orphanApps" mode="Application_Providers">
						<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
					</xsl:apply-templates>
				</ul>
			</div>
		</xsl:if>

		<div class="jumpToTopLink">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
		<!-- APPLICATIONS END HERE -->
	</xsl:template>

	<xsl:template match="node()" mode="Applications">
		<xsl:param name="relevantInstances"/>
		<xsl:param name="appLetterCap"/>
		<xsl:param name="appLetterLow"/>
		<xsl:variable name="thisone">
			<xsl:value-of select="name"/>
		</xsl:variable>

		<h3>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</h3>
		<div class="app_providers">
			<ul>
				<xsl:apply-templates select="$relevantInstances[(own_slot_value[slot_reference = 'type_of_application']/value = $thisone)]" mode="Application_Providers">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
		</div>

	</xsl:template>

	<xsl:template match="node()" mode="Application_Providers">

		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="targetMenu" select="$targetMenu"/>
				<xsl:with-param name="targetReport" select="$targetReport"/>
			</xsl:call-template>
		</li>

	</xsl:template>


</xsl:stylesheet>
