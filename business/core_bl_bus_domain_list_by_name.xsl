<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html"/>
	<xsl:variable name="hideEmpty">false</xsl:variable>

	<!--
		* Copyright © 2008-2018 Enterprise Architecture Solutions Limited.
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
	<!-- 27.07.2018	JWC i18N version of catalogue -->



	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Domain')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- Get all of the Application Services in the repository -->
	<xsl:variable name="allBusDomains" select="/node()/simple_instance[type = 'Business_Domain']"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<!--<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name=$param4]" />
					<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference='name']/value" />-->
				<xsl:variable name="pageLabel">
					<xsl:value-of select="eas:i18n('Business Domain Catalogue by Name')"/>
				</xsl:variable>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="inScopeDomains" select="$allBusDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeDomains" select="$allBusDomains"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Domain Catalogue by Name')"/>
		</xsl:param>
		<xsl:param name="inScopeDomains"/>
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
							</div>
						</div>


						<!--Setup Description Section-->
						<div id="sectionApplicationServiceCatalogue">
							<div class="col-xs-12">
								<!--<div class="sectionIcon"><i class="fa fa-list-ul icon-section icon-color"/></div>
								<xsl:variable name="view_url">
									<xsl:text>report?XML=reportXML.xml&amp;XSL=business/busToAppSvc_bus_cap_list_by_alpha.xsl&amp;PMA2=</xsl:text>
									<xsl:value-of select="$hideEmpty" />
									<xsl:text>&amp;PMA=</xsl:text>
									<xsl:text>&amp;LABEL=Business Capability to Application Service Mapping - Alphabetical Business Domains</xsl:text>
								</xsl:variable>
								<div>
									<h2 class="text-primary">Supporting Application Services - by Business Domain <a href="{$view_url}">or Business Capability</a></h2>
								</div>


								<div>
									<xsl:variable name="allDomainsURL">
										<xsl:text>report?XML=reportXML.xml&amp;XSL=business/core_bus_cap_appSvc_analysis_by_allDomain.xsl&amp;PMA2=</xsl:text>
										<xsl:value-of select="$hideEmpty" /><xsl:text>&amp;PMA=</xsl:text><xsl:text>&amp;LABEL=Business Capability to Application Service Mapping - All Business Domains</xsl:text>
									</xsl:variable> Choose one of the Business Areas below to view the supporting application services analysis for it or <a href="{$allDomainsURL}">SELECT ALL</a>
								</div>
								<div class="clear" />
								<br />-->
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>

								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Catalogue')"/>
								</h2>

								<p><xsl:value-of select="eas:i18n('Please click on one of the Business Domains below to navigate to the required view')"/>.</p>


								<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:</div>
								<div class="AlphabetQuickJumpLinks hidden-xs">
									
									<!-- Build a list of the names of the elements to be sorted -->
									<xsl:variable name="anInFocusInstances" select="$inScopeDomains"></xsl:variable>
									
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
									<xsl:with-param name="letterLow" select="'0'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'1'"/>
									<xsl:with-param name="letterLow" select="'1'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'2'"/>
									<xsl:with-param name="letterLow" select="'2'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'3'"/>
									<xsl:with-param name="letterLow" select="'3'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'4'"/>
									<xsl:with-param name="letterLow" select="'4'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'5'"/>
									<xsl:with-param name="letterLow" select="'5'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'6'"/>
									<xsl:with-param name="letterLow" select="'6'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'7'"/>
									<xsl:with-param name="letterLow" select="'7'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'8'"/>
									<xsl:with-param name="letterLow" select="'8'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letter" select="'9'"/>
									<xsl:with-param name="letterLow" select="'9'"/>
									<xsl:with-param name="inScopeInstances" select="$inScopeDomains"/>
								</xsl:call-template>


							</div>

						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>



	<xsl:template name="Index">
		<xsl:param name="letter"/>
		<xsl:param name="letterLow"/>
		<xsl:param name="inScopeInstances"/>
		<div class="alphabetSectionHeader">
			<h2 class="text-primary">
				<xsl:value-of select="$letter"/>
			</h2>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_</xsl:text>
		<xsl:value-of select="$letter"/>
		<xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
		<!-- Business Domains START HERE -->
		<div class="catalogItems">
			<ul>
				<xsl:apply-templates select="$inScopeInstances[((starts-with(own_slot_value[slot_reference = 'name']/value, $letter)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]" mode="BusinessDomain">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
			<!-- Business Domains END HERE -->
		</div>
		<div class="jumpToTopLink">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
	</xsl:template>


	<xsl:template match="node()" mode="BusinessDomain">
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="targetMenu" select="$targetMenu"/>
				<xsl:with-param name="targetReport" select="$targetReport"/>
			</xsl:call-template>
		</li>

		<!--<xsl:variable name="xurl">
			<xsl:text>report?XML=reportXML.xml&amp;XSL=business/core_bus_cap_appSvc_analysis_by_BusDomain.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="name" />
			<xsl:text>&amp;PMA2=</xsl:text>
			<xsl:value-of select="$hideEmpty" />
			<xsl:text>&amp;LABEL=Business Capability to Application Mapping - </xsl:text>
			<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
		</xsl:variable>
		<li>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$xurl" />
				</xsl:attribute>
				<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
			</a>
		</li>-->
	</xsl:template>

	<!--<xsl:template match="node()" mode="Application_Providers">
		<xsl:variable name="thisAP">
			<xsl:value-of select="name" />
		</xsl:variable>
		<xsl:variable name="ap_name">
			<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
		</xsl:variable>
		<xsl:variable name="xurl">
			<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="$thisAP" />
			<xsl:text>&amp;LABEL=Application Provider - </xsl:text>
			<xsl:value-of select="$ap_name" />
		</xsl:variable>
		<a class="subText">
			<xsl:attribute name="href">
				<xsl:value-of select="$xurl" />
			</xsl:attribute>
			<xsl:value-of select="$ap_name" />
		</a>
	</xsl:template>-->
	
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
				<xsl:with-param name="letter" select="upper-case(current())"/>
				<xsl:with-param name="letterLow" select="lower-case(current())"/>
				<xsl:with-param name="inScopeInstances" select="$theInFocusInstances"/>
			</xsl:call-template>
			
		</xsl:for-each>
		
	</xsl:template>

</xsl:stylesheet>
