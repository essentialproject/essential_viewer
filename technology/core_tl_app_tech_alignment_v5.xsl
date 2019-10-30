<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>





	<xsl:output method="html"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="param1"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC SETUP VARIABES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<!-- END GENERIC SETUP VARIABES -->

	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="linkClasses" select="('Supplier', 'Technology_Component', 'Technology_Product', 'Technology_Capability')"/>
	<xsl:variable name="appProvNode" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appProvName" select="$appProvNode/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="strategicStatus" select="/node()/simple_instance[type = 'Lifecycle_Status' and (own_slot_value[slot_reference = 'name']/value = 'ProductionStrategic')]/name"/>
	<xsl:variable name="tacticalStatus" select="/node()/simple_instance[type = 'Lifecycle_Status' and (own_slot_value[slot_reference = 'name']/value = 'ProductionTactical')]/name"/>
	<xsl:variable name="prototypeStatus" select="/node()/simple_instance[type = 'Lifecycle_Status' and (own_slot_value[slot_reference = 'name']/value = 'PrototypeStatus')]/name"/>
	<xsl:variable name="pilotStatus" select="/node()/simple_instance[type = 'Lifecycle_Status' and (own_slot_value[slot_reference = 'name']/value = 'Pilot')]/name"/>
	<xsl:variable name="offStatus" select="/node()/simple_instance[type = 'Lifecycle_Status' and (own_slot_value[slot_reference = 'name']/value = 'OffStrategy')]/name"/>
	<!-- END VIEW SPECIFIC SETUP VARIABES -->

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Strategy Alignment')"/>
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

	<!-- 06.03.2010 JWC Implemented for IEA 2010 demo -->

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script src="js/showhidediv.js" type="text/javascript"/>
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
									<span class="text-darkgrey"><xsl:value-of select="$pageLabel"/> - <span class="text-primary"><xsl:value-of select="$appProvName"/></span></span>
								</h1>
							</div>
						</div>


						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Approved Technology Evaluation')"/>
							</h2>
							<div class="verticalSpacer_5px"/>
							<div class="content-section">
								<xsl:apply-templates select="$appProvNode" mode="Page_Body"/>
							</div>
						</div>

					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>

		</html>
	</xsl:template>

	<xsl:template match="node()" mode="Page_Body">
		<!-- Explanation of table view -->
		<!-- PROJECT TECHNOLOGY REQUIREMENTS (CAPABILITIES) START HERE -->
		<xsl:apply-templates select="/node()/simple_instance[name = $appProvNode/own_slot_value[slot_reference = 'required_technology_capabilities']/value]" mode="Requirements">
			<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:apply-templates>
		<!-- PROJECT TECHNOLOGY REQUIREMENTS (CAPABILITIES) END HERE -->
	</xsl:template>


	<!-- TEMPLATE TO CREATE EACH TECHNOLOGY CAPABILITY TABLE -->
	<xsl:template match="node()" mode="Requirements">
		<xsl:variable name="idofcap">
			<xsl:value-of select="name"/>
		</xsl:variable>
		<h3>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</h3>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th colspan="4" class="bg-black">
						<xsl:value-of select="eas:i18n('Selected Technology Platforms')"/>
					</th>
				</tr>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Product Vendor')"/>
					</th>
					<th class="cellWidth-40pc">
						<xsl:value-of select="eas:i18n('Product')"/>
					</th>
					<th class="cellWidth-25pc">
						<xsl:value-of select="eas:i18n('Usage')"/>
					</th>
					<th class="cellWidth-15pc">
						<xsl:value-of select="eas:i18n('Strategic Alignment')"/>
					</th>
				</tr>
			</thead>
			<tbody>

				<!-- SELECTED TECHNOLOGY PRODUCTS START HERE                               
               <xsl:apply-templates select="/node()/simple_instance[type='Technology_Product_Usage' and (name = /node()/simple_instance[type='Technology_Product_Architecture' and (name = /node()/simple_instance[type='Technology_Product' and (name = /node()/simple_instance[type='Project' and (name = $param1)]/own_slot_value[slot_reference='project_technology_architecture']/value)]/own_slot_value[slot_reference='technology_product_architecture']/value)]/own_slot_value[slot_reference='contained_architecture_components']/value)]" mode="Technology_Product_Usages">
                       <xsl:with-param name="capId" select="$idofcap" />
                       </xsl:apply-templates> -->
				<xsl:variable name="techCompID" select="$appProvNode/own_slot_value[slot_reference = 'implemented_with_technology']/value"/>
				<xsl:variable name="techComp" select="/node()/simple_instance[name = $techCompID]"/>
				<xsl:variable name="techProdBuildRole" select="/node()/simple_instance[name = $techComp/own_slot_value[slot_reference = 'realised_by_technology_products']/value]"/>
				<xsl:variable name="techProdBuild" select="/node()/simple_instance[name = $techProdBuildRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
				<xsl:variable name="techProvArch" select="/node()/simple_instance[name = $techProdBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
				<xsl:apply-templates select="/node()/simple_instance[name = $techProvArch/own_slot_value[slot_reference = 'contained_architecture_components']/value]" mode="Technology_Provider_Usages">
					<xsl:with-param name="capId" select="$idofcap"/>
				</xsl:apply-templates>
				<!-- SELECTED TECHNOLOGY PRODUCTS END HERE -->
			</tbody>
		</table>
		<div class="ShowHideDivTrigger ShowHideDivOpen">
			<em>
				<a class="ShowHideDivLink  small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Show/Hide Strategic Technology Platforms')"/>
				</a>
			</em>
			<div class="verticalSpacer_5px"/>
		</div>
		<div class="hiddenDiv">
			<div class="verticalSpacer_5px"/>
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<th colspan="3" class="bg-lightblue-100">
							<xsl:value-of select="eas:i18n('Strategic Technology Platforms')"/>
						</th>
					</tr>
					<tr>
						<th class="cellWidth-20pc">
							<xsl:value-of select="eas:i18n('Product Vendor')"/>
						</th>
						<th class="cellWidth-40pc">
							<xsl:value-of select="eas:i18n('Product')"/>
						</th>
						<th class="cellWidth-40pc">
							<xsl:value-of select="eas:i18n('Usage')"/>
						</th>
					</tr>
				</thead>
				<tbody>
					<!-- STRATEGIC TECHNOLOGY PRODUCTS START HERE -->
					<xsl:apply-templates select="/node()/simple_instance[type = 'Technology_Component' and (own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $idofcap)]" mode="Technology_Components"> </xsl:apply-templates>
					<!-- STRATEGIC TECHNOLOGY PRODUCTS END HERE -->
				</tbody>
			</table>
		</div>
		<hr/>

	</xsl:template>

	<!-- TEMPLATE TO RETRIEVE THE TECHNOLOGY PRODUCT ROLES FROM THE PRODUCT USAGES OF A PROJECT'S TECHNOLOGY ARCHITECTURE -->
	<xsl:template name="Technology_Requirement_Title">
		<xsl:param name="capId"/>
		<xsl:variable name="projProdRoles" select="/node()/simple_instance[type = 'Technology_Product_Role' and (name = /node()/simple_instance[type = 'Technology_Product_Usage' and (name = /node()/simple_instance[type = 'Technology_Product_Architecture' and (name = /node()/simple_instance[type = 'Technology_Product' and (name = /node()/simple_instance[type = 'Project' and (name = $param1)]/own_slot_value[slot_reference = 'project_technology_architecture']/value)]/own_slot_value[slot_reference = 'technology_product_architecture']/value)]/own_slot_value[slot_reference = 'contained_architecture_components']/value)]/own_slot_value[slot_reference = 'product_as_role']/value)]"/>
		<xsl:variable name="prodRolesForCap" select="$projProdRoles[/node()/simple_instance[type = 'Technology_Component' and (own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $capId)]/name = own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
		<xsl:for-each select="$prodRolesForCap">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:for-each>
	</xsl:template>


	<!-- TEMPLATE TO RETRIEVE THE STRATEGIC TECHNOLOGY PRODUCTS FOR A COMPONENT -->
	<xsl:template match="node()" mode="Technology_Components">
		<xsl:variable name="idofcomp">
			<xsl:value-of select="name"/>
		</xsl:variable>
		<xsl:apply-templates select="/node()/simple_instance[type = 'Technology_Product_Role' and (own_slot_value[slot_reference = 'implementing_technology_component']/value = $idofcomp) and (own_slot_value[slot_reference = 'strategic_lifecycle_status']/value = $strategicStatus)]" mode="Strategic_Technology_Products">
			<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- TEMPLATE TO RETRIEVE THE TECHNOLOGY PRODUCT ROLES FROM THE PRODUCT USAGES OF A PROJECT'S TECHNOLOGY ARCHITECTURE -->
	<xsl:template match="node()" mode="Technology_Provider_Usages">
		<xsl:param name="capId"/>
		<xsl:variable name="idofprodrole">
			<xsl:value-of select="own_slot_value[slot_reference = 'provider_as_role']/value"/>
		</xsl:variable>
		<xsl:variable name="idofcomp">
			<xsl:value-of select="/node()/simple_instance[name = $idofprodrole]/own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
		</xsl:variable>
		<xsl:if test="/node()/simple_instance[type = 'Technology_Component' and (name = $idofcomp) and (own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $capId)]">
			<xsl:apply-templates select="/node()/simple_instance[name = $idofprodrole]" mode="Selected_Technology_Products">
				<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<!-- TEMPLATE TO RETRIEVE THE TECHNOLOGY PRODUCT ROLES FROM THE PRODUCT USAGES OF A PROJECT'S TECHNOLOGY ARCHITECTURE -->
	<xsl:template match="node()" mode="Technology_Product_Usages">
		<xsl:param name="capId"/>
		<xsl:variable name="idofprodrole">
			<xsl:value-of select="own_slot_value[slot_reference = 'product_as_role']/value"/>
		</xsl:variable>
		<xsl:variable name="idofcomp">
			<xsl:value-of select="/node()/simple_instance[type = 'Technology_Product_Role' and (name = $idofprodrole)]/own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
		</xsl:variable>
		<xsl:if test="/node()/simple_instance[type = 'Technology_Component' and (name = $idofcomp) and (own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $capId)]">
			<xsl:apply-templates select="/node()/simple_instance[type = 'Technology_Product_Role' and (name = $idofprodrole)]" mode="Selected_Technology_Products">
				<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<!-- TEMPLATE TO CREATE EACH STRATEGIC TECHNOLOGY PRODUCT TABLE  -->
	<xsl:template match="node()" mode="Strategic_Technology_Products">
		<xsl:variable name="idofprod">
			<xsl:value-of select="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
		</xsl:variable>
		<xsl:variable name="idofsupplier">
			<xsl:value-of select="/node()/simple_instance[type = 'Technology_Product' and (name = $idofprod)]/own_slot_value[slot_reference = 'supplier_technology_product']/value"/>
		</xsl:variable>
		<xsl:variable name="idofcomp">
			<xsl:value-of select="own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
		</xsl:variable>
		<tr>
			<td>
				<xsl:variable name="productSupplier" select="/node()/simple_instance[name = $idofsupplier]"/>
				<xsl:variable name="displayLabel" select="translate($productSupplier/own_slot_value[slot_reference = 'name']/value, '_', ' ')"/>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$productSupplier"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="$displayLabel"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:variable name="techProduct" select="/node()/simple_instance[name = $idofprod]"/>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$techProduct"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:variable name="techComp" select="/node()/simple_instance[name = $idofcomp]"/>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$techComp"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>


	<!-- TEMPLATE TO CREATE EACH SELECTED TECHNOLOGY PRODUCT TABLE  -->
	<xsl:template match="node()" mode="Selected_Technology_Products">
		<xsl:variable name="idofprod">
			<xsl:value-of select="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
		</xsl:variable>
		<xsl:variable name="idofsupplier">
			<xsl:value-of select="/node()/simple_instance[type = 'Technology_Product' and (name = $idofprod)]/own_slot_value[slot_reference = 'supplier_technology_product']/value"/>
		</xsl:variable>
		<xsl:variable name="idofcomp">
			<xsl:value-of select="own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
		</xsl:variable>
		<xsl:variable name="idofstatus">
			<xsl:value-of select="own_slot_value[slot_reference = 'strategic_lifecycle_status']/value"/>
		</xsl:variable>
		<xsl:variable name="nameofstatus">
			<xsl:value-of select="/node()/simple_instance[type = 'Lifecycle_Status' and (name = $idofstatus)]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
		</xsl:variable>
		<xsl:variable name="symbolforstatus">
			<xsl:value-of select="/node()/simple_instance[type = 'Lifecycle_Status' and (name = $idofstatus)]/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<tr>
			<td>
				<xsl:variable name="productSupplier" select="/node()/simple_instance[name = $idofsupplier]"/>
				<xsl:variable name="displayLabel" select="translate($productSupplier/own_slot_value[slot_reference = 'name']/value, '_', ' ')"/>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$productSupplier"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="$displayLabel"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:variable name="techProduct" select="/node()/simple_instance[name = $idofprod]"/>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$techProduct"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:variable name="techComp" select="/node()/simple_instance[name = $idofcomp]"/>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$techComp"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<xsl:choose>
				<xsl:when test="$symbolforstatus = 'ProductionStrategic'">
					<td class="backColourGreen alignLeft">
						<xsl:value-of select="eas:i18n('On Strategy')"/>
					</td>
				</xsl:when>
				<xsl:when test="$symbolforstatus = 'OffStrategy' or $symbolforstatus = 'Sunset' or $symbolforstatus = 'Retired'">
					<td class="backColourRed alignLeft">
						<xsl:value-of select="eas:i18n('Off Strategy')"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="backColourYellow alignLeft">
						<xsl:value-of select="eas:i18n('Waiver Required')"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>


</xsl:stylesheet>
