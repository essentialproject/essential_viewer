<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html"/>

	<!--<xsl:include href="core_bus_process_To_AppsByBusCap.xsl" />-->
	<xsl:param name="param1"/>
	<xsl:param name="param2"/>
	<xsl:variable name="currentDomain" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="domainName" select="$currentDomain/own_slot_value[slot_reference = 'name']/value"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Business_Process', 'Application_Service', 'Application_Provider', 'Supplier', 'Technology_Component', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	
	<xsl:variable name="currentDomainInst" select="$param1"/>
	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="mappedCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'belongs_to_business_domain']/value = $currentDomainInst]"/>
	<xsl:variable name="allMappedCapabilities" select="eas:get_object_descendants($mappedCapabilities, $allBusinessCaps, 0, 6, 'supports_business_capabilities')"/>
	<xsl:variable name="inScopeBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allMappedCapabilities/name]"/>

	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allPhysProc2AppProRoles" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>

    <!-- app tech variables  -->
    
    <xsl:variable name="inScopeAppDeployments" select="/node()/simple_instance[name = $allAppProviders/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
	<xsl:variable name="inScopeTechBuilds" select="/node()/simple_instance[name = $inScopeAppDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
	<xsl:variable name="inScopeTechArchs" select="/node()/simple_instance[name = $inScopeTechBuilds/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
    
    <xsl:variable name="inScopeTechProdRoleUsages" select="/node()/simple_instance[(type = 'Technology_Provider_Usage') and (name = $inScopeTechArchs/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
	<xsl:variable name="platformTechProdRoles" select="/node()/simple_instance[name = $inScopeTechProdRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
	<xsl:variable name="platformTechProds" select="/node()/simple_instance[name = $platformTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
    <xsl:variable name="InScopeSWArchs" select="/node()/simple_instance[name = $allAppProviders/own_slot_value[slot_reference = 'has_software_architecture']/value]"/>
	<xsl:variable name="InScopeSWArchElements" select="/node()/simple_instance[(type = 'Software_Component_Usage') and (name = $InScopeSWArchs/own_slot_value[slot_reference = 'logical_software_arch_elements']/value)]"/>
    <xsl:variable name="InScopeSWComps" select="/node()/simple_instance[name = $InScopeSWArchElements/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>
    <xsl:variable name="swTechProdRoles" select="/node()/simple_instance[name = $InScopeSWComps/own_slot_value[slot_reference = ('software_from_tech_prod_role', 'software_runtime_technology')]/value]"/>
	<xsl:variable name="swTechProds" select="/node()/simple_instance[name = $swTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
    <xsl:variable name="inScopeTechProdRoles" select="($platformTechProdRoles union $swTechProdRoles)"/>
    
    	<xsl:variable name="platformTechProdSuppliers" select="/node()/simple_instance[name = $platformTechProds/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="platformTechComponents" select="/node()/simple_instance[name = $platformTechProdRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
    	<xsl:variable name="swTechProdSuppliers" select="/node()/simple_instance[name = $swTechProds/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="swTechComponents" select="/node()/simple_instance[name = $swTechProdRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
    	<xsl:variable name="inScopeTechProdSuppliers" select="($platformTechProdSuppliers union $swTechProdSuppliers)"/>
	<xsl:variable name="inScopeTechComponents" select="($platformTechComponents union $swTechComponents)"/>

    
    <xsl:variable name="inScopeTechProds" select="($platformTechProds union $swTechProds)"/>
	
	<xsl:variable name="DEBUG" select="''"/>
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
	<!-- 08.03.2013 JWC	Resolved some issues with the supporting technology column -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title><xsl:value-of select="eas:i18n('Business Process Analysis for Business Domain')"/>: <xsl:value-of select="$domainName"/></title>
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
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">

						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Process Analysis for Business Domain')"/>: <span class="text-primary"><xsl:value-of select="$domainName"/></span></span>
								</h1>
							</div><xsl:value-of select="$DEBUG"/>
						</div>

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Capability to Business Process Analysis')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following table describes the Business Capabilities that are mapped to this business area, the Business Processes that realise each capability and the applications that are being used to implement the each process. Information about the supplier and the technology products used is also shown')"/>.</p>
								<xsl:apply-templates select="$currentDomain" mode="Page_Body"/>
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
		<!-- Get the name of the application capability -->
		<xsl:variable name="domainName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>


		
		<xsl:if test="count($mappedCapabilities) > 0">

			<h3><xsl:value-of select="eas:i18n('Business Domain')"/>: <xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/></h3>
			<table class="table table-bordered">
				<xsl:apply-templates mode="busProcessApp_Page_Body" select="$mappedCapabilities">
					<xsl:with-param name="showEmpty" select="$param2"/>
					<xsl:with-param name="callingXSLFile">business/core_bus_cap_analysis_by_BusDomain.xsl</xsl:with-param>
					<xsl:with-param name="calledParam" select="$param1"/>
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>

				</xsl:apply-templates>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="busProcessApp_Page_Body">
		<!-- Parameter to control whether empty capabilities are displayed -->
		<xsl:param name="showEmpty"/>
		<xsl:param name="callingXSLFile"/>
		<xsl:param name="calledParam"/>

		<!-- Get the name of the business capability -->
		<xsl:variable name="capabilityName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>

		<xsl:variable name="capability" select="current()"/>
		<xsl:variable name="currentBusCapDescendants" select="eas:get_object_descendants($capability, $allMappedCapabilities, 0, 6, 'supports_business_capabilities')"/>

		<xsl:variable name="capCount" select="position()"/>
		<xsl:if test="position() = 1">
			<tr>
				<th class="text-primary cellWidth-25pc">
					<xsl:value-of select="eas:i18n('Business Capability')"/>
				</th>
				<th class="text-primary cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Business Processes')"/>
				</th>
				<th class="text-primary cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Supporting Applications')"/>
				</th>
				<th class="text-primary cellWidth-15pc">
					<xsl:value-of select="eas:i18n('Supplier')"/>
				</th>
				<th class="text-primary cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Technology Product Name')"/>
				</th>
			</tr>
		</xsl:if>
		<xsl:variable name="impl_busproc_list" select="$inScopeBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentBusCapDescendants/name]"/>

		<xsl:if test="count($impl_busproc_list) > 0">
			<tr>
				<!-- Capability heading -->
				<!-- Find number of rows to span -->

				<!-- <xsl:variable name="prov_list_size" select="count($impl_busproc_list)"></xsl:variable>
                    -->

				<!-- Calculate rowspan from number of Application Providers -->
				<!-- Get the list of physical processes implementing each process -->
				<xsl:variable name="physProcs" select="/node()/simple_instance[name = $impl_busproc_list/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"> </xsl:variable>

				<!-- Get the set of relationships to Application Providers -->
				<!-- 06.11.2008 JWC replaced TO slot with the refactored apppro_to_physbus_to_busproc slot -->
				<xsl:variable name="appPhysProRels" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION' and own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcs/name]"/>

				<!-- Get the set of Application Providers -->
				<!-- 06.11.2008 JWC replaced the FROM slot with the refactored apppro_to_physbus_from_apppro slot -->
				<xsl:variable name="app_Provs" select="$appPhysProRels/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value"/>


				<xsl:variable name="prov_list_size" select="count($app_Provs)"/>
				<xsl:variable name="impl_proc_size" select="count($impl_busproc_list)"/>

				<xsl:variable name="rowCount">
					<xsl:value-of select="eas:get_total_rowspan_for_buscap($impl_busproc_list, 0)"/>
				</xsl:variable>


				<xsl:choose>
					<xsl:when test="$prov_list_size > $impl_proc_size">


						<!--<xsl:variable name="rowCount">
							<xsl:value-of select="$impl_proc_size + ($prov_list_size - $impl_proc_size)" />
						</xsl:variable>-->

						<td>
							<xsl:attribute name="rowspan">
								<xsl:value-of select="max((1, $rowCount))"/>
							</xsl:attribute>
							<strong>
								<!--<xsl:value-of select="$capabilityName" />-->
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
					</xsl:when>
					<xsl:otherwise>
						<!--<xsl:variable name="rowCount">
							<xsl:value-of select="$impl_proc_size" />
						</xsl:variable>-->

						<td>
							<xsl:attribute name="rowspan">
								<xsl:value-of select="max((1, $rowCount))"/>
							</xsl:attribute>
							<strong>
								<!--<xsl:value-of select="$capabilityName" />-->
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


					</xsl:otherwise>
				</xsl:choose>

				<xsl:apply-templates select="$impl_busproc_list" mode="Implementing_Business_Process"> </xsl:apply-templates>
			</tr>
		</xsl:if>
		<xsl:if test="($showEmpty = 'true') and (not(count($impl_busproc_list) > 0))">

			<tr>
				<!-- Capability heading -->
				<!-- Find number of rows to span -->
				<!-- Get the list of physical processes implementing each process -->
				<xsl:variable name="prov_list_size" select="count($impl_busproc_list)"/>

				<td>
					<xsl:if test="$prov_list_size > 0">
						<xsl:attribute name="rowspan">
							<xsl:value-of select="$prov_list_size"/>
						</xsl:attribute>
					</xsl:if>
					<strong>
						<!--<xsl:value-of select="$capabilityName" />-->
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

					<xsl:if test="not(count($impl_busproc_list) > 0)">
						<td colspan="4">
							<em>
								<xsl:value-of select="eas:i18n('No Business Processes defined for this Capability')"/>
							</em>
						</td>
					</xsl:if>
				</td>
				<xsl:apply-templates select="$impl_busproc_list" mode="Implementing_Application_Service"> </xsl:apply-templates>

			</tr>
		</xsl:if>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE  DETAILS OF AN IMPLEMENTING APPLICATION -->
	<xsl:template match="node()" mode="Implementing_Business_Process">

		<!-- Calculate rowspan from number of Application Providers -->
		<!-- Get the list of physical processes implementing each process -->
		<xsl:variable name="physProcs" select="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/>

		<!-- Get the set of relationships to Application Providers -->
		<!-- 06.11.2008 JWC replaced TO slot with the refactored apppro_to_physbus_to_busproc slot -->
		<xsl:variable name="appPhysProRels" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION' and own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcs]"/>

		<!-- Get the set of Application Providers -->
		<!-- 06.11.2008 JWC replace the FROM slot with the apppro_to_physbus_from_apppro slot -->
    
		<xsl:variable name="appProRoles" select="/node()/simple_instance[name = $appPhysProRels/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="app_Provs" select="/node()/simple_instance[name = $appProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="prov_list_size" select="count($app_Provs)"/>
    

		<!-- Business Process -->
		<td>
			<xsl:if test="$prov_list_size > 0">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="$prov_list_size"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(string(own_slot_value[slot_reference = 'name']/value))">-</xsl:if>

			<!-- This will be a hyperlink at some point soon 
                <xsl:attribute name="href"><xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_service_def.xsl&amp;PMA=</xsl:text><xsl:value-of select="name"/></xsl:attribute>
            -->
			<!-- 13.11.2008 JWC Added link to process definition -->
			<!--<xsl:variable name="logBPname" select="own_slot_value[slot_reference='name']/value" />
			<xsl:variable name="xurl">
				<xsl:text>report?XML=reportXML.xml&amp;XSL=business/core_bus_proc_def.xsl&amp;PMA=</xsl:text>
				<xsl:value-of select="name" />
				<xsl:text>&amp;LABEL=Business Process - </xsl:text>
				<xsl:value-of select="$logBPname" />
			</xsl:variable>-->
			<!--<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$xurl" />
				</xsl:attribute>
				<xsl:value-of select="$logBPname" />
			</a>-->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>

		</td>

		<!--Application Providers -->
		<xsl:if test="count($app_Provs) = 0">
			<td>-</td>
			<td>-</td>
			<td>-</td>
			<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
		</xsl:if>
		<xsl:for-each select="$app_Provs">
			<xsl:variable name="appProvInst" select="."/>
			<xsl:variable name="appProvName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
                    					<xsl:variable name="appDeployments" select="$inScopeAppDeployments[name = $appProvInst/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
					<xsl:variable name="techBuilds" select="$inScopeTechBuilds[name = $appDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
					<xsl:variable name="techArchs" select="$inScopeTechArchs[name = $techBuilds/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
					<xsl:variable name="techProdRoleUsages" select="$inScopeTechProdRoleUsages[(type = 'Technology_Provider_Usage') and (name = $techArchs/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
	<xsl:variable name="techProdRoles" select="$inScopeTechProdRoles[name = $techProdRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
        <xsl:variable name="techProds" select="$inScopeTechProds[name = $techProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>

			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
						<xsl:value-of select="$appProvInst" />
						<xsl:text>&amp;LABEL=Application Module - </xsl:text>
						<xsl:value-of select="$appProvName" />
					</xsl:attribute>
					<xsl:value-of select="$appProvName" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
<!-- Vendor -->

			<xsl:variable name="supplier" select="/node()/simple_instance[name = $appProvInst/own_slot_value[slot_reference = 'ap_supplier']/value]"/>
			<td>
				<xsl:choose>
					<xsl:when test="count($supplier) = 0">
						<em>-</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$supplier"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

			</td>
			<!-- Product supporting this = software architecture
			<xsl:variable name="swArch" select="/node()/simple_instance[name = $appProvInst/own_slot_value[slot_reference = 'has_software_architecture']/value]"/>
			<td>
				<xsl:choose>
					<xsl:when test="count($swArch) = 0">
						<em>-</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="softwareArchitecture" select="$swArch"/>
					</xsl:otherwise>
				</xsl:choose>
			</td> -->

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
			<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
		</xsl:for-each>

	</xsl:template>

	<!-- Template to find all the software components used in a Provider's software architecture
        and print out the Technology Product used for each component-->
	<xsl:template match="node()" mode="softwareArchitecture">
		<!-- Find all the component usages in the architecture -->
		<xsl:variable name="swArchElements" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'logical_software_arch_elements']/value]"/>

		<xsl:if test="count($swArchElements) = 0">
			<em>-</em>
		</xsl:if>

		<!-- Explore each element in the s/w architecture -->
		<!-- Get all the Software Components that are used and group them  -->
		<xsl:variable name="softCompInst" select="/node()/simple_instance[name = $swArchElements/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>

		<!-- Create a group and select unique values -->
		<!-- Pass these to the Tech Product Role template -->
		<!-- 13.11.2008    JWC Added handling of new slot in Software Component -->
		<!-- Look for software_from_tech_prod_role instances first -->
		<xsl:for-each-group select="$softCompInst" group-by="own_slot_value[slot_reference = 'software_from_tech_prod_role']/value">
			<xsl:variable name="fromTechProd" select="current-group()[1]/own_slot_value[slot_reference = 'software_from_tech_prod_role']/value"/>
			<img src="images/green.png" width="5" height="5"/>&#160; <xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name = $fromTechProd]"/>
			<br/>
		</xsl:for-each-group>
		<xsl:for-each-group select="$softCompInst" group-by="own_slot_value[slot_reference = 'software_runtime_technology']/value">
			<xsl:variable name="techProdRole" select="current-group()[1]/own_slot_value[slot_reference = 'software_runtime_technology']/value"/>
			<img src="images/green.png" width="5" height="5"/>&#160; <xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name = $techProdRole]"/>
			<br/>
		</xsl:for-each-group>

	</xsl:template>

	<!-- Template to render the Technology Product that is the runtime technology for the specified
        Software Component-->
	<xsl:template match="node()" mode="technologyProductRole">
		<!-- Find the runtime technology -->
		<xsl:variable name="techProdRole" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'software_runtime_technology']/value]"/>

		<!-- Find that TechProdRole -->
		<xsl:apply-templates mode="technologyProduct" select="/node()/simple_instance[name = $techProdRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	</xsl:template>

	<!-- Render the Technology Product name -->
	<xsl:template match="node()" mode="technologyProduct">
		<!-- Find the technology product -->
		<xsl:variable name="techProdInst" select="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
		<xsl:variable name="techProd" select="/node()/simple_instance[name = $techProdInst]"/>
		<xsl:apply-templates select="$techProd" mode="RenderDepTechProduct"/>
		<xsl:variable name="techComp" select="own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
		<!--<xsl:text> (</xsl:text>
		
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="$techComp" />
			<xsl:with-param name="theXML" select="$reposXML" />
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
		</xsl:call-template>
		<xsl:text>)</xsl:text>-->
	</xsl:template>

	<!-- 19.11.2008 JWC Render a Technology Product with a link. Takes a Technology Product node -->
	<xsl:template match="node()" mode="RenderDepTechProduct">
		<!-- Add hyperlink to product report -->
		<!-- 19.11.2008 JWC Add link to definition -->
		<xsl:variable name="techProdName" select="translate(own_slot_value[slot_reference = 'product_label']/value, '::', '  ')"/>
		<xsl:variable name="xurl">
			<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_prod_def.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="name"/>
			<xsl:text>&amp;LABEL=Technology Product - </xsl:text>
			<xsl:value-of select="$techProdName"/>
		</xsl:variable>

		<!--<a>
			<xsl:attribute name="href" select="$xurl" />
			<xsl:value-of select="$techProdName" />
		</a>-->
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			<xsl:with-param name="displayString" select="$techProdName"/>
		</xsl:call-template>
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


	<!-- FUNCTION TO DETERJMINE THE TOTAL NUMBER OF ROWS REQUIRED FOR A CAPABILITY -->
	<xsl:function name="eas:get_total_rowspan_for_buscap" as="xs:integer">
		<xsl:param name="capProcesses"/>
		<xsl:param name="totalRows"/>

		<xsl:choose>
			<xsl:when test="count($capProcesses) > 0">
				<xsl:variable name="currentProc" select="$capProcesses[1]"/>
				<xsl:variable name="physProcs" select="$allPhysProcs[name = $currentProc/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
				<xsl:variable name="appPhysProRels" select="$allPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcs/name]"/>
				<xsl:variable name="appProRoles" select="$allAppProRoles[name = $appPhysProRels/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
				<xsl:variable name="appProvs" select="$allAppProviders[name = $appProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
				<xsl:variable name="totalSoFar" select="$totalRows + max((1, count($appProvs)))"/>
				<xsl:value-of select="eas:get_total_rowspan_for_buscap($capProcesses except $currentProc, $totalSoFar)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="max(($totalRows, count($capProcesses)))"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

</xsl:stylesheet>
