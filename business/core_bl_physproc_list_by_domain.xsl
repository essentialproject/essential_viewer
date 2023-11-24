<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>



	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Domain', 'Business_Process', 'Physical_Process', 'Group_Actor')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="allBusDomains" select="/node()/simple_instance[type = 'Business_Domain']"/>
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="allBusWorkflows" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allPhysicalWorkflows" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<!--<xsl:variable name="rootDomain" select="$allBusDomains[count(own_slot_value[slot_reference='contained_business_domains']/value) > 0]" />
	<xsl:variable name="parentBusDomains" select="$allBusDomains[not($subDomains/own_slot_value[slot_reference='contained_business_domains']/value)]" />
	<xsl:variable name="subDomains" select="$allBusDomains[name = $rootDomain/own_slot_value[slot_reference='contained_business_domains']/value]" />-->
	<xsl:variable name="rootDomain" select="$allBusDomains[count(own_slot_value[slot_reference = 'contained_business_domains']/value) > 0]"/>
	<xsl:variable name="parentBusDomains" select="$allBusDomains[not($subDomains/own_slot_value[slot_reference = 'contained_business_domains']/value)]"/>
	<xsl:variable name="subDomains" select="$allBusDomains[name = $rootDomain/own_slot_value[slot_reference = 'contained_business_domains']/value]"/>
	<!--<xsl:variable name="parentBusDomains" select="$allBusDomains[not($subDomains/own_slot_value[slot_reference='contained_business_domains']/value)]" />-->
	<!--<xsl:variable name="infoListByConceptCatalogue" select="/node()/simple_instance[(type='Report') and (own_slot_value[slot_reference='name']/value = 'Core: Information Catalogue by Information Concept')]"/>-->



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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- 11.03.2013 JP	Updated for Viewer 4 -->


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>
	<xsl:param name="pageLabel" select="'Physical Process Catalogue by Business Domain'"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script src="js/showhidediv.js?release=6.19" type="text/javascript"/>
				<script type="text/javascript" src="js/sitemapstyler.js?release=6.19"/>
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
				<div class="container-fluid">
					<div class="row">

						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Physical Process Catalogue by Business Domain')"/>
									</span>
								</h1>
							</div>
						</div>


						<!--Setup Catalogue Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="(string-length($targetReportId) > 0) and (string-length($targetReport/own_slot_value[slot_reference = 'report_qualifying_intro_text']/value) > 0)">
										<xsl:value-of select="$targetReport/own_slot_value[slot_reference = 'report_qualifying_intro_text']/value"/>
									</xsl:when>
									<xsl:otherwise><xsl:value-of select="eas:i18n('Please click on a Physical Process below to navigate to the required view')"/>.</xsl:otherwise>
								</xsl:choose>

								<hr/>

								<!--Main Catalog Starts-->
								<xsl:choose>
									<xsl:when test="string-length($viewScopeTermIds) > 0">
										<xsl:apply-templates mode="Business_Domain" select="($allBusDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]) except $rootDomain">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates mode="Business_Domain" select="$allBusDomains except $rootDomain">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</div>


						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<!-- Template to generate the index of level 1 Business Domains -->
	<xsl:template match="node()" mode="Level1_Business_Domain">
		<xsl:variable name="containingDomains" select="$allBusDomains[own_slot_value[slot_reference = 'contained_business_domains']/value = current()/name]"/>
		<xsl:if test="count($containingDomains) = 0">
			<xsl:variable name="SubDomains" select="$subDomains[name = current()/own_slot_value[slot_reference = 'contained_business_domains']/value]"/>
			<xsl:variable name="levellDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<li>
				<!--<a class="text-default">
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="$levellDomainName" />
					</xsl:attribute>
					<xsl:value-of select="$levellDomainName" />
					</a>-->
				<a class="text-default noUL">
					<xsl:value-of select="eas:i18n('Click to view Business Domains')"/>
				</a>
				<xsl:choose>
					<xsl:when test="count($SubDomains) > 0">
						<ul>
							<xsl:apply-templates mode="Sub_Business_Domain" select="$SubDomains">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</xsl:when>
				</xsl:choose>
			</li>
		</xsl:if>
	</xsl:template>

	<!-- Template to generate the index of Sub Business Domains -->
	<xsl:template match="simple_instance" mode="Sub_Business_Domain">
		<xsl:variable name="SubDomains" select="$allBusDomains[name = current()/own_slot_value[slot_reference = 'contained_business_domains']/value]"/>
		<xsl:variable name="levellDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="SubDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<li>
			<a class="text-default">
				<xsl:attribute name="href">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="$SubDomainName"/>
				</xsl:attribute>
				<xsl:value-of select="$SubDomainName"/>
			</a>
			<xsl:choose>
				<xsl:when test="count($SubDomains) > 0">
					<ul>
						<xsl:apply-templates mode="Sub_Business_Domain" select="$SubDomains">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</ul>
				</xsl:when>
			</xsl:choose>
		</li>
	</xsl:template>

	<!-- Template to generate the Information associated with a Business Domain -->
	<xsl:template match="simple_instance" mode="Business_Domain">
		<xsl:variable name="busDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<div class="text-secondary">
			<h2 class="text-primary">
				<a class="text-secondary">
					<xsl:attribute name="name">
						<xsl:value-of select="$busDomainName"/>
					</xsl:attribute>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<!--<xsl:with-param name="targetMenu" select="$targetMenu"/>
							<xsl:with-param name="targetReport" select="$targetReport"/>-->
					</xsl:call-template>
					<!--<xsl:value-of select="$busDomainName" />-->
				</a>
			</h2>
		</div>
		<xsl:variable name="busCaps" select="$allBusCaps[own_slot_value[slot_reference = 'belongs_to_business_domain']/value = current()/name]"/>
		<xsl:variable name="busWorkflows" select="$allBusWorkflows[own_slot_value[slot_reference = 'realises_business_capability']/value = $busCaps/name]"/>
		<xsl:variable name="physicalWorkflows" select="$allPhysicalWorkflows[own_slot_value[slot_reference = 'implements_business_process']/value = $busWorkflows/name]"/>
		<xsl:choose>
			<xsl:when test="count($physicalWorkflows) > 0">
				<div class="largeThinRoundedBox_FullWidth">
					<h3>
						<xsl:value-of select="eas:i18n('Physical Processes')"/>
					</h3>
					<p>
						<xsl:value-of select="eas:i18n('The following physical processes are performed within the domain of')"/>&#160;<xsl:value-of select="$busDomainName"/>
					</p>

					<div class="ShowHideDivTrigger ShowHideDivOpen">
						<a class="ShowHideDivLink small text-darkgrey" href="#">
							<xsl:value-of select="eas:i18n('Show/Hide Physical Processes')"/>
						</a>
					</div>
					<div class="hiddenDiv">
						<div class="verticalSpacer_10px"/>
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th class="cellWidth-30pc">
										<xsl:value-of select="eas:i18n('Process Name')"/>
									</th>
									<th class="cellWidth-40pc">
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
									<th class="cellWidth-30pc">
										<xsl:value-of select="eas:i18n('Performed By')"/>
									</th>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates mode="Physical_Workflow" select="$physicalWorkflows">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</tbody>
						</table>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<em class="small">
					<xsl:value-of select="eas:i18n('No physical processes captured for this business domain')"/>
				</em>
				<div class="verticalSpacer_10px"/>
			</xsl:otherwise>
		</xsl:choose>

		<div class="small">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
	</xsl:template>



	<!-- Template to generate the details for an Information Object -->
	<xsl:template match="simple_instance" mode="Physical_Workflow">

		<xsl:variable name="logicalProc" select="$allBusWorkflows[name = current()/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="logicalProcName" select="$logicalProc/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="logicalProcDesc" select="$logicalProc/own_slot_value[slot_reference = 'description']/value"/>

		<xsl:variable name="procActor2Role" select="$allActor2Roles[name = current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="procActor" select="$allGroupActors[name = $procActor2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<tr class="SectionTableHeaderRow">
			<tr>
				<td class="strong">
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="targetMenu" select="$targetMenu"/>
						<xsl:with-param name="targetReport" select="$targetReport"/>
						<xsl:with-param name="displayString" select="$logicalProcName"/>
					</xsl:call-template>
				</td>
				<td>
					<xsl:value-of select="$logicalProcDesc"/>
				</td>
				<td>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$procActor"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</td>
			</tr>
		</tr>
	</xsl:template>



</xsl:stylesheet>
