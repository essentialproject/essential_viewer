<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Model', 'Business_Capability', 'Group_Business_Role', 'Product_Concept', 'Product_Type', 'Composite_Product_Type', 'Value_Stream', 'Value_Stage', 'Application_Capability', 'Composite_Application_Service', 'Application_Provider', 'Information_Concept', 'Information_View', 'Technology_Capability', 'Technology_Composite')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	
	<!-- GET THE VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="currentBusModel" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentBusModelLink">
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="$currentBusModel"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="allOpModelCategories" select="/node()/simple_instance[type = 'Operating_Model_Category']"/>
	<xsl:variable name="oversightOpModelCategory" select="$allOpModelCategories[own_slot_value[slot_reference = 'enumeration_sequence_number']/value = 0]"/>
	<xsl:variable name="mainOpModelCategories" select="$allOpModelCategories except $oversightOpModelCategory"/>
	
	<xsl:variable name="busModelDirectives" select="/node()/simple_instance[name = $currentBusModel/own_slot_value[slot_reference = 'business_model_directives']/value]"/>
	<xsl:variable name="busModelDirectiveStatements" select="/node()/simple_instance[name = $busModelDirectives/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
	
	<xsl:variable name="busModelChangeMgtDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = 'Change_Management']"/>
	
	<xsl:variable name="busModelDomain" select="/node()/simple_instance[name = $currentBusModel/own_slot_value[slot_reference = 'bm_business_domain']/value]"/>
	<xsl:variable name="busModelGoals" select="/node()/simple_instance[(type = 'Business_Goal') and (name = $currentBusModel/own_slot_value[slot_reference = 'bm_business_goals_objectives']/value)]"/>
	
	<xsl:variable name="busModelArchitecture" select="/node()/simple_instance[name = $currentBusModel/own_slot_value[slot_reference = 'business_model_architecture']/value]"/>
	<xsl:variable name="busModelArchElements" select="/node()/simple_instance[name = $busModelArchitecture/own_slot_value[slot_reference = 'business_model_architecture_elements']/value]"/>
	
	<xsl:variable name="busModelRoleUsages" select="$busModelArchElements[type = 'Business_Model_Role_Usage']"/>
	<xsl:variable name="busModelRoles" select="/node()/simple_instance[name = $busModelRoleUsages/own_slot_value[slot_reference = 'bmtu_used_role']/value]"/>
	<xsl:variable name="mainBusModelRoleUsages" select="$busModelRoleUsages[own_slot_value[slot_reference = 'bmat_operating_model_category']/value = $mainOpModelCategories/name]"/>
	<xsl:variable name="mainBusModelRoles" select="$busModelRoles[name = $mainBusModelRoleUsages/own_slot_value[slot_reference = 'bmtu_used_role']/value]"/>
	
	<xsl:variable name="busModelExternalRoles" select="$busModelRoles[own_slot_value[slot_reference = 'external_to_enterprise']/value = 'true']"/>
	<xsl:variable name="busModelInternalRoles" select="$busModelRoles except $busModelExternalRoles"/>
	<xsl:variable name="busModelInternalRoleUsages" select="$busModelRoleUsages[own_slot_value[slot_reference = 'bmtu_used_role']/value = $busModelInternalRoles/name]"/>
	
	<xsl:variable name="busModelRoleDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = 'Group_Business_Role']"/>
	<xsl:variable name="busModelRoleOversight" select="$busModelRoleDirectives[own_slot_value[slot_reference = 'bmd_for_operating_model_category']/value = $oversightOpModelCategory/name]"/>
	<xsl:variable name="mainBusModelRoleDirectives" select="$busModelRoleDirectives except $busModelRoleOversight"/>
	
	<xsl:variable name="busModelProdUsages" select="$busModelArchElements[type = 'Business_Model_Product_Usage']"/>
	<xsl:variable name="allBusModelProdTypes" select="/node()/simple_instance[name = $busModelProdUsages/own_slot_value[slot_reference = 'bmpu_used_product']/value]"/>
	<xsl:variable name="busModelProdConcepts" select="$allBusModelProdTypes[type = 'Product_Concept']"/>
	<xsl:variable name="busModelProdTypes" select="$allBusModelProdTypes[type = ('Product_Type', 'Composite_Product_Type')]"/>
	<xsl:variable name="busModelProdDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = ('Product_Concept', 'Product_Type', 'Composite_Product_Type')]"/>
	<xsl:variable name="busModelValueStreams" select="/node()/simple_instance[own_slot_value[slot_reference = 'vs_product_types']/value = $busModelProdTypes/name]"/>
	<xsl:variable name="busModelValueStages" select="/node()/simple_instance[name = $busModelValueStreams/own_slot_value[slot_reference = 'vs_value_stages']/value]"/>
	
	<xsl:variable name="busModelBusUsages" select="$busModelArchElements[type = 'Business_Model_Business_Usage']"/>
	<xsl:variable name="busModelBusCaps" select="/node()/simple_instance[(name = $busModelBusUsages/own_slot_value[slot_reference = 'bmbu_used_business_capability']/value) and (type = 'Business_Capability')]"/>
	<xsl:variable name="busModelBusCapDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = 'Business_Capability']"/>
	
	<xsl:variable name="busModelInfoUsages" select="$busModelArchElements[type = 'Business_Model_Information_Usage']"/>
	<xsl:variable name="busModelInfoConcepts" select="/node()/simple_instance[(name = $busModelInfoUsages/own_slot_value[slot_reference = 'bmiu_used_information']/value) and (type = 'Information_Concept')]"/>
	<xsl:variable name="busModelInfoDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = ('Information_Concept', 'Information_View')]"/>
	
	<xsl:variable name="busModelAppUsages" select="$busModelArchElements[type = 'Business_Model_Application_Usage']"/>
	<xsl:variable name="busModelApps" select="/node()/simple_instance[(name = $busModelAppUsages/own_slot_value[slot_reference = 'bmau_used_application']/value) and (type = ('Application_Capability', 'Composite_Application_Service'))]"/>
	<xsl:variable name="busModelAppDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = ('Application_Capability', 'Composite_Application_Service')]"/>
	
	
	<xsl:variable name="busModelTechUsages" select="$busModelArchElements[type = 'Business_Model_Technology_Usage']"/>
	<xsl:variable name="busModelTech" select="/node()/simple_instance[(name = $busModelTechUsages/own_slot_value[slot_reference = 'bmtu_used_technology']/value) and (type = ('Technology_Capability', 'Technology_Composite'))]"/>
	<xsl:variable name="busModelTechDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = ('Technology_Capability', 'Technology_Composite')]"/>
	
	<xsl:variable name="childOpModelCategories" select="$mainOpModelCategories[own_slot_value[slot_reference = 'contained_in_operating_model_category']/value = $mainOpModelCategories/name]"/>
	<xsl:variable name="relevantChildOpModelCategories" select="$childOpModelCategories[name = ($busModelBusUsages, $busModelBusCapDirectives)/own_slot_value[slot_reference = ('bmat_operating_model_category', 'bmd_for_operating_model_category')]/value]"/>
	<xsl:variable name="relevantParentOpModelCategories" select="($mainOpModelCategories except $childOpModelCategories)[(name = ($busModelBusUsages, $busModelBusCapDirectives)/own_slot_value[slot_reference = ('bmat_operating_model_category', 'bmd_for_operating_model_category')]/value) or (own_slot_value[slot_reference = 'contains_operating_model_categories']/value = $relevantChildOpModelCategories/name)]"/>

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


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Business Model Overview</title>
				<xsl:call-template name="styles"/>
				<script>
					$(document).ready(function(){
						$('.model-section-title span').each(function() {
						  var slash = $(this).text().replace('/', ' / ');
						  $(this).text(slash);
						});
					});
				</script>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Model Overview')"/></span>
								</h1><xsl:value-of select="$DEBUG"/>
								<p class="xlarge fontLight top-15 bottom-15"><xsl:value-of select="eas:i18n('The model below shows an overview of the')"/>&#160;<strong><xsl:value-of select="$currentBusModelLink"/></strong>&#160;<xsl:value-of select="eas:i18n('in terms of Business and IT operations')"/></p>
							</div>
						</div>
					</div>
					<div class="simple-scroller bottom-30">
						<xsl:call-template name="model"/>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="styles">
		<style>
			.model-full-width-wrapper,
			.model-roof,
			.model-center-section,
			.model-lr-col-wrapper{
				box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.15);
			}
			
			.roof-spacer{
				height: 50px;
			}
			
			.roof-wrapper{
				display: flex;
				box-shadow: 0 1px 0px 0 rgba(0, 0, 0, 0.25);
			}
			
			.roof{
				width: 100%;
				height: 50px;
				/* The points are: centered top, left bottom, right bottom */
				clip-path: polygon(50% 0, 0 100%, 100% 100%);
			}
			
			.roof-title{
				font-weight: 700;
				font-size: 115%;
				margin-bottom: 5px;
				text-align: center;
				padding-top: 20px;
			}
			
			.model-outer,
			.roof-outer{
				display: flex;
			}
			
			.model-left-wrapper,
			.roof-spacer{
				width: 200px;
				min-width: 200px;
				display: flex;
				flex-flow: row wrap;
			}
			
			.model-main-wrapper,
			.roof-wrapper{
				width: calc(100% - 200px);
				min-width: 570px;
			}
			
			.model-main-top-wrapper{
				width: 100%;
				position: relative;
			}
			
			.main-body{
				display: flex;
				flex-flow: row wrap;
			}
			
			.model-full-width-wrapper{
				width: 100%;
				padding: 10px;
			}
			
			.goals{
				width: calc(100% - 200px);
				position: relative;
				left: 200px;
				padding: 10px;
				margin-bottom: 20px;
				border-radius: 32px;
				text-align: center!important;
			}
			
			.model-center-wrapper{
				width: calc(100% - 400px);
				margin-right: 10px;
				min-width: 140px;
			}
			
			.model-center-section{
				width: 100%;
				padding: 10px;
			}
			
			.model-lr-col-wrapper{
				width: 190px;
				padding: 10px;
			}
			
			.model-lr-col-wrapper.left{
				margin-right: 10px;
			}
			
			.model-lr-col-wrapper.right{
				margin-right: 0px;
			}
			
			.model-section-title{
				font-weight: 700;
				font-size: 100%;
				margin-bottom: 5px;
				line-height: 1.1em;
				padding-left: 20px;
				text-indent: -10px;
			}
			
			.model-l1-cap-wrapper > .model-section-title{
				font-size: 90%;
				line-height: 1.1em;
				padding-left: 0px;
				text-indent: 0px;
			}
			
			.model-l1-cap-wrapper{
				padding: 10px;
				border: 1px solid #aaa;
				margin-bottom: 10px;
				width: 100%;
			}
			
			.model-section-elements-wrapper{
				width: 100%;
				<!--display: flex;-->
				flex-flow: row wrap;
			}
			
			.model-section-elements-wrapper > ul,
			.model-l1-cap-wrapper > ul{
				margin: 0;
				padding: 0;
				list-style-type: none;
				display: flex;
				flex-flow: row wrap;
				margin-top: 10px;
				text-align: center;
			}
			
			.model-section-elements-wrapper > ul > li,
			.model-l1-cap-wrapper > ul > li{
				margin: 0 5px 5px 0;
				padding: 5px;
				width: 120px;
				height: 50px;
				border: 1px solid #aaa;
				box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.15);
				background-color: #fff;
				display: flex;
				align-items: center;
				justify-content: center;
				text-align: center;
			}
			
			li > .element-label{
				color: #333;
				font-size: 85%;
			}
			
			.element-label > a{
				color: #333;
			}
			
			.rotate {
			  padding-top: 30px;
			  padding-left: 20px;
			  transform: rotate(90deg);
			  /* Legacy vendor prefixes that you probably don't need... */
			  /* Safari */
			  -webkit-transform: rotate(90deg);
			  /* Firefox */
			  -moz-transform: rotate(90deg);
			  /* IE */
			  -ms-transform: rotate(90deg);
			  /* Opera */
			  -o-transform: rotate(90deg);
			  /* Internet Explorer */
			  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1);
			}
			
			.anti-rotate {
			  padding-top: 30px;
			  padding-left: 20px;
			  transform: rotate(-90deg);
			  /* Legacy vendor prefixes that you probably don't need... */
			  /* Safari */
			  -webkit-transform: rotate(-90deg);
			  /* Firefox */
			  -moz-transform: rotate(-90deg);
			  /* IE */
			  -ms-transform: rotate(-90deg);
			  /* Opera */
			  -o-transform: rotate(-90deg);
			  /* Internet Explorer */
			  filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
			}
			
			.bm-goal {
				font-weight: 500;
				font-size: 1.2em;
			}
			
			.threeColModel_valueChainColumnContainer .threeColModel_modalValueChainColumnContainer{
			    margin-right: 8px;
			    float: left;
			    position: relative;
				background-color: #fff;
				color: #999;
			    box-sizing: content-box;
			    display: table;
			}
			
			.threeColModel_valueChainObject{
			    width: 115px;
			    padding: 5px 20px 5px 5px;
			    height: 40px;
			    text-align: center;
			    background-image: url(images/value_chain_arrow_end.png);
			    background-repeat: no-repeat;
			    background-position: right center;
			    position: relative;
			    box-sizing: content-box;
			    display: table-cell;
			    vertical-align:middle;
			}
			
			
			.threeColModel_valueChainObject:hover{
			    opacity: 0.75;
			    cursor: pointer;
			    box-sizing: content-box;
			}
			
			/* Alternative styling which is less multi-colour swap-shop */
			/*
			.bg-lightblue-20,.bg-lightgreen-20,.bg-darkgreen-20,.bg-brightred-20,.bg-aqua-20,.bg-orange-20,.bg-darkblue-40{
				background-color: #f3f3f3;
				border-left: 5px solid;
			}
			.bg-darkblue-20{
				background-color: #ddd;
				border-left: 5px solid;
			}
			*/
			
		</style>
	</xsl:template>

	<xsl:template name="model">
		<xsl:if test="count($busModelGoals) > 0">
			<!--GOALS-->
			<div class="model-full-width-wrapper goals bottom-10 bg-pink-20">
				<div class="model-section-title"><i class="fa fa-bullseye right-5"/><span><xsl:value-of select="eas:i18n('Goals')"/></span></div>
				<div class="model-section-elements-wrapper">
					<xsl:apply-templates mode="RenderBusModelGoal" select="$busModelGoals">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					</xsl:apply-templates>
				</div>
			</div>
		</xsl:if>
		<!-- Triangular roof section -->
		<div class="roof-outer">
			<div class="roof-spacer"/>
			<div class="roof-wrapper bottom-10">
				<div class="roof bg-darkgreen-40 ">
					<div class="roof-title"><xsl:value-of select="$currentBusModelLink"/></div>
				</div>
			</div>
		</div>
		<!-- Main overview section -->
		<div class="model-outer">
			<!-- Business Model Goals and External Roles sections  -->
			<xsl:call-template name="left"/>
			<!-- Main EA elements section -->
			<xsl:call-template name="main"/>
		</div>
	</xsl:template>

	<!--THE LEFT PART OF THE MODEL AKA THE EXTENSION OF THE HOUSE-->
	<xsl:template name="left">
		<div class="model-left-wrapper">
			<!--EXT ROLES-->
			<xsl:if test="count(($mainBusModelRoles, $mainBusModelRoleDirectives))  > 0">
				<xsl:variable name="directiveStatements" select="$busModelDirectiveStatements[name = $mainBusModelRoleDirectives/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
				<div class="model-lr-col-wrapper left bg-lightblue-20">
					<div class="model-section-title"><i class="fa fa-users right-5"/><span><xsl:value-of select="eas:i18n('Key Stakeholders')"/></span></div>
					<xsl:apply-templates mode="RenderDirectiveStatement" select="$directiveStatements"/>
					<div class="model-section-elements-wrapper">
						<ul>
							<xsl:apply-templates mode="RenderBusModelBasicElement" select="$mainBusModelRoles">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>							
						</ul>
					</div>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!--THE MAIN PART OF THE HOUSE-->
	<xsl:template name="main">
		<div class="model-main-wrapper">
			<xsl:call-template name="main-top"/>
			<div class="main-body">
				<xsl:call-template name="app-directives"/>
				<xsl:call-template name="bus-cap-directives"/>
				<xsl:call-template name="change-mgt-directives">
					<xsl:with-param name="thisDirective" select="$busModelChangeMgtDirectives[1]"/>
				</xsl:call-template>
			</div>
			<div class="clearfix"/>
			<xsl:call-template name="tech-directives"/>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderValueStream" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisValueStages" select="$busModelValueStages[name = $this/own_slot_value[slot_reference = 'vs_value_stages']/value]"/>
		<div class="model-section-title">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</div>
		<div class="threeColModel_valueChainColumnContainer top-15">
			<xsl:for-each select="$thisValueStages">
				<xsl:sort select="own_slot_value[slot_reference = 'vsg_index']/value"/>
				<xsl:variable name="thisVStg" select="current()"/>
				<xsl:variable name="thisLabel">
					<xsl:choose>
						<xsl:when test="own_slot_value[slot_reference = 'vsg_display_label']/value">
							<xsl:value-of select="own_slot_value[slot_reference = 'vsg_display_label']/value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="RenderMultiLangCommentarySlot">
								<xsl:with-param name="theSubjectInstance" select="$thisVStg"/>
								<xsl:with-param name="slotName">vsg_label</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<div class="threeColModel_modalValueChainColumnContainer pull-left">
					<div class="threeColModel_valueChainObject small bg-purple-20">
						<xsl:value-of select="$thisLabel"/>
					</div>
				</div>				
			</xsl:for-each>
		</div>
		<div class="clearfix bottom-20"/>
	</xsl:template>


	<xsl:template name="main-top">
		<!--BUSINESS ROLES-->
		<div class="model-main-top-wrapper">
			<!--<xsl:apply-templates mode="RenderBusModelOversightDirective" select="$busModelRoleOversight">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>-->
			<xsl:if test="count(($busModelProdConcepts, $busModelProdTypes, $busModelProdDirectives)) > 0">
				<div class="model-full-width-wrapper bottom-10 bg-darkgreen-20">
					<div class="model-section-title"><i class="fa fa-money right-5"/><span><xsl:value-of select="eas:i18n('Products/Services')"/></span></div>
					<xsl:apply-templates mode="RenderDirectiveStatement" select="$busModelProdDirectives"/>
					<div class="model-section-elements-wrapper">				
						<ul>
							<xsl:apply-templates mode="RenderBusModelBasicElement" select="($busModelProdConcepts, $busModelProdTypes)">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</div>			
				</div>
			</xsl:if>
			<xsl:if test="count(($busModelValueStreams, $busModelValueStages)) > 0">
				<div class="model-full-width-wrapper bottom-10 bg-purple-20">
					<div class="model-section-title"><i class="fa fa-chevron-right right-5"/><span><xsl:value-of select="eas:i18n('Value Streams')"/></span></div>
					<div class="model-l1-cap-wrapper bg-white">
						<xsl:apply-templates mode="RenderValueStream" select="$busModelValueStreams">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</div>
				</div>
			</xsl:if>
			
			<!--<xsl:if test="count(($busModelInfoConcepts, $busModelInfoDirectives)) > 0">
				<div class="model-full-width-wrapper bottom-10 bg-lightgreen-20">
					<div class="model-section-title"><i class="fa fa-chevron-right right-5"/><span><xsl:value-of select="eas:i18n('Value Streams')"/></span></div>
					
				</div>
			</xsl:if>-->
		</div>
		<div class="clearfix"/>
		
	</xsl:template>
	
	
	

	<xsl:template name="app-directives">
		<!--APPPLICATION CAPABILITIES-->
		<div class="model-lr-col-wrapper left bottom-10 bg-brightred-20">
			<xsl:choose>
				<xsl:when test="count(($busModelAppDirectives, $busModelApps)) > 0">
					<xsl:variable name="this" select="$busModelAppDirectives[1]"/>
					
					<!--<xsl:variable name="thisDirectives" select="$busModelBusCapDirectives[own_slot_value[slot_reference = 'bmd_for_operating_model_category']/value = $this/name]"/>-->
					<xsl:variable name="directiveStatements" select="$busModelDirectiveStatements[name = $busModelAppDirectives/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
					
					<div class="model-section-title"><i class="fa fa-desktop right-5"/>
						<span><xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="$this"/>
						</xsl:call-template></span>
					</div>
					<xsl:apply-templates mode="RenderAntiVerticalDirectiveStatement" select="$directiveStatements"/>
					<div class="model-section-elements-wrapper">
						<ul>
							<xsl:apply-templates mode="RenderBusModelBasicElement" select="$busModelApps">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="model-section-title"><i class="fa fa-desktop right-5"/><span>Application Capabilities</span></div>
				</xsl:otherwise>
			</xsl:choose>
			
			
		</div>
	</xsl:template>

	<xsl:template name="bus-cap-directives">
		<!--BUSINESS CAPABILITIES-->
		<div class="model-center-wrapper bottom-10">
			<xsl:apply-templates mode="RenderBusModelBusCap" select="$relevantParentOpModelCategories">
				<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
			</xsl:apply-templates>
			<!--<!-\-IF NOT LAST END-\->
			<div class="model-center-section bg-darkblue-20">
				<div class="model-section-title"><i class="fa fa-sitemap right-5"/>Business Capabilities - Middle</div>
				<div class="model-section-elements-wrapper">
					<div class="model-l1-cap-wrapper bg-darkblue-40">
						<div class="model-section-title">Some Bus Cap</div>
						<ul>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
						</ul>
					</div>
					<div class="model-l1-cap-wrapper bg-darkblue-40">
						<div class="model-section-title">Some Bus Cap</div>
						<ul>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<!-\-IF NOT LAST-\->
			<div class="clearfix bottom-10"/>
			<!-\-IF NOT LAST END-\->
			<div class="model-center-section bg-darkblue-20">
				<div class="model-section-title"><i class="fa fa-sitemap right-5"/>Business Capabilities - Back</div>
				<div class="model-section-elements-wrapper">
					<div class="model-l1-cap-wrapper bg-darkblue-40">
						<div class="model-section-title">Some Bus Cap</div>
						<ul>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
						</ul>
					</div>
					<div class="model-l1-cap-wrapper bg-darkblue-40">
						<div class="model-section-title">Some Bus Cap</div>
						<ul>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
							<li>
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>-->
		</div>
	</xsl:template>
	
	<xsl:template mode="RenderBusModelBusCap" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisDirectives" select="$busModelBusCapDirectives[own_slot_value[slot_reference = 'bmd_for_operating_model_category']/value = $this/name]"/>
		<xsl:variable name="directiveStatements" select="$busModelDirectiveStatements[name = $thisDirectives/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
		
		<xsl:variable name="childBusModelCats" select="$relevantChildOpModelCategories[name = $this/own_slot_value[slot_reference = 'contains_operating_model_categories']/value]"/>
		
		<div class="model-center-section bg-darkblue-20">
			<div class="model-section-title"><i class="fa fa-sitemap right-5"/>
				<span><xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template></span>
			</div>
			<xsl:apply-templates mode="RenderDirectiveStatement" select="$directiveStatements"/>
			<xsl:choose>
				<xsl:when test="count($childBusModelCats) = 0">
					<xsl:variable name="thisBusModelBusUsages" select="$busModelBusUsages[own_slot_value[slot_reference = 'bmat_operating_model_category']/value = $this/name]"/>
					<xsl:variable name="thisBusModelBusCaps" select="$busModelBusCaps[name = $thisBusModelBusUsages/own_slot_value[slot_reference = 'bmbu_used_business_capability']/value]"/>
					
					<div class="model-section-elements-wrapper">
						<ul>
							<xsl:apply-templates mode="RenderBusModelBasicElement" select="$thisBusModelBusCaps">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="model-section-elements-wrapper">
						<xsl:apply-templates mode="RenderChildBusModelBusCap" select="$childBusModelCats">
							<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
						</xsl:apply-templates>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			<!--<div class="model-section-elements-wrapper">
				<ul>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
				</ul>
			</div>-->
		</div>
		<!--IF NOT LAST-->
		<xsl:if test="not(position() = last())">
			<div class="clearfix bottom-10"/>
		</xsl:if>	
	</xsl:template>
	
	
	<xsl:template mode="RenderChildBusModelBusCap" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisDirectives" select="$busModelBusCapDirectives[own_slot_value[slot_reference = 'bmd_for_operating_model_category']/value = $this/name]"/>
		<xsl:variable name="directiveStatements" select="$busModelDirectiveStatements[name = $thisDirectives/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
		
		<xsl:variable name="thisBusModelBusUsages" select="$busModelBusUsages[own_slot_value[slot_reference = 'bmat_operating_model_category']/value = $this/name]"/>
		<xsl:variable name="thisBusModelBusCaps" select="$busModelBusCaps[name = $thisBusModelBusUsages/own_slot_value[slot_reference = 'bmbu_used_business_capability']/value]"/>
		
		<div class="model-l1-cap-wrapper bg-darkblue-40">
			<div class="model-section-title">
				<span><xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template></span>
			</div>
			<xsl:apply-templates mode="RenderDirectiveStatement" select="$directiveStatements"/>
			<ul>
				<xsl:apply-templates mode="RenderBusModelBasicElement" select="$thisBusModelBusCaps">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
		</div>
		
	</xsl:template>


	<!--CHANGE MANAGEMENT SECTION -->
	<xsl:template name="change-mgt-directives">
		<xsl:param name="thisDirective" select="()"/>
		
		<xsl:variable name="directiveStatements" select="$busModelDirectiveStatements[name = $thisDirective/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
		
		<div class="model-lr-col-wrapper right bottom-10 bg-aqua-20">
			<xsl:choose>
				<xsl:when test="count($thisDirective) > 0">
					<xsl:variable name="thisName">
						<xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="$thisDirective"/>
						</xsl:call-template>
					</xsl:variable>
					<div class="model-section-title"><i class="fa fa-road right-5"/><span><xsl:value-of select="$thisName"/></span></div>
					<xsl:apply-templates mode="RenderVerticalDirectiveStatement" select="$directiveStatements"/>
					<!--<div class="model-section-elements-wrapper">
						<ul>
							<li>ation 
								<div class="element-label">
									<a href="#">Element</a>
								</div>
							</li>
						</ul>
					</div>-->
				</xsl:when>
				<xsl:otherwise>
					<div class="model-section-title"><i class="fa fa-road right-5"/><span><xsl:value-of select="eas:i18n('Change Management')"/></span></div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template name="tech-directives">
		<!--TECHNOLOGY CAPABILITIES-->
		<div class="model-full-width-wrapper bg-orange-20">
			<xsl:choose>
				<xsl:when test="count($busModelTechDirectives) > 0">
					<xsl:variable name="this" select="$busModelTechDirectives[1]"/>
					
					<!--<xsl:variable name="thisDirectives" select="$busModelBusCapDirectives[own_slot_value[slot_reference = 'bmd_for_operating_model_category']/value = $this/name]"/>-->
					<xsl:variable name="directiveStatements" select="$busModelDirectiveStatements[name = $busModelTechDirectives/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>

					<div class="model-section-title"><i class="fa fa-server right-5"/>
						<span><xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="$this"/>
						</xsl:call-template></span>
					</div>
					<xsl:apply-templates mode="RenderDirectiveStatement" select="$directiveStatements"/>
					<div class="model-section-elements-wrapper">
						<ul>
							<xsl:apply-templates mode="RenderBusModelBasicElement" select="$busModelTech">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="model-section-title"><i class="fa fa-desktop right-5"/><span>Application Capabilities</span></div>
				</xsl:otherwise>
			</xsl:choose>
			<!--<div class="model-section-title"><i class="fa fa-server right-5"/>Technology Platform</div>
			<p>Direction for Technology</p>
			<div class="model-section-elements-wrapper">
				<ul>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
					<li>
						<div class="element-label">
							<a href="#">Element</a>
						</div>
					</li>
				</ul>
			</div>-->
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelBasicElement" match="node()">
		<xsl:variable name="this" select="current()"/>
		<li>
			<div class="element-label">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template>
			</div>
		</li>
	</xsl:template>
	
	
	<xsl:template mode="RenderDirectiveStatement" match="node()">
		<xsl:variable name="this" select="current()"/>
		<div>
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderVerticalDirectiveStatement" match="node()">
		<xsl:variable name="this" select="current()"/>
		<!--<p class="rotate">-->
		<div>
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderAntiVerticalDirectiveStatement" match="node()">
		<xsl:variable name="this" select="current()"/>
		<!--<p class="anti-rotate">-->
		<div>	
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelOversightDirective" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="directiveStatements" select="$busModelDirectiveStatements[name = $this/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
		<div class="model-full-width-wrapper bottom-10 bg-darkgreen-20">
			<div class="model-section-title"><i class="fa fa-user right-5"/>
				<span><xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template></span>
			</div>
			<xsl:apply-templates mode="RenderDirectiveStatement" select="$directiveStatements"/>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelProduct" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="directiveStatements" select="$busModelProdDirectives[name = $this/own_slot_value[slot_reference = 'bmd_directive_statements']/value]"/>
		<div class="model-full-width-wrapper bottom-10 bg-darkgreen-20">
			<!--<div class="model-section-title"><i class="fa fa-user right-5"/>
				<span><xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template></span>
			</div>-->
			<div class="model-section-title"><i class="fa fa-box right-5"/><span><xsl:value-of select="eas:i18n('Products/Services')"/></span></div>
			<xsl:apply-templates mode="RenderDirectiveStatement" select="$directiveStatements"/>
			<div class="model-section-elements-wrapper">				
				<ul>
					<xsl:apply-templates mode="RenderBusModelBasicElement" select="($busModelProdConcepts, $busModelProdTypes)">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					</xsl:apply-templates>
				</ul>
			</div>			
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelInternalRole" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisRole" select="$busModelInternalRoles[name = $this/own_slot_value[slot_reference = 'bmtu_used_role']/value]"/>
		<div class="model-full-width-wrapper bottom-10 bg-darkgreen-20">
			<div class="model-section-title"><i class="fa fa-user right-5"/>
				<span><xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisRole"/>
				</xsl:call-template></span>
			</div>
			<p>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template>
			</p>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelGoal" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!--<p class="anti-rotate bm-goal">-->
		<div>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelInfoConcept" match="node()">
		<li>
			<div class="element-label">
				<a href="#">Element</a>
			</div>
		</li>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelCompAppService" match="node()">
		<li>
			<div class="element-label">
				<a href="#">Element</a>
			</div>
		</li>
	</xsl:template>
	
	<xsl:template mode="RenderBusModelExternalRole" match="node()">
		<li>
			<div class="element-label">
				<a href="#">Element</a>
			</div>
		</li>
	</xsl:template>


</xsl:stylesheet>
