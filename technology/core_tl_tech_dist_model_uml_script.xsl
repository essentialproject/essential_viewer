<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>

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
	<!--01.09.2011 NJW Updated to Support Viewer v3-->

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>

	<!-- xSize = an optional width of the resulting model in pixels -->
	<xsl:param name="xSize"/>

	<!-- ySize = an optional height of the resulting model in pixels -->
	<xsl:param name="ySize"/>

	<xsl:variable name="rootEnvConstantName" select="'Technology Distribution Model - Root Technology Composite'"/>
	<xsl:variable name="rootEnvConstant" select="/node()/simple_instance[(own_slot_value[slot_reference = 'report_constant_short_name']/value = $rootEnvConstantName) and (own_slot_value[slot_reference = 'element_classified_by']/value = $param4)]"/>


	<xsl:variable name="taxonomyTerms" select="/node()/simple_instance[type = 'Taxonomy_Term']"/>
	<xsl:variable name="primaryTechUsageType" select="$taxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Primary']"/>
	<xsl:variable name="secondaryTechUsageType" select="$taxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Secondary']"/>


	<xsl:variable name="rootEnv" select="/node()/simple_instance[name = $rootEnvConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="rootEnvArchitecture" select="/node()/simple_instance[name = $rootEnv/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="childEnvUsages" select="/node()/simple_instance[name = $rootEnvArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>
	<xsl:variable name="childEnvironments" select="/node()/simple_instance[name = $childEnvUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>

	<xsl:variable name="childEnvArchitectures" select="/node()/simple_instance[name = $childEnvironments/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="childEnvComponentUsages" select="/node()/simple_instance[name = $childEnvArchitectures/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>
	<xsl:variable name="childEnvDependencies" select="/node()/simple_instance[name = $childEnvArchitectures/own_slot_value[slot_reference = 'invoked_functions_relations']/value]"/>
	<xsl:variable name="childEnvComponents" select="/node()/simple_instance[name = $childEnvComponentUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>



	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="count($rootEnvArchitecture) > 0"> @startuml skinparam svek true skinparam packageStyle rect skinparam classBackgroundColor #ffffff skinparam classBorderColor #666666 skinparam classArrowColor #666666 skinparam classFontColor #333333 skinparam classFontSize 11 skinparam classFontName Arial skinparam circledCharacterFontColor #ffffff skinparam packageFontName "Arial Black" skinparam packageFontSize 14 skinparam packageFontColor #333333 skinparam packageBorderColor #666666 skinparam packageFontStyle normal skinparam packageBackgroundColor #a9c66f hide empty members hide circle <xsl:apply-templates mode="RenderExternalTechComponent" select="$childEnvironments[type = 'Technology_Component']"/>
				<xsl:apply-templates mode="RenderEnvironment" select="$childEnvironments[type = 'Technology_Composite']"/>
				<xsl:apply-templates mode="RenderEnvTechCompDependencies" select="$childEnvironments[type = 'Technology_Composite']"/>
				<xsl:apply-templates mode="RenderEnvironmentLinks" select="$childEnvironments[type = 'Technology_Composite']"/>
				<xsl:apply-templates mode="RenderTechComponentLink" select="$childEnvironments[type = 'Technology_Component']"/> @enduml </xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderEmptyUMLModel">
					<xsl:with-param name="message">
						<xsl:value-of select="eas:i18n('No Root Environment Architecture Defined')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Package -->
	<xsl:template match="node()" mode="RenderEnvironment">
		<xsl:variable name="locationName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="thisChildEnvArchitecture" select="$childEnvArchitectures[name = current()/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
		<xsl:variable name="thisChildEnvComponentUsages" select="$childEnvComponentUsages[(name = $thisChildEnvArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value) and (not(own_slot_value[slot_reference = 'element_classified_by']/value = $secondaryTechUsageType/name))]"/>
		<xsl:variable name="thisChildEnvComponents" select="$childEnvComponents[name = $thisChildEnvComponentUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/> package "<xsl:value-of select="$locationName"/>" { <xsl:apply-templates mode="RenderTechComponent" select="$thisChildEnvComponents">
			<xsl:with-param name="locationName" select="$locationName"/>
		</xsl:apply-templates> }&#10;&#10; </xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a Technology Component as a UML Class -->
	<xsl:template match="node()" mode="RenderTechComponent">
		<xsl:param name="locationName"/>
		<xsl:variable name="techCompName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="fullTechCompName" select="concat($locationName, $techCompName)"/>
		<xsl:variable name="strippedTechCompName" select="translate($fullTechCompName, translate($fullTechCompName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

		<xsl:call-template name="DeclareElementAsClass">
			<xsl:with-param name="fullName" select="$strippedTechCompName"/>
			<xsl:with-param name="displayName" select="$techCompName"/>
		</xsl:call-template>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render an External Technology Component as a UML Class -->
	<xsl:template match="node()" mode="RenderExternalTechComponent">
		<xsl:variable name="techCompName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="strippedTechCompName" select="translate($techCompName, translate($techCompName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

		<xsl:call-template name="DeclareElementAsClass">
			<xsl:with-param name="fullName" select="$strippedTechCompName"/>
			<xsl:with-param name="displayName" select="$techCompName"/>
		</xsl:call-template>

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Package -->
	<xsl:template match="node()" mode="RenderEnvironmentLinks">
		<xsl:variable name="locationName" select="own_slot_value[slot_reference = 'name']/value"/>

		<xsl:variable name="thisChildEnvArchitecture" select="$childEnvArchitectures[name = current()/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
		<xsl:variable name="thisChildEnvComponentUsages" select="$childEnvComponentUsages[(name = $thisChildEnvArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value) and (not(own_slot_value[slot_reference = 'element_classified_by']/value = $secondaryTechUsageType/name))]"/>
		<xsl:variable name="thisChildEnvComponents" select="$childEnvComponents[name = $thisChildEnvComponentUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>

		<xsl:apply-templates mode="RenderTechComponentLink" select="$thisChildEnvComponents">
			<xsl:with-param name="locationName" select="$locationName"/>
		</xsl:apply-templates>

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Class -->
	<xsl:template match="node()" mode="RenderTechComponentLink">
		<xsl:param name="locationName"/>
		<xsl:variable name="techCompName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="fullTechCompName" select="concat($locationName, $techCompName)"/>
		<xsl:variable name="strippedTechCompName" select="translate($fullTechCompName, translate($fullTechCompName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

		<xsl:call-template name="RenderComponentLink">
			<xsl:with-param name="techComp" select="current()"/>
			<xsl:with-param name="techCompName" select="$strippedTechCompName"/>
		</xsl:call-template>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the url link for a technology component -->
	<xsl:template name="RenderComponentLink">
		<xsl:param name="techComp"/>
		<xsl:param name="techCompName"/>
		<xsl:variable name="linkHref">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="'technology/core_tl_tech_comp_summary.xsl'"/>
				<xsl:with-param name="theInstanceID" select="$techComp/name"/>
				<xsl:with-param name="theHistoryLabel" select="concat('Technology Component Summary - ', $techComp/own_slot_value[slot_reference = 'name']/value)"/>
				<xsl:with-param name="theParam4" select="$param4"/>
				<!-- pass the id of the taxonomy term used for scoping as parameter 4-->
			</xsl:call-template>
		</xsl:variable> url of "<xsl:value-of select="$techCompName"/>" is [[<xsl:value-of select="$linkHref"/>]]&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Declare an Element as a Class within a package -->
	<xsl:template name="DeclareElementAsClass">
		<xsl:param name="fullName"/>
		<xsl:param name="displayName"/> class <xsl:value-of select="$fullName"/> as "<xsl:value-of select="$displayName"/>" &#10; </xsl:template>

	<!-- 11.08.2011 JP -->
	<!-- Declare an Element as a Package within a package -->
	<xsl:template name="DeclareElementAsPackage">
		<xsl:param name="fullName"/>
		<xsl:param name="displayName"/> package "<xsl:value-of select="$displayName"/>" </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the technology component dependencies within an Environment (Technology Composite) -->
	<xsl:template match="node()" mode="RenderEnvTechCompDependencies">
		<xsl:variable name="locationName" select="current()/own_slot_value[slot_reference = 'name']/value"/>

		<xsl:variable name="thisChildEnvArchitecture" select="$childEnvArchitectures[name = current()/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
		<!--<xsl:variable name="techCompUsages" select="$childEnvComponentUsages[(name=$thisChildEnvArchitecture/own_slot_value[slot_reference='technology_component_usages']/value) and (not(own_slot_value[slot_reference='element_classified_by']/value = $secondaryTechUsageType/name))]"/>-->
		<xsl:variable name="techCompUsages" select="$childEnvComponentUsages[name = $thisChildEnvArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>
		<xsl:variable name="techCompDependencyLinks" select="$childEnvDependencies[own_slot_value[slot_reference = ':FROM']/value = $techCompUsages/name]"/>

		<xsl:apply-templates mode="RenderTechCompDependency" select="$techCompDependencyLinks">
			<xsl:with-param name="sourceParentName" select="$locationName"/>
		</xsl:apply-templates>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render an application dependency - expects a :TCU-TO-TCU-STATIC-RELATION -->
	<xsl:template match="node()" mode="RenderTechCompDependency">
		<xsl:param name="sourceParentName"/>

		<xsl:variable name="sourceTechCompUsage" select="$childEnvComponentUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="sourceTechComp" select="$childEnvComponents[name = $sourceTechCompUsage/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>

		<xsl:variable name="realSourceParentName">
			<xsl:choose>
				<xsl:when test="$sourceTechCompUsage/own_slot_value[slot_reference = 'element_classified_by']/value = $secondaryTechUsageType/name">
					<xsl:value-of select="eas:getTechCompPrimaryParentName($sourceTechComp)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sourceParentName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="sourceTechCompName" select="$sourceTechComp/own_slot_value[slot_reference = 'name']/value"/>

		<xsl:variable name="fullSourceTechCompName" select="concat($realSourceParentName, $sourceTechCompName)"/>
		<xsl:variable name="strippedSourceTechCompName" select="translate($fullSourceTechCompName, translate($fullSourceTechCompName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>


		<xsl:variable name="dependentTechCompUsages" select="$childEnvComponentUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="interfaceName" select="current()/own_slot_value[slot_reference = ':relation_label']/value"/>

		<xsl:for-each select="$dependentTechCompUsages">
			<xsl:variable name="currentUsage" select="current()"/>
			<xsl:variable name="dependentTechComp" select="$childEnvComponents[name = current()/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
			<xsl:variable name="dependentTechCompName" select="$dependentTechComp/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="dependentParentName">
				<xsl:choose>
					<xsl:when test="$currentUsage/own_slot_value[slot_reference = 'element_classified_by']/value = $secondaryTechUsageType/name">
						<xsl:value-of select="eas:getTechCompPrimaryParentName($dependentTechComp)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$sourceParentName"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="fullDependentTechCompName" select="concat($dependentParentName, $dependentTechCompName)"/>
			<xsl:variable name="strippedDependentTechCompName" select="translate($fullDependentTechCompName, translate($fullDependentTechCompName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

			<xsl:call-template name="AssociateTechComponents">
				<xsl:with-param name="sourceTechCompName" select="$strippedSourceTechCompName"/>
				<xsl:with-param name="targetTechCompName" select="$strippedDependentTechCompName"/>
				<xsl:with-param name="interfaceName" select="$interfaceName"/>
			</xsl:call-template>
		</xsl:for-each>

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Associate two Technology Components within or across Environment-->
	<xsl:template name="AssociateTechComponents">
		<xsl:param name="sourceTechCompName"/>
		<xsl:param name="targetTechCompName"/>
		<xsl:param name="interfaceName"/> &#10;"<xsl:value-of select="$sourceTechCompName"/>" --> <xsl:value-of select="$targetTechCompName"/><!--<xsl:if test="string-length($interfaceName) > 0"><xsl:text> : </xsl:text><xsl:value-of select="$interfaceName"></xsl:value-of></xsl:if>--><xsl:text>&#10;</xsl:text>
	</xsl:template>


	<xsl:function name="eas:getTechCompPrimaryParentName">
		<xsl:param name="techComp"/>

		<xsl:variable name="primaryTechCompUsage" select="$childEnvComponentUsages[(own_slot_value[slot_reference = 'usage_of_technology_component']/value = $techComp/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $primaryTechUsageType/name)]"/>

		<xsl:if test="count($primaryTechCompUsage) > 0">
			<xsl:variable name="primaryParentArchitecture" select="$childEnvArchitectures[name = $primaryTechCompUsage[1]/own_slot_value[slot_reference = 'inverse_of_technology_component_usages']/value]"/>
			<xsl:variable name="primaryParent" select="$childEnvironments[own_slot_value[slot_reference = 'technology_component_architecture']/value = $primaryParentArchitecture/name]"/>
			<xsl:value-of select="$primaryParent/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:if>

	</xsl:function>


	<xsl:function name="eas:getTechCompParentName">
		<xsl:param name="techComp"/>

		<xsl:variable name="techCompUsage" select="$childEnvComponentUsages[own_slot_value[slot_reference = 'usage_of_technology_component']/value = $techComp/name]"/>
		<xsl:variable name="parentArchitecture" select="$childEnvArchitectures[name = $techCompUsage[1]/own_slot_value[slot_reference = 'inverse_of_technology_component_usages']/value]"/>
		<xsl:variable name="parent" select="$childEnvironments[own_slot_value[slot_reference = 'technology_component_architecture']/value = $parentArchitecture/name]"/>
		<xsl:value-of select="$parent/own_slot_value[slot_reference = 'name']/value"/>

	</xsl:function>


</xsl:stylesheet>
