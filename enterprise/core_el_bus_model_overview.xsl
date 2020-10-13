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
	<xsl:variable name="linkClasses" select="('Business_Model', 'Business_Capability', 'Group_Business_Role', 'Application_Capability', 'Composite_Application_Service', 'Application_Provider', 'Information_Concept', 'Information_View', 'Technology_Capability', 'Technology_Composite')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	
	<!-- GET THE VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="currentBusModel" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentBusModelLink">
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="$currentBusModel"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="busModelDirectives" select="/node()/simple_instance[name = $currentBusModel/own_slot_value[slot_reference = 'business_model_directives']/value]"/>
	
	<xsl:variable name="busModelDomain" select="/node()/simple_instance[name = $currentBusModel/own_slot_value[slot_reference = 'bm_business_domain']/value]"/>
	<xsl:variable name="busModelGoals" select="/node()/simple_instance[(type = 'Business_Goal') and (name = $currentBusModel/own_slot_value[slot_reference = 'bm_business_goals_objectives']/value)]"/>
	
	<xsl:variable name="busModelArchitecture" select="/node()/simple_instance[name = $currentBusModel/own_slot_value[slot_reference = 'business_model_architecture']/value]"/>
	<xsl:variable name="busModelArchElements" select="/node()/simple_instance[name = $busModelArchitecture/own_slot_value[slot_reference = 'business_model_architecture_elements']/value]"/>
	
	<xsl:variable name="busModelRoleUsages" select="$busModelArchElements[type = 'Business_Model_Role_Usage']"/>
	<xsl:variable name="busModelRoles" select="/node()/simple_instance[name = $busModelRoleUsages/own_slot_value[slot_reference = 'bmtu_used_role']/value]"/>
	<xsl:variable name="busModelExternalRoles" select="$busModelRoles[own_slot_value[slot_reference = 'external_to_enterprise']/value = 'true']"/>
	<xsl:variable name="busModelInternalRoles" select="$busModelRoles except $busModelExternalRoles"/>
	
	<xsl:variable name="busModelRoleDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = 'Group_Business_Role']"/>
	
	<xsl:variable name="busModelBusUsages" select="$busModelArchElements[type = 'Business_Model_Business_Usage']"/>
	<xsl:variable name="busModelBusCaps" select="/node()/simple_instance[(name = $busModelBusUsages/own_slot_value[slot_reference = 'bmbu_used_business_capability']/value) and (type = 'Business_Capability')]"/>
	<xsl:variable name="busModelBusCapDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = 'Business_Capability']"/>
	
	<xsl:variable name="busModelInfoUsages" select="$busModelArchElements[type = 'Business_Model_Information_Usage']"/>
	<xsl:variable name="busModelInfoConcepts" select="/node()/simple_instance[(name = $busModelInfoUsages/own_slot_value[slot_reference = 'bmiu_used_information']/value) and (type = 'Information_Concept')]"/>
	<xsl:variable name="busModelInfoDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = ('Information_Concept', 'Information_View')]"/>
	
	<xsl:variable name="busModelAppUsages" select="$busModelArchElements[type = 'Business_Model_Application_Usage']"/>
	<xsl:variable name="busModelCompAppServices" select="/node()/simple_instance[(name = $busModelAppUsages/own_slot_value[slot_reference = 'bmau_used_application']/value) and (type = 'Composite_Application_Service')]"/>
	<xsl:variable name="busModelAppDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = ('Application_Capability', 'Composite_Application_Service')]"/>
	
	
	<xsl:variable name="busModelTechUsages" select="$busModelArchElements[type = 'Business_Model_Technology_Usage']"/>
	<xsl:variable name="busModelCompTechComps" select="/node()/simple_instance[(name = $busModelTechUsages/own_slot_value[slot_reference = 'bmtu_used_technology']/value) and (type = 'Technology_Composite')]"/>
	<xsl:variable name="busModelTechDirectives" select="$busModelDirectives[own_slot_value[slot_reference = 'bmd_of_class']/value = ('Technology_Capability', 'Technology_Composite')]"/>
	
	

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
									<span class="text-darkgrey">Business Model Overview</span>
								</h1>
								<p class="xlarge fontLight top-15 bottom-15">The model below shows an overview of the Supply Chain Management operating model in terms of Business and IT adoption</p>
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
			.model-full-width-wrapper,
			.model-center-section,
			.model-lr-col-wrapper{
				box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.25);
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
				width: 300px;
				min-width: 300px;
				display: flex;
				flex-flow: row wrap;
			}
			
			.model-main-wrapper,
			.roof-wrapper{
				width: calc(100% - 300px);
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
			
			.model-center-wrapper{
				width: calc(100% - 300px);
				margin-right: 10px;
				min-width: 140px;
			}
			
			.model-center-section{
				width: 100%;
				padding: 10px;
			}
			
			.model-lr-col-wrapper{
				width: 140px;
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
				display: flex;
				flex-flow: row wrap;
			}
			
			.model-section-elements-wrapper > ul,
			.model-l1-cap-wrapper > ul{
				margin: 0;
				padding: 0;
				list-style-type: none;
				display: flex;
				flex-flow: row wrap;
			}
			
			.model-section-elements-wrapper > ul > li,
			.model-l1-cap-wrapper > ul > li{
				margin: 0 5px 5px 0;
				padding: 5px;
				width: 120px;
				height: 50px;
				border: 1px solid #ccc;
				box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.25);
				background-color: #fff;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			li > .element-label{
				color: #333;
				font-size: 85%;
			}
			
			.element-label > a{
				color: #333;
			}</style>
	</xsl:template>

	<!--THE ROOF OF THE HOUSE-->
	<xsl:template name="model">
		<div class="roof-outer">
			<div class="roof-spacer"/>
			<div class="roof-wrapper bottom-10">
				<div class="roof bg-darkgreen-40 ">
					<div class="roof-title">Supply Chain Management Business Operating Model</div>
				</div>
			</div>
		</div>
		<div class="model-outer">
			<xsl:call-template name="left"/>
			<xsl:call-template name="main"/>
		</div>
	</xsl:template>

	<!--THE LEFT PART OF THE MODEL AKA THE EXTENSION OF THE HOUSE-->
	<xsl:template name="left">
		<div class="model-left-wrapper">
			<!--GOALS-->
			<div class="model-lr-col-wrapper left bg-pink-20">
				<div class="model-section-title"><i class="fa fa-bullseye right-5"/>Goals</div>
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
				</div>
			</div>
			<!--EXT ROLES-->
			<div class="model-lr-col-wrapper left bg-lightblue-20">
				<div class="model-section-title"><i class="fa fa-users right-5"/>External Roles</div>
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
				</div>
			</div>
		</div>
	</xsl:template>

	<!--THE MAIN PART OF THE HOUSE-->
	<xsl:template name="main">
		<div class="model-main-wrapper">
			<xsl:call-template name="main-top"/>
			<div class="main-body">
				<xsl:call-template name="main-left"/>
				<xsl:call-template name="main-center"/>
				<xsl:call-template name="RenderBusModelChangeMgtDirection"/>
			</div>
			<div class="clearfix"/>
			<xsl:call-template name="RenderBusModelTechPlatform"/>
		</div>
	</xsl:template>


	<xsl:template name="main-top">
		<!--BUSINESS ROLES-->
		<div class="model-main-top-wrapper">
			<div class="model-full-width-wrapper bottom-10 bg-darkgreen-20">
				<div class="model-section-title"><i class="fa fa-user right-5"/>Finance Leadership</div>
				<p>Repsonsible for central overview and provision of direction for all Finance activities at the County</p>
			</div>
			<div class="model-full-width-wrapper bottom-10 bg-lightgreen-20">
				<div class="model-section-title"><i class="fa fa-file-text-o right-5"/>Information</div>
				<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut imperdiet sem a mauris suscipit auctor non non est. Nulla in malesuada mauris. Sed semper laoreet augue at rhoncus. Sed viverra enim eu lacus bibendum, in vulputate turpis convallis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse aliquet nunc nec metus consectetur auctor. Curabitur facilisis, enim a varius viverra, neque mauris pretium elit, eu euismod turpis erat feugiat nunc. Quisque vitae libero fermentum eros efficitur malesuada sed et justo</p>
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
				</div>
			</div>
		</div>
		<div class="clearfix"/>
	</xsl:template>

	<xsl:template name="main-left">
		<!--APPPLICATION CAPABILITIES-->
		<div class="model-lr-col-wrapper left bottom-10 bg-brightred-20">
			<div class="model-section-title"><i class="fa fa-desktop right-5"/>Application Capabilities</div>
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
			</div>
		</div>
	</xsl:template>

	<xsl:template name="main-center">
		<!--BUSINESS CAPABILITIES-->
		<div class="model-center-wrapper bottom-10">
			<div class="model-center-section bg-darkblue-20">
				<div class="model-section-title"><i class="fa fa-sitemap right-5"/>Business Capabilities - Front</div>
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
				</div>
			</div>
			<!--IF NOT LAST-->
			<div class="clearfix bottom-10"/>
			<!--IF NOT LAST END-->
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
			<!--IF NOT LAST-->
			<div class="clearfix bottom-10"/>
			<!--IF NOT LAST END-->
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
			</div>
		</div>
	</xsl:template>

	<xsl:template name="RenderBusModelChangeMgtDirection">
		<!--CHANGE MANAGEMENT-->
		<div class="model-lr-col-wrapper right bottom-10 bg-aqua-20">
			<div class="model-section-title"><i class="fa fa-road right-5"/>Change Management</div>
			<p>This is the direction for change management</p>
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
				</ul>
			</div>-->
		</div>
	</xsl:template>

	<xsl:template name="RenderBusModelTechPlatform">
		<!--TECHNOLOGY CAPABILITIES-->
		<div class="model-full-width-wrapper bg-orange-20">
			<div class="model-section-title"><i class="fa fa-server right-5"/>Technology Platform</div>
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
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelInternalRole" match="node()">
		<div class="model-full-width-wrapper bottom-10 bg-darkgreen-20">
			<div class="model-section-title"><i class="fa fa-user right-5"/>Finance Leadership</div>
			<p>Repsonsible for central overview and provision of direction for all Finance activities at the County</p>
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderBusModelInfoConcept" match="node()">
		<li>
			<div class="element-label">
				<a href="#">Element</a>
			</div>
		</li>
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
	
	<xsl:template mode="RenderBusModelGoal" match="node()">
		<li>
			<div class="element-label">
				<a href="#">Element</a>
			</div>
		</li>
	</xsl:template>

</xsl:stylesheet>
