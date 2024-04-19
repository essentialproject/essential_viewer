<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html"/>

	<!--<xsl:include href="core_bus_process_To_AppSvcByBusCap.xsl" />-->
	<xsl:param name="param1"/>
	<xsl:param name="param2"/>
	<xsl:variable name="currentDomain" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="domainName" select="$currentDomain/own_slot_value[slot_reference = 'name']/value"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Service', 'Application_Provider', 'Supplier', 'Technology_Component', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="inScopeBusCaps" select="$allBusinessCaps[own_slot_value[slot_reference = ('belongs_to_business_domain','belongs_to_business_domains')]/value = $currentDomain/name]"/>
	<xsl:variable name="allInScopeBusCaps" select="eas:get_object_descendants($inScopeBusCaps, $allBusinessCaps, 0, 6, 'supports_business_capabilities')"/>
	<xsl:variable name="inScopeBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allInScopeBusCaps/name]"/>
	<xsl:variable name="inScopeBusProcs2AppSvcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $inScopeBusProcs/name]"/>
	<xsl:variable name="inScopeAppSvcs" select="/node()/simple_instance[name = $inScopeBusProcs2AppSvcs/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/>
	<xsl:variable name="inScopeAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $inScopeAppSvcs/name]"/>
	<xsl:variable name="inScopeApps" select="/node()/simple_instance[name = $inScopeAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="inScopeSuppliers" select="/node()/simple_instance[name = $inScopeApps/own_slot_value[slot_reference = 'ap_supplier']/value]"/>

	<xsl:variable name="inScopeAppDeployments" select="/node()/simple_instance[name = $inScopeApps/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
	<xsl:variable name="inScopeTechBuilds" select="/node()/simple_instance[name = $inScopeAppDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
	<xsl:variable name="inScopeTechArchs" select="/node()/simple_instance[name = $inScopeTechBuilds/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
	<xsl:variable name="inScopeTechProdRoleUsages" select="/node()/simple_instance[(type = 'Technology_Provider_Usage') and (name = $inScopeTechArchs/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
	<xsl:variable name="platformTechProdRoles" select="/node()/simple_instance[name = $inScopeTechProdRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
	<xsl:variable name="platformTechProds" select="/node()/simple_instance[name = $platformTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="platformTechProdSuppliers" select="/node()/simple_instance[name = $platformTechProds/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="platformTechComponents" select="/node()/simple_instance[name = $platformTechProdRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>

	<xsl:variable name="InScopeSWArchs" select="/node()/simple_instance[name = $inScopeApps/own_slot_value[slot_reference = 'has_software_architecture']/value]"/>
	<xsl:variable name="InScopeSWArchElements" select="/node()/simple_instance[(type = 'Software_Component_Usage') and (name = $InScopeSWArchs/own_slot_value[slot_reference = 'logical_software_arch_elements']/value)]"/>
	<xsl:variable name="InScopeSWComps" select="/node()/simple_instance[name = $InScopeSWArchElements/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>
	<xsl:variable name="swTechProdRoles" select="/node()/simple_instance[name = $InScopeSWComps/own_slot_value[slot_reference = ('software_from_tech_prod_role', 'software_runtime_technology')]/value]"/>
	<xsl:variable name="swTechProds" select="/node()/simple_instance[name = $swTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="swTechProdSuppliers" select="/node()/simple_instance[name = $swTechProds/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="swTechComponents" select="/node()/simple_instance[name = $swTechProdRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>

	<xsl:variable name="inScopeTechProdRoles" select="($platformTechProdRoles union $swTechProdRoles)"/>
	<xsl:variable name="inScopeTechProds" select="($platformTechProds union $swTechProds)"/>
	<xsl:variable name="inScopeTechProdSuppliers" select="($platformTechProdSuppliers union $swTechProdSuppliers)"/>
	<xsl:variable name="inScopeTechComponents" select="($platformTechComponents union $swTechComponents)"/>


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
	<!-- 08.03.2013 JWC Updated to use Application Provider Roles -->
	<!-- 12.05.2016 JP Refactored to simplify code and address bug in business capability row span calculation -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Application Services Supporting Business Capability Analysis')"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>

			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">

						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Supporting Application Analysis for Business Domain')"/>: <span class="text-primary"><xsl:value-of select="$domainName"/></span></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-question-circle icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Services Supporting Business Capability Analysis')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($inScopeBusCaps) > 0">
										<p><xsl:value-of select="eas:i18n('The following tables describe the Business Capabilities that are mapped to this business area, the Application Services that support each capability and the applications that are being used to implement the each service. Information about the supplier and the technology products used is also shown')"/>. </p>
										<xsl:apply-templates select="$currentDomain" mode="Page_Body"/>
									</xsl:when>
									<xsl:otherwise>
										<em>No business capabilities mapped to the <xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$currentDomain"/></xsl:call-template> business domain</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>

		</html>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template match="node()" mode="Page_Body">

		<!-- Find all the capabilities mapped to this domain -->

		<table class="table table-bordered">
			<tr>
				<th class="cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Business Capability')"/>
				</th>
				<th class="cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Application Service')"/>
				</th>
				<th class="cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Implementing Applications')"/>
				</th>
				<th class="cellWidth-15pc">
					<xsl:value-of select="eas:i18n('Application Supplier')"/>
				</th>
				<th class="cellWidth-25pc">
					<xsl:value-of select="eas:i18n('Supporting Technology Products')"/>
				</th>
			</tr>
			<!-- Create the main table of capability duplication -->
			<xsl:apply-templates mode="busCapAppSvc_Page_Body" select="$inScopeBusCaps">
				<xsl:with-param name="showEmpty" select="$param2"/>
				<xsl:with-param name="callingXSLFile">business/core_bus_cap_appSvc_analysis_by_BusDomain.xsl</xsl:with-param>
				<xsl:with-param name="calledParam" select="$param1"/>
				<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>

			</xsl:apply-templates>
		</table>


	</xsl:template>

	<xsl:template match="node()" mode="busCapAppSvc_Page_Body">
		<!-- Parameter to control whether empty capabilities are displayed -->
		<xsl:param name="showEmpty"/>
		<xsl:param name="callingXSLFile"/>
		<xsl:param name="calledParam"/>


		<xsl:variable name="currentBusCap" select="current()"/>
		<xsl:variable name="currentBusCapDescendants" select="eas:get_object_descendants($currentBusCap, $allInScopeBusCaps, 0, 6, 'supports_business_capabilities')"/>

		<xsl:variable name="impl_busproc_list" select="$inScopeBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentBusCapDescendants/name]"/>
		<!-- Get the list of Application Services supporting each process -->


		<!-- 12.05.2016 JP Refactored to simplify queries -->
		<xsl:variable name="appSvcProRels" select="$inScopeBusProcs2AppSvcs[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $impl_busproc_list/name]"/>
		<xsl:variable name="appSvcs" select="$inScopeAppSvcs[name = $appSvcProRels/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/>
		<xsl:variable name="appProRoles" select="$inScopeAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $appSvcs/name]"/>

		<xsl:variable name="busCapRowspan" select="eas:get_buscap_row_count($appSvcs, $appProRoles, 0)"/>

		<xsl:choose>
			<xsl:when test="count($appSvcs) > 0">
				<tr>
					<td>
						<xsl:attribute name="rowspan">
							<xsl:value-of select="max(($busCapRowspan, 1))"/>
						</xsl:attribute>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
						<br/>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
					<xsl:apply-templates select="$appSvcs" mode="Implementing_Application_Service">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					</xsl:apply-templates>
				</tr>
			</xsl:when>
			<xsl:when test="($showEmpty = 'true') and (count($appSvcs) = 0)">
				<tr>
					<td>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
						<br/>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
					<xsl:apply-templates select="$appSvcs" mode="Implementing_Application_Service">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					</xsl:apply-templates>
				</tr>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


	<!-- TEMPLATE TO CREATE THE  DETAILS OF AN IMPLEMENTING APPLICATION -->
	<xsl:template match="node()" mode="Implementing_Application_Service">

		<!-- Calculate rowspan from number of Application Providers -->

		<!-- Get the set of Application Providers -->
		<!-- 08.03.2013 JWC - Use Application Provider Roles -->
		<xsl:variable name="appProvRoleIDs" select="own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
		<xsl:variable name="appProvRoles" select="$inScopeAppProRoles[name = $appProvRoleIDs]"/>
		<xsl:variable name="app_ProvIDs" select="$appProvRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
		<xsl:variable name="app_Provs" select="$inScopeApps[name = $app_ProvIDs]"/>
		<!-- 08.03.2013 JWC end -->
		<xsl:variable name="prov_list_size" select="count($app_Provs)"/>
		<xsl:if test="position() &gt; 1">
			<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
		</xsl:if>
		<!-- Application Service-->
		<xsl:choose>
			<xsl:when test="$prov_list_size = 0">
				<td>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</td>
				<td>-</td>
				<td>-</td>
				<td>-</td>
				<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<td>
					<xsl:if test="$prov_list_size > 0">
						<xsl:attribute name="rowspan">
							<xsl:value-of select="$prov_list_size"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="not(string(own_slot_value[slot_reference = 'name']/value))">-</xsl:if>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</td>
				<xsl:for-each select="$app_Provs">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:variable name="appProvInst" select="."/>
					<xsl:if test="not(position() = 1)">
						<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
					</xsl:if>
					<td>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
						<xsl:if test="current()/own_slot_value[slot_reference = 'synonyms']"><br/>
							
							<span style="font-size:0.9em">
							 (aka <xsl:for-each select="current()/own_slot_value[slot_reference = 'synonyms']/value">
								<xsl:variable name="this" select="."/>
							
								<xsl:variable name="thisSyn" select="/node()/simple_instance[type='Synonym'][name=$this]"/>
								 
								<xsl:value-of select="$thisSyn/own_slot_value[slot_reference = 'name']/value"/><xsl:if test="position()!=last()">, </xsl:if>
								</xsl:for-each>)
								</span>
						</xsl:if>
					</td>

					<!-- Vendor -->
					<xsl:variable name="supplier" select="$inScopeSuppliers[name = current()/own_slot_value[slot_reference = 'ap_supplier']/value]"/>
					<td>
						<xsl:if test="not(string($supplier))">
							<em>No information</em>
						</xsl:if>

						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$supplier"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>

					<xsl:variable name="appDeployments" select="$inScopeAppDeployments[name = $appProvInst/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
					<xsl:variable name="techBuilds" select="$inScopeTechBuilds[name = $appDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
					<xsl:variable name="techArchs" select="$inScopeTechArchs[name = $techBuilds/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
					<xsl:variable name="techProdRoleUsages" select="$inScopeTechProdRoleUsages[(type = 'Technology_Provider_Usage') and (name = $techArchs/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
					<xsl:variable name="techProdRoles" select="$inScopeTechProdRoles[name = $techProdRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
					<xsl:variable name="techProds" select="$inScopeTechProds[name = $techProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>

					<xsl:variable name="swArch" select="$InScopeSWArchs[name = $appProvInst/own_slot_value[slot_reference = 'has_software_architecture']/value]"/>
					<xsl:variable name="swArchElements" select="$InScopeSWArchElements[name = $swArch/own_slot_value[slot_reference = 'logical_software_arch_elements']/value]"/>
					<xsl:variable name="swComps" select="$InScopeSWComps[name = $swArchElements/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>
					<xsl:variable name="thisSWTechProdRoles" select="$swTechProdRoles[name = $swComps/own_slot_value[slot_reference = ('software_from_tech_prod_role', 'software_runtime_technology')]/value]"/>
					<xsl:variable name="thisSWTechProds" select="$swTechProds[name = $thisSWTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
					<xsl:variable name="allThisTechProds" select="$techProds union $thisSWTechProds"/>
					<xsl:variable name="allThisTechProdRoles" select="$techProdRoles union $thisSWTechProdRoles"/>

					<td>
						<xsl:if test="count($allThisTechProds) = 0">
							<em>No information</em>
						</xsl:if>
						<ul>
							<xsl:apply-templates mode="RenderAppTechProducts" select="$allThisTechProds">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								<xsl:with-param name="techProdRoles" select="($allThisTechProdRoles)"/>
							</xsl:apply-templates>
						</ul>
					</td>

					<xsl:if test="not(position() = last())">
						<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<!-- Template to list the Technology Products that support an application provider -->
	<xsl:template match="node()" mode="RenderAppTechProducts">
		<xsl:param name="techProdRoles"/>

		<xsl:variable name="thisTechProdRoles" select="$techProdRoles[own_slot_value[slot_reference = 'role_for_technology_provider']/value = current()/name]"/>
		<xsl:variable name="techComponents" select="$inScopeTechComponents[(name = $thisTechProdRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value)]"/>
		<xsl:variable name="techProdSupplier" select="$inScopeTechProdSuppliers[name = current()/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<li>
			<xsl:if test="count($techProdSupplier) > 0">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$techProdSupplier"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>&#160;</xsl:if>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
			<xsl:text> (</xsl:text>
			<xsl:for-each select="$techComponents">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
				<xsl:if test="not(position() = last())">, </xsl:if>
			</xsl:for-each>
			<xsl:text>)</xsl:text>
		</li>
	</xsl:template>


	<xsl:function name="eas:get_buscap_row_count" as="xs:integer">
		<xsl:param name="appSvcs"/>
		<xsl:param name="appProRoles"/>
		<xsl:param name="appTotal"/>

		<xsl:choose>
			<xsl:when test="count($appSvcs) > 0">
				<xsl:variable name="nextAppSvc" select="$appSvcs[1]"/>
				<xsl:variable name="nextAppProRole" select="$appProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $nextAppSvc/name]"/>
				<xsl:variable name="newAppSvcList" select="remove($appSvcs, 1)"/>
				<xsl:variable name="apps" select="$inScopeApps[name = $nextAppProRole/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
				<xsl:variable name="appCount" select="max((1, count($apps)))"/>
				<xsl:value-of select="eas:get_buscap_row_count($newAppSvcList, $appProRoles, $appTotal + $appCount)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number($appTotal)"/>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:function>

</xsl:stylesheet>
