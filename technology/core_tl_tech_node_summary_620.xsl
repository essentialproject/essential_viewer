<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:variable name="currentNode" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="serverName" select="$currentNode/own_slot_value[slot_reference = 'name']/value"/>
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Site', 'Technology_Node', 'Application_Deployment', 'Application_Provider', 'Application_Software_Instance', 'Infrastructure_Software_Instance', 'Information_Store_Instance', 'Technology_Product', 'Technology_Component', 'Individual_Actor', 'Group_Actor', 'Information_Representation', 'Business_Strategic_Plan', 'Information_Strategic_Plan', 'Application_Strategic_Plan', 'Technology_Strategic_Plan', 'Security_Strategic_Plan')"/>

	<xsl:variable name="techTPR" select="/node()/simple_instance[supertype='Technology_Provider_Role'][name=$currentNode/own_slot_value[slot_reference='technology_node_platform_stack']/value]"/>
	<xsl:variable name="techProducts" select="/node()/simple_instance[supertype='Technology_Provider'][name=$techTPR/own_slot_value[slot_reference='role_for_technology_provider']/value]"/>
	
	<xsl:variable name="techComponents" select="/node()/simple_instance[type='Technology_Component'][name=$techTPR/own_slot_value[slot_reference='implementing_technology_component']/value]"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>
	<xsl:param name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Node Summary')"/>
	</xsl:param>
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
	<!-- 16.04.2008 JWC - Updated to include Strategy planning code -->
	<!-- 18.04.2008 JWC Link Deployed Database Schemas to Information Representation report -->
	<!-- 06.06.2008	GW - Updated the title details in the html -->
	<!-- 25.07.2008	JWC - Revised report to take attributes from the Node, not Hardware Instance -->
	<!-- 25.07.2008 JWC - Added details of any references to external repositories -->
	<!-- 05.08.2008 JWC - Fixed problem with applications having multiple dependencies on technology instances -->
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 05.11.2008 JWC - Completed updated migration to new servlet reporting engine -->
	<!-- 19.11.2008	JWC - Added links to Technology Product definitions -->
	<!-- 01.09.2011	NJW	- Updated to Support Viewer 3.0-->
	<!-- 12.02.2019	JP	- Updated to use cpmmon Strategic Plans template-->
	
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
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
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$currentNode" mode="Page_Body"/>
				<!-- PAGE BODY ENDS HERE -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template match="node()" mode="Page_Body">
		<!-- Get the name of the application provider -->
		<xsl:variable name="nodeName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<a id="top"/>
		<div class="container-fluid">
			<div class="row">

				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>:&#160; </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Physical Node Specification for')"/>&#160; </span>
							<span class="text-primary">
								<xsl:value-of select="$nodeName"/>
							</span>
						</h1>
					</div>
				</div>


				<!--Setup Description Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-list-ul icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Description')"/>
					</h2>
					<div class="content-section">
						<xsl:if test="string-length(own_slot_value[slot_reference = 'description']/value) = 0">
							<p>-</p>
						</xsl:if>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$currentNode"/>
						</xsl:call-template>
					</div>
					<hr/>
				</div>

				<!--Setup Node Technology Section-->
				<!-- 19.11.2008 JWC Add link to definition -->
				<xsl:variable name="node_technology" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'deployment_of']/value]"/>
				<xsl:variable name="node_location" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
				<xsl:variable name="techProdName" select="translate($node_technology/own_slot_value[slot_reference = 'product_label']/value, '::', '  ')"/>
				<xsl:variable name="xurl">
					<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_prod_def.xsl&amp;PMA=</xsl:text>
					<xsl:value-of select="$node_technology/name"/>
					<xsl:text>&amp;LABEL=Technology Product - </xsl:text>
					<xsl:value-of select="$techProdName"/>
				</xsl:variable>

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-gears icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Node Technology')"/>
					</h2>
					<div class="content-section">
						<xsl:if test="count($node_technology) = 0">
							<p>-</p>
						</xsl:if>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$node_technology"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="displayString" select="translate($node_technology/own_slot_value[slot_reference = 'product_label']/value, '::', '  ')"/>
						</xsl:call-template>
					</div>
					<hr/>
				</div>


				<!--Setup the Location section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-truck icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Location')"/>
					</h2>
					<div class="content-section">
						<xsl:choose>
							<xsl:when test="count($node_location) = 0">
								<span>-</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$node_location"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>

				<!--Setup IP Address Section-->
				<xsl:variable name="ipAddressAttribute" select="/node()/simple_instance[(type = 'Attribute') and (own_slot_value[slot_reference = 'name']/value = 'IP Address')]"/>
				<xsl:variable name="currentTechNodeIPAddress" select="/node()/simple_instance[(name = $currentNode/own_slot_value[slot_reference = 'technology_node_attributes']/value) and (own_slot_value[slot_reference = 'attribute_value_of']/value = $ipAddressAttribute/name)]"/>
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('IP Address')"/>
					</h2>
					<div class="content-section">
						<xsl:if test="count($currentTechNodeIPAddress/own_slot_value[slot_reference = 'attribute_value']/value) = 0">
							<p>-</p>
						</xsl:if>
						<ul>
							<xsl:for-each select="$currentTechNodeIPAddress">
								<li>
									<xsl:value-of select="current()/own_slot_value[slot_reference = 'attribute_value']/value"/>
								</li>
							</xsl:for-each>
						</ul>
					</div>
					<hr/>
				</div>
				<!--Setup Technology Stack Section-->
				<div class="col-xs-12">
						<div class="sectionIcon">
							<i class="fa fa-server icon-section icon-color"/>
						</div>
						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Technology Stack')"/>
						</h2>
						<div class="content-section">
								<table width="75%" class="table table-striped">
									<tr><th>Product</th><th>Usage</th></tr>
							<xsl:for-each select="$techTPR">
									<xsl:variable name="thisProd" select="$techProducts[name=current()/own_slot_value[slot_reference='role_for_technology_provider']/value]"/>
									<xsl:variable name="thisComp" select="$techComponents[name=current()/own_slot_value[slot_reference='implementing_technology_component']/value]"/>
									<tr>
										<td width="35%">
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$thisProd"/>
												</xsl:call-template>
										</td>
										<td>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$thisComp"/>
												</xsl:call-template>
										</td>
									</tr>
							</xsl:for-each>
						</table>
							 
						</div>
						<hr/>
				</div>


				<!--Setup Deploy Node Section-->
				<xsl:variable name="aContainingNodeInst" select="own_slot_value[slot_reference = 'inverse_of_contained_technology_nodes']/value"/>
				<xsl:variable name="aContaininNode" select="/node()/simple_instance[name = $aContainingNodeInst]"/>
				<xsl:variable name="aNodeName" select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="anAttributeValue" select="/node()/simple_instance[name = current()]"/>
				<xsl:variable name="attribute_type" select="/node()/simple_instance[name = $anAttributeValue/own_slot_value[slot_reference = 'attribute_value_of']/value]"/>
				<xsl:if test="$aContaininNode">
					<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-server icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Deployed on Node')"/>
					</h2>
					<div class="content-section">
						<!-- Show Nodes this node is contained in -->
						<xsl:choose>
							<xsl:when test="count($aContaininNode) = 0">
								<p>-</p>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$aContaininNode">
									<table>
										<tr>
											<th class="cellWidth-10pc"><xsl:value-of select="eas:i18n('Node Name')"/>:</th>
											<td class="cellWidth-90pc">
												<!--<a>
														<xsl:attribute name="href">
															<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_phys_node_def.xsl&amp;PMA=</xsl:text>
															<xsl:value-of select="name" />
															<xsl:text>&amp;LABEL=Physical Node - </xsl:text>
															<xsl:value-of select="$aNodeName" />
														</xsl:attribute>
														<xsl:value-of select="$aNodeName" />
													</a>-->
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="current()"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</td>
										</tr>
										<!-- Done containing nodes -->
										<!-- Get the attributes of this node -->
										<!--<xsl:variable name="hardware_tech_instance" select="/node()/simple_instance[(type='Hardware_Instance') and (own_slot_value[slot_reference='technology_instance_deployed_on_node']/value=current()/name) and (own_slot_value[slot_reference='technology_instance_of']/value=current()/own_slot_value[slot_reference='deployment_of']/value)]"></xsl:variable>
									-->
										<!-- <xsl:for-each select="/node()/simple_instance[name=$hardware_tech_instance/own_slot_value[slot_reference='technology_instance_attributes']/value]">
									-->
										<xsl:for-each select="own_slot_value[slot_reference = 'technology_node_attributes']/value">
											<tr>
												<th>
													<xsl:value-of select="$attribute_type/own_slot_value[slot_reference = 'name']/value"/>
												</th>
												<td>
													<xsl:value-of select="$anAttributeValue/own_slot_value[slot_reference = 'attribute_value']/value"/> &#160; <xsl:value-of select="$attribute_type/own_slot_value[slot_reference = 'attribute_value_unit']/value"/>
												</td>
											</tr>
										</xsl:for-each>
									</table>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
					</div>
				</xsl:if>
				<!--Setup the Strategic Plans section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Strategic Plans')"/>
					</h2>
					<div class="content-section">
						<xsl:apply-templates select="$currentNode" mode="StrategicPlansForElement"/>
					</div>
					<hr/>
				</div>


				<!--Setup Deployed App Instances Section-->
				<xsl:variable name="app_instance_list" select="/node()/simple_instance[(own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name) and (type = 'Application_Software_Instance')]"/>

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-tablet icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Deployed Application Instances')"/>
					</h2>
					<!-- Create the Application Instances Section -->
					<xsl:choose>
						<xsl:when test="not(count($app_instance_list) > 0)">
							<div class="content-section">
								<p>-</p>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="content-section">
								<xsl:apply-templates select="$app_instance_list" mode="App_Instance"> </xsl:apply-templates>
							</div>
						</xsl:otherwise>
					</xsl:choose>
					<hr/>

				</div>

				<!--Setup Deployed Database Schema Section-->
				<xsl:variable name="info_store_instance_list" select="/node()/simple_instance[(own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name) and (type = 'Information_Store_Instance')]"/>

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-database icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Deployed Database Schema')"/>
					</h2>
					<!-- Create the Database Schema Instances Section -->

					<xsl:choose>
						<xsl:when test="not(count($info_store_instance_list) > 0)">
							<div class="content-section">
								<p>-</p>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="content-section">
								<xsl:apply-templates select="$info_store_instance_list" mode="Info_Store_Instance"/>
							</div>
						</xsl:otherwise>
					</xsl:choose>
					<hr/>
				</div>

				<!--Setup Deployed Technology Instances Section-->
				<xsl:variable name="tech_instance_list" select="/node()/simple_instance[(type != 'Application_Software_Instance') and (own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name) and (own_slot_value[slot_reference = 'technology_instance_of']/value != current()/own_slot_value[slot_reference = 'deployment_of']/value)]"/>

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-floppy-o icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Deployed Technology Instances')"/>
					</h2>
					<!-- Create the Tech Instances Section -->
					<xsl:choose>
						<xsl:when test="not(count($tech_instance_list))">
							<div class="content-section">
								<p>-</p>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="content-section">
								<xsl:apply-templates select="$tech_instance_list" mode="Technology_Instance"/>
								<!-- Apply Contained Nodes template here -->
								<xsl:apply-templates select="current()" mode="ContainedTechnologyNodes"/>
							</div>
						</xsl:otherwise>
					</xsl:choose>
					<hr/>
				</div>

				<!--Setup the Supporting Documentation section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-file-text-o icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
					</h2>

					<div class="content-section">
						<xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/><xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/><xsl:call-template name="RenderExternalDocRefList"><xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/></xsl:call-template>
					</div>
					<hr/>
				</div>

				<!--Setup Closing Divs-->
			</div>
		</div>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED APPLICATION INSTANCES -->
	<xsl:template match="node()" mode="App_Instance">
		<div class="largeThinRoundedBox">
			<table>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Application Instance Name')"/>
					</th>
					<td>
						<!--<xsl:value-of select="own_slot_value[slot_reference='technology_instance_given_name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
						</xsl:call-template>
					</td>
				</tr>
				<xsl:variable name="app_runtime_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Runtime Status (e.g. Live, Failover)')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_runtime_status))">-</xsl:if>
						<xsl:value-of select="$app_runtime_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
				</tr>
				<xsl:variable name="software_technology" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_of']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Deployment Technology Format')"/>
					</th>
					<td>
						<xsl:if test="not(count($software_technology))">-</xsl:if>
						<xsl:apply-templates select="$software_technology" mode="RenderDepAppTechProducts"/>
					</td>
				</tr>
				<xsl:variable name="app_runtime_tech" select="/node()/simple_instance[(name = current()/own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value) and (type = 'Infrastructure_Software_Instance')]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Supporting Application Runtime Instance')"/>
					</th>
					<td>
						<xsl:choose>
							<xsl:when test="not(count($app_runtime_tech))">-</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="tech_given_name" select="$app_runtime_tech/own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
								<!--<a>
									<xsl:attribute name="href">
										<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
										<xsl:value-of select="$app_runtime_tech/name" />
										<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
										<xsl:value-of select="$tech_given_name" />
									</xsl:attribute>
									<xsl:value-of select="$tech_given_name" />
								</a>-->
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$app_runtime_tech"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:variable name="app_runtime_tech_product" select="/node()/simple_instance[name = $app_runtime_tech/own_slot_value[slot_reference = 'technology_instance_of']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Supporting Application Runtime Technology')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_runtime_tech_product))">-</xsl:if>
						<!-- 05.08.2008 JWC - Fixed where there are multiple application-technology dependencies -->
						<!-- Orginal code
				<xsl:value-of select="translate($app_runtime_tech_product/own_slot_value[slot_reference='product_label']/value, '::', '  ')"/>
				-->
						<xsl:apply-templates select="$app_runtime_tech_product" mode="RenderDepAppTechProducts"/>
					</td>
				</tr>
				<!-- GET THE APPLICATION DEPLOYMENT OF WHICH THIS IS A PHYSICAL INSTANCE -->
				<xsl:variable name="app_deployment" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'instance_of_application_deployment']/value]"/>
				<!-- GET THE SOFTWARE ARCHITECTURES ASSOCIATED WITH THE INSTANCES APPLICATION DEPLOYMENT -->
				<xsl:variable name="software_architectures" select="/node()/simple_instance[own_slot_value[slot_reference = 'logical_software_arch_elements']/value = $app_deployment/own_slot_value[slot_reference = 'deployment_of_software_components']/value]"/>
				<!-- GET THE APP_PROVIDER ASSOCIATED WITH THE SOFTWARE ARCHITECTURE -->
				<xsl:variable name="app_provider" select="/node()/simple_instance[own_slot_value[slot_reference = 'has_software_architecture']/value = $software_architectures/name]"/>
				<tr>
					<th>Deployment of Application</th>
					<td>
						<xsl:if test="not(count($app_provider))">-</xsl:if>
						<!--<a>
							<xsl:variable name="app_provider_name" select="$app_provider/own_slot_value[slot_reference='name']/value" />
							<xsl:attribute name="href">
								<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
								<xsl:value-of select="$app_provider/name" />
								<xsl:text>&amp;LABEL=Application Module - </xsl:text>
								<xsl:value-of select="$app_provider_name" />
							</xsl:attribute>
							<xsl:value-of select="$app_provider_name" />
						</a>-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$app_provider"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Application Description')"/>
					</th>
					<td>
						<xsl:if test="count($app_provider/own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
						<xsl:value-of select="$app_provider/own_slot_value[slot_reference = 'description']/value"/>
					</td>
				</tr>
				<xsl:variable name="app_deployment_role" select="/node()/simple_instance[name = $app_deployment/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Application Deployment Role')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_deployment_role))">-</xsl:if>
						<xsl:value-of select="$app_deployment_role/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
				</tr>
				<xsl:variable name="app_it_contact" select="/node()/simple_instance[name = $app_provider/own_slot_value[slot_reference = 'ap_IT_contact']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('IT Contact')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_it_contact))">-</xsl:if>
						<!--<xsl:value-of select="$app_it_contact/own_slot_value[slot_reference='name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$app_it_contact"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED INFORMATION STORE INSTANCES -->
	<xsl:template match="node()" mode="Info_Store_Instance">
		<div class="largeThinRoundedBox">
			<table>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Database Schema Name')"/>
					</th>
					<td>
						<!-- 18.04.2008 JWC - Link to information representation report -->
						<xsl:variable name="anInformationStoreID" select="own_slot_value[slot_reference = 'instance_of_information_store']/value"/>
						<xsl:variable name="anInformationStore" select="/node()/simple_instance[name = $anInformationStoreID]"/>
						<xsl:variable name="anInformationRep" select="$anInformationStore/own_slot_value[slot_reference = 'deployment_of_information_representation']/value"/>
						<xsl:variable name="anInformationRepInst" select="/node()/simple_instance[name = $anInformationRep]"/>
						<!--<a>
							<xsl:attribute name="href">
								<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoRep.xsl&amp;PMA=</xsl:text>
								<xsl:value-of select="$anInformationRep" />
								<xsl:text>&amp;LABEL=Information Representation - </xsl:text>
								<xsl:value-of select="$anInformationRepInst/own_slot_value[slot_reference='name']/value" />
							</xsl:attribute>
							<xsl:value-of select="own_slot_value[slot_reference='technology_instance_given_name']/value" />
						</a>-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$anInformationRepInst"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Database Schema Description')"/>
					</th>
					<td>
						<xsl:if test="count(own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
				</tr>
				<xsl:variable name="info_deployment_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Deployment Status')"/>
					</th>
					<td>
						<xsl:if test="not(count($info_deployment_status))">-</xsl:if>
						<xsl:value-of select="$info_deployment_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
				</tr>
				<xsl:variable name="info_db_instance" select="/node()/simple_instance[(name = current()/own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value) and (type = 'Infrastructure_Software_Instance')]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Supporting Database Installation')"/>
					</th>
					<td>
						<xsl:choose>
							<xsl:when test="not(count($info_db_instance))">-</xsl:when>
							<xsl:otherwise>
								<!--<a>
									<xsl:variable name="db_given_name" select="$info_db_instance/own_slot_value[slot_reference='technology_instance_given_name']/value" />
									<xsl:attribute name="href">
										<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
										<xsl:value-of select="$info_db_instance/name" />
										<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
										<xsl:value-of select="$db_given_name" />
									</xsl:attribute>
									<xsl:value-of select="$db_given_name" />
								</a>-->
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$info_db_instance"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:variable name="info_db_tech_product" select="/node()/simple_instance[name = $info_db_instance/own_slot_value[slot_reference = 'technology_instance_of']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Database Installation Technology')"/>
					</th>
					<td>
						<xsl:if test="not(count($info_db_tech_product))">-</xsl:if>
						<xsl:apply-templates select="$info_db_tech_product" mode="RenderDepAppTechProducts"/>
						<!-- <xsl:value-of select="translate($info_db_tech_product/own_slot_value[slot_reference='product_label']/value, '::', '  ')"/> -->
					</td>
				</tr>
				<xsl:variable name="info_rep" select="/node()/simple_instance[own_slot_value[slot_reference = 'implemented_with_information_stores']/value = current()/own_slot_value[slot_reference = 'instance_of_information_store']/value]"/>
				<xsl:variable name="info_it_contact" select="/node()/simple_instance[name = $info_rep/own_slot_value[slot_reference = 'representation_it_contact']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('IT Contact')"/>
					</th>
					<td>
						<xsl:if test="not(count($info_it_contact))">-</xsl:if>
						<!--<xsl:value-of select="$info_it_contact/own_slot_value[slot_reference='name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$info_it_contact"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED TECHNOLOGY INSTANCES -->
	<xsl:template match="node()" mode="Technology_Instance">
		<div class="largeThinRoundedBox">
			<table>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Technology Instance Name')"/>
					</th>
					<xsl:variable name="instance_given_name" select="own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
					<xsl:variable name="instance_basic_name" select="own_slot_value[slot_reference = 'name']/value"/>
					<td>
						<!--<a>
							<xsl:attribute name="href">
								<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
								<xsl:value-of select="name" />
								<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
								<xsl:choose>
									<xsl:when test="not(string($instance_given_name))">
										<xsl:value-of select="$instance_basic_name" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$instance_given_name" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="not(string($instance_given_name))">
									<xsl:value-of select="$instance_basic_name" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$instance_given_name" />
								</xsl:otherwise>
							</xsl:choose>
						</a>-->
						<xsl:variable name="techInstanceName">
							<xsl:choose>
								<xsl:when test="not(string($instance_given_name))">
									<xsl:value-of select="$instance_basic_name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$instance_given_name"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="displayString" select="$techInstanceName"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Technology Instance Description')"/>
					</th>
					<td>
						<xsl:if test="count(own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
				</tr>
				<xsl:variable name="tech_runtme_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Runtime Status')"/>
					</th>
					<td>
						<xsl:if test="not(count($tech_runtme_status))">-</xsl:if>
						<xsl:value-of select="$tech_runtme_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
				</tr>
				<xsl:variable name="tech_instance_usage" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]"/>
				<xsl:variable name="instance_prod_role" select="/node()/simple_instance[name = $tech_instance_usage[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
				<xsl:variable name="tech_product" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
				<xsl:variable name="tech_component" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Technology Product')"/>
					</th>
					<td>
						<xsl:if test="not(count($tech_product))">-</xsl:if>
						<xsl:apply-templates select="$tech_product" mode="RenderDepAppTechProducts"/>
						<!-- <xsl:value-of select="translate($tech_product/own_slot_value[slot_reference='product_label']/value, '::', '  ')"/> -->
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Used As')"/>
					</th>
					<td>
						<xsl:if test="not(count($tech_component))">-</xsl:if>
						<!--<xsl:value-of select="$tech_component/own_slot_value[slot_reference='name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$tech_component"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<!-- Receives a node with a list of contained technology node instances and renders them
		-->
	<xsl:template match="node()" mode="ContainedTechnologyNodes">
		<xsl:choose>
			<xsl:when test="count(own_slot_value[slot_reference = 'contained_technology_nodes']) > 0">
				<div class="largeThinRoundedBox">
					<table>
						<tbody>
							<xsl:variable name="aNodeList" select="own_slot_value[slot_reference = 'contained_technology_nodes']"/>
							<xsl:for-each select="own_slot_value[slot_reference = 'contained_technology_nodes']/value">
								<xsl:variable name="anInstName" select="."/>
								<xsl:variable name="aNode" select="/node()/simple_instance[name = $anInstName]"/>
								<tr>
									<td>
										<!--<a>
										<xsl:attribute name="href">
											<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_phys_node_def.xsl&amp;PMA=</xsl:text>
											<xsl:value-of select="$aNode/name" />
											<xsl:text>&amp;LABEL=Physical Node, Server Details - </xsl:text>
											<xsl:value-of select="$aNode/own_slot_value[slot_reference='name']/value" />
										</xsl:attribute>
										<xsl:value-of select="$aNode/own_slot_value[slot_reference='name']/value" />
									</a>-->
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$aNode"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- 05.08.2008 JWC
		Render Technology Products that are supporting an Application.
		Expects the application_technology_product node
	-->
	<xsl:template match="node()" mode="RenderDepAppTechProducts">
		<!-- Add hyperlink to product report -->
		<xsl:if test="position() > 1">
			<br/>
		</xsl:if>
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
		</xsl:call-template>
	</xsl:template>
	
	<!--<!-\- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING STRATEGIC PLAN  -\->
	<!-\- Given a reference (instance ID) to an element, find all its plans and render each -\->
	<xsl:template match="node()" mode="StrategicPlansForElement">
		<xsl:variable name="anElement">
			<xsl:value-of select="node()"/>
		</xsl:variable>
		<xsl:variable name="anActivePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Active_Plan')]"/>
		<xsl:variable name="aFuturePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Future_Plan')]"/>
		<xsl:variable name="anOldPlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Old_Plan')]"/>
		<xsl:variable name="aStrategicPlanSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $anElement]"/>
		<!-\- Test to see if any plans are defined yet -\->
		<xsl:choose>
			<xsl:when test="count($aStrategicPlanSet) > 0">
				<!-\- Show active plans first -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anActivePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anActivePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-\- Then the future -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $aFuturePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$aFuturePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-\- Then the old -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anOldPlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<p>
						<xsl:value-of select="eas:i18n('No strategic plans defined for this element')"/>
					</p>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-\- Render the details of a particular strategic plan in a small table -\->
	<!-\- No details of plan inter-dependencies is presented here. However, a link 
        to the plan definition page is provided where those details will be shown -\->
	<xsl:template match="node()" mode="StrategicPlanDetailsTable">
		<xsl:param name="theStatus"/>
		<xsl:variable name="aStatusID" select="current()/own_slot_value[slot_reference = 'strategic_plan_status']/value"/>
		<xsl:if test="$aStatusID = $theStatus">
			<table>
				<tbody>
					<tr>
						<th>
							<xsl:value-of select="eas:i18n('Plan')"/>
						</th>
						<th>
							<xsl:value-of select="eas:i18n('Description')"/>
						</th>
					</tr>
					<tr>
						<td>
							<strong>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									<xsl:with-param name="displayString" select="translate(own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
								</xsl:call-template>
							</strong>
						</td>
						<td>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>-->
</xsl:stylesheet>
