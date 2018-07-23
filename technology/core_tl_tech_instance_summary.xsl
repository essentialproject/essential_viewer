<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<!--<xsl:include href="../common/core_strategic_plans.xsl" />-->
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Site', 'Technology_Node', 'Application_Deployment', 'Application_Provider', 'Application_Software_Instance', 'Infrastructure_Software_Instance', 'Information_Store_Instance', 'Technology_Product', 'Technology_Component', 'Individual_Actor', 'Group_Actor', 'Information_Representation', 'Business_Strategic_Plan', 'Information_Strategic_Plan', 'Application_Strategic_Plan', 'Technology_Strategic_Plan', 'Security_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:param name="param1"/>
	<xsl:variable name="currentInstance" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="node" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value]"/>
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
	<!-- 18.04.2008 JWC Revised approach to Strategic Planning -->
	<!-- 18.04.2008 JWC Link Deployed Database Schemas to Information Representation report -->
	<!-- 21.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 22.05.2008 JP  Fixed bug with instance names vs. given name -->
	<!-- 05.11.2008 JWC	Incorporated missing fixes from 18.04.2008 and update to XSL v2 -->
	<!-- 19.11.2008	JWC	Add hyperlinks to technology product information -->
	<xsl:template match="knowledge_base">
		<html xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt">
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Technology Instance Summary')"/>
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
				<xsl:apply-templates select="$currentInstance" mode="Page_Body"/>
				<!-- PAGE BODY ENDS HERE -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template match="node()" mode="Page_Body">
		<!-- Get the name of the technology instance -->
		<xsl:variable name="givenName">
			<xsl:value-of select="own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
		</xsl:variable>
		<xsl:variable name="instanceSimpleName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<!--ADD THE CONTENT-->
		<a id="top"/>
		<div class="container-fluid">
			<div class="row">

				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Instance Specification for')"/>&#160; <span class="text-primary"><xsl:if test="not(string($givenName))"><xsl:value-of select="$instanceSimpleName"/></xsl:if><xsl:value-of select="$givenName"/></span></span>
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
						<xsl:if test="not(count(own_slot_value[slot_reference = 'description']/value) > 0)">-</xsl:if>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</div>
					<hr/>
				</div>


				<!--Setup Status Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-check icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Runtime Status')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="tech_runtme_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
						<xsl:if test="not(count($tech_runtme_status) > 0)">-</xsl:if>
						<xsl:value-of select="$tech_runtme_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</div>
					<hr/>
				</div>


				<!--Setup Supporting Tech Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-gears icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Technology')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="tech_instance_usage" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]"/>
						<xsl:variable name="instance_prod_role" select="/node()/simple_instance[name = $tech_instance_usage[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
						<xsl:variable name="tech_product" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
						<xsl:variable name="tech_component" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
						<xsl:if test="not(count($tech_product) > 0)">-</xsl:if>
						<xsl:apply-templates select="$tech_product" mode="RenderDepTechProduct"/>
						<span> used as </span>
						<xsl:if test="not(count($tech_component) > 0)">-</xsl:if>
						<!--<xsl:value-of select="$tech_component/own_slot_value[slot_reference='name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$tech_component"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</div>
					<hr/>
				</div>


				<!--Setup Instance Configuration Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-info-circle icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Instance Configuration')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="instance_config_list" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_attributes']/value]"/>
						<xsl:if test="not(count($instance_config_list) > 0)">
							<em>
								<xsl:value-of select="eas:i18n('No configuration details captured for this Technology Instance')"/>
							</em>
						</xsl:if>
						<xsl:if test="(count($instance_config_list) > 0)">
							<table>
								<xsl:for-each select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_attributes']/value]">
									<tr>
										<xsl:variable name="attribute_type" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'attribute_value_of']/value]"/>
										<th class="cellWidth-30pc">
											<xsl:value-of select="$attribute_type/own_slot_value[slot_reference = 'name']/value"/>
										</th>
										<td class="cellWidth-70pc"><xsl:value-of select="own_slot_value[slot_reference = 'attribute_value']/value"/>&#160;<xsl:value-of select="$attribute_type/own_slot_value[slot_reference = 'attribute_value_unit']/value"/></td>
									</tr>
								</xsl:for-each>
							</table>
						</xsl:if>
					</div>
					<hr/>
				</div>


				<!--Setup Deployment Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-server icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Deployed on Physical Node')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="node_technology" select="/node()/simple_instance[name = $node/own_slot_value[slot_reference = 'deployment_of']/value]"/>
						<xsl:variable name="node_location" select="/node()/simple_instance[name = $node/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
						<table>
							<tr>
								<th class="cellWidth-20pc">
									<xsl:value-of select="eas:i18n('Physical Node Name')"/>
								</th>
								<td>
									<!--<a>
											<xsl:variable name="node_name" select="$node/own_slot_value[slot_reference='name']/value" />
											<xsl:attribute name="href">
												<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_phys_node_def.xsl&amp;PMA=</xsl:text>
												<xsl:value-of select="$node/name" />
												<xsl:text>&amp;LABEL=Physical Node - </xsl:text>
												<xsl:value-of select="$node_name" />
											</xsl:attribute>
											<xsl:value-of select="$node_name" />
										</a>-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$node"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Physical Node Technology')"/>
								</th>
								<td>
									<xsl:apply-templates select="$node_technology" mode="RenderDepTechProduct"/>
								</td>
							</tr>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Location')"/>
								</th>
								<td>
									<!--<xsl:value-of select="$node_location/own_slot_value[slot_reference='name']/value" />-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$node_location"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
							</tr>
						</table>
					</div>
					<hr/>
				</div>


				<!--Setup Strategic Planning Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Strategic Planning')"/>
					</h2>
					<div class="content-section">
						<xsl:apply-templates select="$currentInstance/name" mode="StrategicPlansForElement"/>
					</div>
					<hr/>
				</div>


				<!--Setup Dependant Applications Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-tablet icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Dependant Application Instances')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="app_instance_list" select="/node()/simple_instance[(own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value = current()/name) and (type = 'Application_Software_Instance')]"/>
						<xsl:if test="not(count($app_instance_list) > 0)">
							<em>
								<xsl:value-of select="eas:i18n('No Application Instances dependant on this Technology Instance')"/>
							</em>
						</xsl:if>
						<xsl:if test="(count($app_instance_list) > 0)">
							<xsl:value-of select="eas:i18n('The following tables describe the Application Instances that are dependant on this Technology Instance ')"/>
							<br/>
							<br/>
							<xsl:apply-templates select="$app_instance_list" mode="App_Instance"/>
						</xsl:if>
					</div>
					<hr/>
				</div>


				<!--Setup Database Schema Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-database icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Database Schema')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="info_store_instance_list" select="/node()/simple_instance[(own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value = current()/name) and (type = 'Information_Store_Instance')]"/>
						<xsl:if test="not(count($info_store_instance_list) > 0)">
							<em>
								<xsl:value-of select="eas:i18n('No Physical Information Schema dependant on this Technology Instance')"/>
							</em>
						</xsl:if>
						<xsl:if test="(count($info_store_instance_list) > 0)">
							<xsl:value-of select="eas:i18n('The following tables describe the physical information schema that are dependant on this technology instance')"/>
							<br/>
							<br/>
							<xsl:apply-templates select="$info_store_instance_list" mode="Info_Store_Instance"/>
						</xsl:if>
					</div>
					<hr/>
				</div>


				<!--Setup Dependant Technology Instances Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-radialdots icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Dependant Technology Instances')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="tech_instance_list" select="/node()/simple_instance[(type != 'Information_Store_Instance') and (type != 'Application_Software_Instance') and (own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value = current()/name)]"/>
						<xsl:if test="not(count($tech_instance_list) > 0)">
							<em>
								<xsl:value-of select="eas:i18n('No other Technology Instances dependant on this Technology Instance')"/>
							</em>
						</xsl:if>
						<xsl:if test="(count($tech_instance_list) > 0)">
							<xsl:value-of select="eas:i18n('The following tables describe other Technology Instances that are dependant on this Technology Instance')"/>
							<br/>
							<br/>
							<xsl:apply-templates select="$tech_instance_list" mode="Technology_Instance"/>
						</xsl:if>
					</div>
					<hr/>
				</div>


				<!--Setup Supporting Technology Instances Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-blocks icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Technology Instances')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="support_tech_instance_list" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value]"/>
						<xsl:if test="not(count($support_tech_instance_list) > 0)">
							<em>
								<xsl:value-of select="eas:i18n('No other Technology Instances supporting this Technology Instance')"/>
							</em>
						</xsl:if>
						<xsl:if test="(count($support_tech_instance_list) > 0)">
							<xsl:value-of select="eas:i18n('The following tables describe other Technology Instances that are supporting on this Technology Instance')"/>
							<br/>
							<br/>
							<xsl:apply-templates select="$support_tech_instance_list" mode="Technology_Instance"/>
						</xsl:if>
					</div>
					<hr/>
				</div>


				<!--Setup Closing Tags-->
			</div>
		</div>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED APPLICATION INSTANCES -->
	<xsl:template match="node()" mode="App_Instance">
		<xsl:variable name="app_runtime_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
		<xsl:variable name="software_technology" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_of']/value]"/>
		<!-- GET THE APPLICATION DEPLOYMENT OF WHICH THIS IS A PHYSICAL INSTANCE -->
		<xsl:variable name="app_deployment" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'instance_of_application_deployment']/value]"/>
		<!-- GET THE SOFTWARE ARCHITECTURES ASSOCIATED WITH THE INSTANCES APPLICATION DEPLOYMENT -->
		<xsl:variable name="software_architectures" select="/node()/simple_instance[own_slot_value[slot_reference = 'logical_software_arch_elements']/value = $app_deployment/own_slot_value[slot_reference = 'deployment_of_software_components']/value]"/>
		<!-- GET THE APP_PROVIDER ASSOCIATED WITH THE SOFTWARE ARCHITECTURE -->
		<xsl:variable name="app_provider" select="/node()/simple_instance[own_slot_value[slot_reference = 'has_software_architecture']/value = $software_architectures/name]"/>
		<xsl:variable name="app_deployment_role" select="/node()/simple_instance[name = $app_deployment/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
		<xsl:variable name="app_it_contact" select="/node()/simple_instance[name = $app_provider/own_slot_value[slot_reference = 'ap_IT_contact']/value]"/>
		<xsl:if test="position() != 1">
			<div class="verticalSpacer_20px"/>
		</xsl:if>
		<table class="table table-bordered table-striped">
			<tbody>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Application Instance Name')"/>
					</th>
					<td colspan="3">
						<strong>
							<!--<xsl:value-of select="own_slot_value[slot_reference='technology_instance_given_name']/value" />-->
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
							</xsl:call-template>
						</strong>
					</td>
				</tr>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Runtime Status (e.g. Live, Failover)')"/>
					</th>
					<td class="cellWidth-30pc">
						<xsl:if test="not(count($app_runtime_status) > 0)">-</xsl:if>
						<xsl:value-of select="$app_runtime_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Deployment Technology Format')"/>
					</th>
					<td class="cellWidth-30pc">
						<xsl:if test="not(count($software_technology) > 0)">-</xsl:if>
						<xsl:apply-templates select="$software_technology" mode="RenderDepTechProduct"/>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Deployment of Application')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_provider) > 0)">-</xsl:if>
						<a>
							<xsl:variable name="app_provider_name" select="$app_provider/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:attribute name="href">
								<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
								<xsl:value-of select="$app_provider/name"/>
								<xsl:text>&amp;LABEL=Application Module - </xsl:text>
								<xsl:value-of select="$app_provider_name"/>
							</xsl:attribute>
							<xsl:value-of select="$app_provider_name"/>
						</a>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$app_provider"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
					<th>
						<xsl:value-of select="eas:i18n('Application Description')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_provider/own_slot_value[slot_reference = 'description']/value) > 0)">-</xsl:if>
						<xsl:value-of select="$app_provider/own_slot_value[slot_reference = 'description']/value"/>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Application Deployment Role')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_deployment_role) > 0)">-</xsl:if>
						<xsl:value-of select="$app_deployment_role/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('IT Contact')"/>
					</th>
					<td>
						<xsl:if test="not(count($app_it_contact) > 0)">-</xsl:if>
						<!--<xsl:value-of select="$app_it_contact/own_slot_value[slot_reference='name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$app_it_contact"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED INFORMATION STORE INSTANCES -->
	<xsl:template match="node()" mode="Info_Store_Instance">
		<!-- 18.04.2008 JWC - Link to information representation report -->
		<xsl:variable name="anInformationStoreID" select="own_slot_value[slot_reference = 'instance_of_information_store']/value"/>
		<xsl:variable name="anInformationStore" select="/node()/simple_instance[name = $anInformationStoreID]"/>
		<xsl:variable name="info_deployment_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
		<xsl:variable name="info_db_instance" select="/node()/simple_instance[(name = current()/own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value) and (type = 'Infrastructure_Software_Instance')]"/>
		<xsl:variable name="info_db_tech_product" select="/node()/simple_instance[name = $info_db_instance/own_slot_value[slot_reference = 'technology_instance_of']/value]"/>
		<xsl:variable name="info_rep" select="/node()/simple_instance[own_slot_value[slot_reference = 'implemented_with_information_stores']/value = current()/own_slot_value[slot_reference = 'instance_of_information_store']/value]"/>
		<xsl:variable name="info_it_contact" select="/node()/simple_instance[name = $info_rep/own_slot_value[slot_reference = 'representation_it_contact']/value]"/>
		<xsl:if test="position() != 1">
			<div class="verticalSpacer_20px"/>
		</xsl:if>
		<table class="table table-bordered table-striped">
			<tbody>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Database Schema Name')"/>
					</th>
					<td colspan="3">
						<strong>
							<!--<a>
								<xsl:attribute name="href">
									<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoRep.xsl&amp;PMA=</xsl:text>
									<xsl:value-of select="$anInformationStore/own_slot_value[slot_reference='deployment_of_information_representation']/value" />
									<xsl:text>&amp;LABEL=Information Representation - </xsl:text>
									<xsl:value-of select="own_slot_value[slot_reference='technology_instance_given_name']/value" />
								</xsl:attribute>
								<xsl:value-of select="own_slot_value[slot_reference='technology_instance_given_name']/value" />
							</a>-->
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
							</xsl:call-template>
						</strong>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Database Schema Description')"/>
					</th>
					<td colspan="3">
						<xsl:if test="not(count(own_slot_value[slot_reference = 'description']/value) > 0)">-</xsl:if>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Deployment Status')"/>
					</th>
					<td class="cellWidth-30pc">
						<xsl:if test="not(count($info_deployment_status) > 0)">-</xsl:if>
						<xsl:value-of select="$info_deployment_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Supporting Database Installation')"/>
					</th>
					<td class="cellWidth-30pc">
						<xsl:if test="not(count($info_db_instance) > 0)">-</xsl:if>
						<!--<xsl:value-of select="$info_db_instance/own_slot_value[slot_reference='technology_instance_given_name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$info_db_instance"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Database Installation Technology')"/>
					</th>
					<td>
						<xsl:if test="not(count($info_db_tech_product) > 0)">-</xsl:if>
						<xsl:apply-templates select="$info_db_tech_product" mode="RenderDepTechProduct"/>
					</td>
					<th>
						<xsl:value-of select="eas:i18n('IT Contact')"/>
					</th>
					<td>
						<xsl:if test="not(count($info_it_contact) > 0)">-</xsl:if>
						<!--<xsl:value-of select="$info_it_contact/own_slot_value[slot_reference='name']/value" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$info_it_contact"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED TECHNOLOGY INSTANCES -->
	<xsl:template match="node()" mode="Technology_Instance">
		<xsl:variable name="tech_runtme_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
		<xsl:variable name="tech_instance_usage" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]"/>
		<xsl:variable name="instance_prod_role" select="/node()/simple_instance[name = $tech_instance_usage[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
		<xsl:variable name="tech_product" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="tech_component" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
		<xsl:variable name="instanceNode" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value]"/>
		<xsl:variable name="instanceName" select="$instanceNode/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:if test="position() != 1">
			<div class="verticalSpacer_20px"/>
		</xsl:if>
		<table class="table table-bordered table-striped">
			<tbody>
				<xsl:choose>
					<xsl:when test="type = 'Hardware_Instance'">
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('Technology Instance Name')"/>
							</th>
							<td colspan="3">
								<!--<a>
									<xsl:variable name="tech_instance_name" select="own_slot_value[slot_reference='name']/value" />
									<xsl:attribute name="href">
										<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
										<xsl:value-of select="name" />
										<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
										<xsl:value-of select="$tech_instance_name" />
									</xsl:attribute>
									<xsl:value-of select="$tech_instance_name" />
								</a>-->
								<strong>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</strong>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('Technology Instance Name')"/>
							</th>
							<td colspan="3">
								<!--<a>
										<xsl:variable name="tech_instance_name" select="own_slot_value[slot_reference='technology_instance_given_name']/value" />
										<xsl:attribute name="href">
											<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
											<xsl:value-of select="name" />
											<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
											<xsl:value-of select="$tech_instance_name" />
										</xsl:attribute>
										<xsl:value-of select="$tech_instance_name" />
									</a>-->
								<strong>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
									</xsl:call-template>
								</strong>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Technology Instance Description')"/>
					</th>
					<td colspan="3">
						<xsl:if test="not(count(own_slot_value[slot_reference = 'description']/value) > 0)">-</xsl:if>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Runtime Status')"/>
					</th>
					<td class="cellWidth-30pc">
						<xsl:if test="not(count($tech_runtme_status) > 0)">-</xsl:if>
						<xsl:value-of select="$tech_runtme_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</td>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Technology Product')"/>
					</th>
					<td class="cellWidth-30pc">
						<xsl:if test="not(count($tech_product) > 0)">-</xsl:if>
						<xsl:apply-templates select="$tech_product" mode="RenderDepTechProduct"/>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Used As')"/>
					</th>
					<td>
						<xsl:if test="not(count($tech_component) > 0)">-</xsl:if>
						<xsl:value-of select="$tech_component/own_slot_value[slot_reference = 'name']/value"/>
					</td>
					<th>
						<xsl:value-of select="eas:i18n('Deployed on Node')"/>
					</th>
					<td>
						<!--<a>
							<xsl:attribute name="href">
								<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_phys_node_def.xsl&amp;PMA=</xsl:text>
								<xsl:value-of select="$instanceNode/name" />
								<xsl:text>&amp;LABEL=Physical Node - </xsl:text>
								<xsl:value-of select="$instanceName" />
							</xsl:attribute>
							<xsl:value-of select="$instanceName" />
						</a>-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$instanceNode"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>


	<!-- 19.11.2008 JWC Render a Technology Product with a link. Takes a Technology Product node -->
	<xsl:template match="node()" mode="RenderDepTechProduct">
		<!-- Add hyperlink to product report -->
		<!-- 19.11.2008 JWC Add link to definition -->
		<xsl:variable name="techProdName" select="translate(own_slot_value[slot_reference = 'product_label']/value, '::', '  ')"/>
		<!--<xsl:variable name="xurl">
			<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_prod_def.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="name" />
			<xsl:text>&amp;LABEL=Technology Product - </xsl:text>
			<xsl:value-of select="$techProdName" />
		</xsl:variable>-->
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


	<!-- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING STRATEGIC PLAN  -->
	<!-- Given a reference (instance ID) to an element, find all its plans and render each -->
	<xsl:template match="node()" mode="StrategicPlansForElement">
		<xsl:variable name="anElement">
			<xsl:value-of select="node()"/>
		</xsl:variable>
		<xsl:variable name="anActivePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Active_Plan')]"/>
		<xsl:variable name="aFuturePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Future_Plan')]"/>
		<xsl:variable name="anOldPlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Old_Plan')]"/>
		<xsl:variable name="aStrategicPlanSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $anElement]"/>
		<!-- Test to see if any plans are defined yet -->
		<xsl:choose>
			<xsl:when test="count($aStrategicPlanSet) > 0">
				<!-- Show active plans first -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anActivePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anActivePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-- Then the future -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $aFuturePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$aFuturePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-- Then the old -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anOldPlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:text>No strategic plans defined for this element</xsl:text>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Render the details of a particular strategic plan in a small table -->
	<!-- No details of plan inter-dependencies is presented here. However, a link 
        to the plan definition page is provided where those details will be shown -->
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
	</xsl:template>
</xsl:stylesheet>
