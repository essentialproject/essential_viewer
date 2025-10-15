<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xpath-default-namespace="http://protege.stanford.edu/xml" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<!-- 21.01.2012	JWC Catalogue of applications to select for Application Distribution Change Analysis -->


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider')"/>
	<xsl:variable name="targetReport" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Application Change Analysis - Application Distribution')]"/>
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>Application Distribution Change Analysis Catalogue</title>
				<script type="text/javascript" src="js/autocolumn.js"/>
				<!--script to turn the app providers list into columns-->
				<script>
						$(function(){
							$('.app_providers').columnize({columns: 2});
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
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderAppProviderPopUpScript" />-->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey">
											<xsl:value-of select="eas:i18n('Application Distribution Change Analysis Catalogue')"/>
										</span>
									</h1>
								</div>
							</div>
						</div>
						<div id="filterSectionContainer">
							<div id="componentFilterKey">
								<span id="componentFilterKeyLabel"><xsl:value-of select="eas:i18n('Filter')"/>:</span>
							</div>
							<div id="componentFilterElementsContainer">

								<!--start script to control the show hide of individual sections - requires jquery-->
								<script type="text/javascript">
								   $(document).ready(function(){   
									      $("#component_About").click(function(){
									        if ($("#component_About").is(":checked"))
									        {
									            $("#sectionAbout").show("slow");
									        }
									        else
									        {      
									            $("#sectionAbout").hide("slow");
									        }
									      });
									      
									      
									      $("#component_Catalogue").click(function(){
									       if ($("#component_Catalogue").is(":checked"))
									       {
									           $("#sectionCatalogue").show("slow");
									       }
									       else
									       {      
									           $("#sectionCatalogue").hide("slow");
									       }
									     });
									     
									   				   	
								   });
								    </script>

								<div class="componentFilterElement">
									<form class="checkbox">
										<input type="checkbox" id="component_About"/>
										<span class="componentFilterElementLabel">
											<a href="#sectionAbout">
												<xsl:value-of select="eas:i18n('About This View')"/>
											</a>
										</span>
									</form>
								</div>
								<div class="componentFilterElement">
									<form class="checkbox">
										<input type="checkbox" id="component_Catalogue" checked="checked"/>
										<span class="componentFilterElementLabel">
											<a href="#sectionCatalogue">
												<xsl:value-of select="eas:i18n('Catalogue')"/>
											</a>
										</span>
									</form>
								</div>
							</div>
						</div>
						<hr/>
						<div class="clear"/>

						<!--Setup About This View Section-->
						<div id="sectionAbout" class="hidden">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-question-circle icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('About This View')"/>
									</h2>
								</div>
								<div>
									<p>
										<xsl:value-of select="eas:i18n('This view shows all the Applications contained in the repository. Select the Application from this list to view its Application Distribution Change Analysis.')"/>
									</p>
								</div>
							</div>
							<hr/>
							<div class="clear"/>
						</div>

						<!--Setup Description Section-->
					</div>
					<div class="row">
						<div id="sectionCatalogue">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Select Application for Distribution Change Analysis')"/>
									</h2>
								</div>
								<div>
									<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:&#160;</div>
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
										<xsl:with-param name="letterCap" select="'A'"/>
										<xsl:with-param name="letterLow" select="'a'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'B'"/>
										<xsl:with-param name="letterLow" select="'b'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'C'"/>
										<xsl:with-param name="letterLow" select="'c'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'D'"/>
										<xsl:with-param name="letterLow" select="'d'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'E'"/>
										<xsl:with-param name="letterLow" select="'e'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'F'"/>
										<xsl:with-param name="letterLow" select="'f'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'G'"/>
										<xsl:with-param name="letterLow" select="'g'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'H'"/>
										<xsl:with-param name="letterLow" select="'h'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'I'"/>
										<xsl:with-param name="letterLow" select="'i'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'J'"/>
										<xsl:with-param name="letterLow" select="'j'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'K'"/>
										<xsl:with-param name="letterLow" select="'k'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'L'"/>
										<xsl:with-param name="letterLow" select="'l'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'M'"/>
										<xsl:with-param name="letterLow" select="'m'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'N'"/>
										<xsl:with-param name="letterLow" select="'n'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'O'"/>
										<xsl:with-param name="letterLow" select="'o'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'P'"/>
										<xsl:with-param name="letterLow" select="'p'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'Q'"/>
										<xsl:with-param name="letterLow" select="'q'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'R'"/>
										<xsl:with-param name="letterLow" select="'r'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'S'"/>
										<xsl:with-param name="letterLow" select="'s'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'T'"/>
										<xsl:with-param name="letterLow" select="'t'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'U'"/>
										<xsl:with-param name="letterLow" select="'u'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'V'"/>
										<xsl:with-param name="letterLow" select="'v'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'W'"/>
										<xsl:with-param name="letterLow" select="'w'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'X'"/>
										<xsl:with-param name="letterLow" select="'x'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'Y'"/>
										<xsl:with-param name="letterLow" select="'y'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'Z'"/>
										<xsl:with-param name="letterLow" select="'z'"/>
									</xsl:call-template>


									<a id="section_number"/>

									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'0'"/>
										<xsl:with-param name="letterLow" select="'0'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'1'"/>
										<xsl:with-param name="letterLow" select="'1'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'2'"/>
										<xsl:with-param name="letterLow" select="'2'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'3'"/>
										<xsl:with-param name="letterLow" select="'3'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'4'"/>
										<xsl:with-param name="letterLow" select="'4'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'5'"/>
										<xsl:with-param name="letterLow" select="'5'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'6'"/>
										<xsl:with-param name="letterLow" select="'6'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'7'"/>
										<xsl:with-param name="letterLow" select="'7'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'8'"/>
										<xsl:with-param name="letterLow" select="'8'"/>
									</xsl:call-template>


									<xsl:call-template name="Index">
										<xsl:with-param name="letterCap" select="'9'"/>
										<xsl:with-param name="letterLow" select="'9'"/>
									</xsl:call-template>

								</div>
							</div>
							<div class="clear"/>
						</div>
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Index">
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

		<xsl:variable name="appList" select="/node()/simple_instance[(type = 'Application') and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
		<xsl:choose>
			<xsl:when test="count($appList) > 0">
				<xsl:apply-templates select="$appList" mode="Applications">
					<xsl:with-param name="appLetterCap" select="$letterCap"/>
					<xsl:with-param name="appLetterLow" select="$letterLow"/>
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
				<div class="jumpToTopLink">
					<a href="#top" class="topLink">
						<xsl:value-of select="eas:i18n('Back to Top')"/>
					</a>
				</div>
				<hr/>
				<div class="clear"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="orphanApps" select="/node()/simple_instance[(type = 'Application_Provider') and (not(count(own_slot_value[slot_reference = 'type_of_application']/value) > 0)) and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
				<xsl:if test="count($orphanApps) > 0">
					<h3><xsl:value-of select="eas:i18n('Others')"/> (<xsl:value-of select="eas:i18n('No Parent Application')"/>)</h3>
					<div class="app_providers">
						<ul>
							<xsl:apply-templates select="$orphanApps" mode="Application_Providers">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</div>
					<div class="jumpToTopLink">
						<a href="#top" class="topLink">
							<xsl:value-of select="eas:i18n('Back to Top')"/>
						</a>
					</div>
					<hr/>
					<div class="clear"/>
				</xsl:if>
				<xsl:if test="count($orphanApps) = 0">
					<div class="jumpToTopLink">
						<a href="#top" class="topLink">
							<xsl:value-of select="eas:i18n('Back to Top')"/>
						</a>
					</div>
					<hr/>
					<div class="clear"/>

				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<!-- APPLICATIONS END HERE -->
	</xsl:template>

	<xsl:template match="node()" mode="Applications">
		<xsl:param name="appLetterCap"/>
		<xsl:param name="appLetterLow"/>
		<xsl:variable name="thisone">
			<xsl:value-of select="name"/>
		</xsl:variable>

		<xsl:variable name="infoid">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>

		<h3>
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</h3>
		<div class="app_providers">
			<ul>
				<xsl:apply-templates select="/node()/simple_instance[(type = 'Application_Provider') and (own_slot_value[slot_reference = 'type_of_application']/value = $thisone)]" mode="Application_Providers">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
		</div>


		<!-- ADD ANY ADDITIONAL ORPHANED APP PROVIDERS -->
		<h3><xsl:value-of select="eas:i18n('Others')"/> (<xsl:value-of select="eas:i18n('No Parent Application')"/>)</h3>
		<div class="app_providers">
			<ul>
				<xsl:apply-templates select="/node()/simple_instance[(type = 'Application_Provider') and (not(count(own_slot_value[slot_reference = 'type_of_application']/value) > 0)) and ((starts-with(own_slot_value[slot_reference = 'name']/value, $appLetterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $appLetterLow)))]" mode="Application_Providers">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
		</div>

	</xsl:template>

	<xsl:template match="node()" mode="Application_Providers">
		<xsl:variable name="thisAP">
			<xsl:value-of select="name"/>
		</xsl:variable>
		<xsl:variable name="ap_name">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<!--<xsl:variable name="xurl">
				<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text><xsl:value-of select="$thisAP"/><xsl:text>&amp;LABEL=Application Module - </xsl:text><xsl:value-of select="$ap_name"/>
			</xsl:variable>-->
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$ap_name"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="targetReport" select="$targetReport"/>
			</xsl:call-template>
			<!--<a>
				<xsl:call-template name="RenderLinkHref">
					<xsl:with-param name="theInstanceID">
						<xsl:value-of select="$thisAP" />
					</xsl:with-param>
					<xsl:with-param name="theXML" select="$reposXML" />
					<xsl:with-param name="theXSL">application/core_al_app_gap_app_dist_app.xsl</xsl:with-param>
					<xsl:with-param name="theParam4" select="$param4" />
					<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
					<xsl:with-param name="theHistoryLabel">Application Change Analysis - Application Distribution for <xsl:value-of select="$ap_name" /></xsl:with-param>
				</xsl:call-template>
				<xsl:value-of select="$ap_name" />
			</a>-->
			<!--<a>
						<xsl:attribute name="href"><xsl:value-of select="$xurl"/></xsl:attribute>
						<xsl:value-of select="$ap_name"/>
					</a>-->
		</li>
	</xsl:template>


</xsl:stylesheet>
