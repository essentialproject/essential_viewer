<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Capability', 'Application_Service', 'Application_Provider', 'Supplier', 'Technology_Component', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:param name="param2"/>
	<xsl:variable name="currentCapability" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="capabilityName" select="$currentCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="inScopeAppSvcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $currentCapability/name]"/>
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
	<!-- 05.11.2008 JWC	Upgraded to XSL v2 and imported edits from live reports -->
	<!-- 06.11.2008	JWC Repaired location of the Page History box -->

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Application Diversity and Duplication Analysis')"/>
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
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Diversity and Duplication Analysis')"/>&#160;<xsl:value-of select="eas:i18n('for')"/>&#160;<span class="text-primary"><xsl:value-of select="$capabilityName"/></span></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Diversity and Duplication Analysis')"/>
							</h2>
							<div class="content-section">
								<xsl:variable name="impl_appsvc_list" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $currentCapability/name]"/>

								<xsl:choose>
									<xsl:when test="count($impl_appsvc_list) = 0">
										<p>
											<em>No Application Services defined for this Capability</em>
										</p>
									</xsl:when>
									<xsl:otherwise>
										<p><xsl:value-of select="eas:i18n('The following table describes the Application Services that are defined for this Capability and the applications that are being used to implement the each service along with the technology products that are used to deliver the application')"/>. </p>
										<xsl:apply-templates select="$currentCapability" mode="Page_Body"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
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
		<!-- Get the name of the application capability -->
		<xsl:variable name="capabilityName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>

		<table class="table table-bordered table-striped">
			<xsl:apply-templates mode="appDiversity_Page_Body" select="$currentCapability">
				<xsl:with-param name="showEmpty" select="$param2"/>
				<xsl:with-param name="calledParam" select="$param1"/>
			</xsl:apply-templates>
		</table>

	</xsl:template>

	<xsl:template match="node()" mode="appDiversity_Page_Body">
		<!-- Parameter to control whether empty capabilities are displayed -->
		<xsl:param name="showEmpty"/>
		<xsl:param name="calledParam"/>
		<!-- Get the name of the application capability -->
		<xsl:variable name="capabilityName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<xsl:variable name="capability" select="name"/>
		<xsl:variable name="capCount" select="position()"/>
		<xsl:if test="position() = 1">
			<thead>
				<tr>
					<th class="cellWidth-25pc">
						<xsl:value-of select="eas:i18n('Application Capability')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Application Services')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Implementing Applications')"/>
					</th>
					<th class="cellWidth-15pc">
						<xsl:value-of select="eas:i18n('Supplier')"/>
					</th>
					<th class="cellWidth-20pc"><xsl:value-of select="eas:i18n('Product Name')"/> (<xsl:value-of select="eas:i18n('Technology')"/>)</th>
				</tr>
			</thead>
		</xsl:if>
		<xsl:variable name="impl_appsvc_list" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $capability]"/>
		<xsl:if test="count($impl_appsvc_list) > 0">
			<tbody>
				<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
				<!-- Capability heading -->
				<!-- Find number of rows to span -->
				<!-- 26.08.2011 JWC Updated to support Application Provider Roles -->
				<!-- Original code
					<xsl:variable name="app_Provs" select="$impl_appsvc_list/own_slot_value[slot_reference='provided_by_application_provider']/value"></xsl:variable>
				-->
				<xsl:variable name="appProvRoles" select="/node()/simple_instance[name = $impl_appsvc_list/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value]"/>
				<!-- From this list, find all the Application Providers -->
				<xsl:variable name="app_Provs" select="/node()/simple_instance[name = $appProvRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
				<xsl:variable name="prov_list_size" select="count($app_Provs)"/>
				<td>
					<xsl:if test="$prov_list_size > 0">
						<xsl:attribute name="rowspan">
							<xsl:value-of select="count($appProvRoles)"/>
						</xsl:attribute>
					</xsl:if>
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
				<xsl:apply-templates select="$impl_appsvc_list" mode="Implementing_Application_Service"> </xsl:apply-templates>
				<xsl:if test="position() &lt; last()">
					<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
				</xsl:if>
			</tbody>

		</xsl:if>
		<xsl:if test="($showEmpty = 'true') and (not(count($impl_appsvc_list) > 0))">
			<xsl:if test="position() > 1">
				<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
			</xsl:if>
			<!-- Capability heading -->
			<!-- Find number of rows to span -->
			<xsl:variable name="appProvRoles" select="/node()/simple_instance[name = $impl_appsvc_list/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value]"/>
			<!-- From this list, find all the Application Providers -->
			<xsl:variable name="app_Provs" select="/node()/simple_instance[name = $appProvRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
			<xsl:variable name="prov_list_size" select="count($app_Provs)"/>
			<td>
				<xsl:if test="$prov_list_size > 0">
					<xsl:attribute name="rowspan">
						<xsl:value-of select="$prov_list_size"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<xsl:if test="not(count($impl_appsvc_list) > 0)">
					<td>
						<xsl:value-of select="eas:i18n('No Application Services defined for this Capability')"/>
					</td>
				</xsl:if>
			</td>
			<xsl:apply-templates select="$impl_appsvc_list" mode="Implementing_Application_Service"> </xsl:apply-templates>
		</xsl:if>
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



	<!-- TEMPLATE TO CREATE THE  DETAILS OF AN IMPLEMENTING APPLICATION -->
	<!--<xsl:template match="node()" mode="Implementing_Application_Service">
		<!-\- 26.08.2011 JWC Updated to support Application Provider Roles -\->
		<!-\- Original code
			<xsl:variable name="app_Provs" select="own_slot_value[slot_reference='provided_by_application_provider']/value"></xsl:variable>            
		-\->
		<!-\- Find all the Application Provider Roles for the Services -\->
		<xsl:variable name="appProvRoles" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference='provided_by_application_provider_roles']/value]"/>
		<!-\- From this list, find all the Application Providers -\->
		<xsl:variable name="app_Provs" select="/node()/simple_instance[name = $appProvRoles/own_slot_value[slot_reference='role_for_application_provider']/value]"/>
		<xsl:variable name="prov_list_size" select="count($app_Provs)"/>
		<xsl:if test="position() > 1">
			<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
		</xsl:if>
		<!-\- Application Service -\->
		<td>
			<xsl:if test="$prov_list_size > 0">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="$prov_list_size"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(string(own_slot_value[slot_reference='name']/value))">-</xsl:if>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</td>
		<!-\-Application Providers -\->
		<xsl:if test="not(count($app_Provs) > 0)">
			<td>-</td>
			<td>-</td>
			<td>-</td>
			<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
		</xsl:if>
		<xsl:for-each select="$app_Provs">
			<xsl:variable name="appProvInst" select="."/>
			<xsl:variable name="ap_name" select="/node()/simple_instance[name=$appProvInst]/own_slot_value[slot_reference='name']/value"/>
			<xsl:if test="position() > 1">
				<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
			</xsl:if>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<!-\- Vendor -\->
			<xsl:variable name="supplier" select="/node()/simple_instance[name=$appProvInst/own_slot_value[slot_reference='ap_supplier']/value]"/>
			<td>
				<xsl:if test="not(string($supplier))">
					<span>-</span>
				</xsl:if>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$supplier"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<!-\- Product supporting this = software architecture -\->
			<xsl:variable name="swArch" select="/node()/simple_instance[name=$appProvInst/own_slot_value[slot_reference='has_software_architecture']/value]"/>
			<td>
				<xsl:if test="count($swArch) = 0">
					<span>-</span>
				</xsl:if>
				<xsl:apply-templates mode="softwareArchitecture" select="$swArch"/>
			</td>
			<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
		</xsl:for-each>
	</xsl:template>


	<!-\- Template to find all the software components used in a Provider's software architecture
		and print out the Technology Product used for each component-\->
	<xsl:template match="node()" mode="softwareArchitecture">
		<!-\- Find all the component usages in the architecture -\->
		<xsl:variable name="swArchElements" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='logical_software_arch_elements']/value]"/>

		<xsl:if test="count($swArchElements) = 0">
			<em>-</em>
		</xsl:if>

		<!-\- Explore each element in the s/w architecture -\->
		<!-\- Get all the Software Components that are used and group them LOOK AT THIS.... -\->
		<xsl:variable name="softCompInst" select="/node()/simple_instance[name=$swArchElements/own_slot_value[slot_reference='usage_of_software_component']/value]"/>
		<!-\-<xsl:variable name="softCompInst" select="/node()/simple_instance[name=$softComps]" />-\->

		<!-\- Create a group and select unique values -\->
		<!-\- Pass these to the Tech Product Role template -\->
		<!-\- 13.11.2008    JWC Added handling of new slot in Software Component -\->
		<!-\- Look for software_from_tech_prod_role instances first -\->
		<ul>
			<xsl:for-each-group select="$softCompInst" group-by="own_slot_value[slot_reference='software_from_tech_prod_role']/value">
				<xsl:variable name="fromTechProd" select="current-group()[1]/own_slot_value[slot_reference='software_from_tech_prod_role']/value"/>
				<!-\-<img src="images/green.png" width="5" height="5"/>&#160; <xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name=$fromTechProd]"/>
			<br/>-\->
				<li>
					<xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name=$fromTechProd]"/>
				</li>
			</xsl:for-each-group>
			<xsl:for-each-group select="$softCompInst" group-by="own_slot_value[slot_reference='software_runtime_technology' or slot_reference='software_from_tech_prod_role']/value">
				<xsl:variable name="techProdRole" select="current-group()[1]/own_slot_value[slot_reference='software_runtime_technology']/value"/>
				<!-\-<img src="images/green.png" width="5" height="5"/>&#160; <xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name=$techProdRole]"/>
			<br/>-\->
				<li>
					<xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name=$techProdRole]"/>
				</li>
			</xsl:for-each-group>
		</ul>
	</xsl:template>

	<!-\- Template to render the Technology Product that is the runtime technology for the specified
		Software Component-\->
	<xsl:template match="node()" mode="technologyProductRole">
		<!-\- Find the runtime technology -\->
		<xsl:variable name="techProdRole" select="/node()/simple_instance[name=current()]/own_slot_value[slot_reference='software_runtime_technology']/value"/>

		<!-\- Find that TechProdRole -\->
		<xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name=$techProdRole]"/>
	</xsl:template>

	<!-\- Render the Technology Product name -\->
	<xsl:template match="node()" mode="technologyProduct">
		<!-\- Find the technology product -\->
		<xsl:variable name="techProdInst" select="own_slot_value[slot_reference='role_for_technology_provider']/value"/>
		<xsl:variable name="techProd" select="/node()/simple_instance[name=$techProdInst]"/>
		<xsl:apply-templates select="$techProd" mode="RenderDepTechProduct"/>
	</xsl:template>

	<!-\- 19.11.2008 JWC Render a Technology Product with a link. Takes a Technology Product node -\->
	<xsl:template match="node()" mode="RenderDepTechProduct">
		<!-\- Add hyperlink to product report -\->
		<!-\- 19.11.2008 JWC Add link to definition -\->
		<xsl:variable name="techProdName" select="translate(own_slot_value[slot_reference='product_label']/value, '::', '  ')"/>
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			<xsl:with-param name="displayString" select="$techProdName"/>
		</xsl:call-template>
	</xsl:template>-->

</xsl:stylesheet>
