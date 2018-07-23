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

	<!-- param1 = the subject of the UML model (an Application Provider) -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4"/>-->

	<!-- xSize = an optional width of the resulting model in pixels -->
	<xsl:param name="xSize"/>

	<!-- ySize = an optional height of the resulting model in pixels -->
	<xsl:param name="ySize"/>

	<xsl:variable name="currentAppProvider" select="/node()/simple_instance[name = $param1]"/>

	<xsl:variable name="tiersTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Technology Architecture Tiers')]"/>
	<xsl:variable name="tiers" select="/node()/simple_instance[name = $tiersTaxonomy/own_slot_value[slot_reference = 'taxonomy_terms']/value]"/>

	<!-- This section retrieves the root Technology Composite supporting the Application Provider -->
	<xsl:variable name="rootEnv" select="/node()/simple_instance[name = $currentAppProvider/own_slot_value[slot_reference = 'implemented_with_technology']/value]"/>
	<xsl:variable name="rootEnvArchitecture" select="/node()/simple_instance[name = $rootEnv/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="childEnvUsages" select="/node()/simple_instance[name = $rootEnvArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>
	<xsl:variable name="childEnvDependencies" select="/node()/simple_instance[name = $rootEnvArchitecture/own_slot_value[slot_reference = 'invoked_functions_relations']/value]"/>
	<xsl:variable name="relevantTiers" select="$tiers[name = $childEnvUsages/own_slot_value[slot_reference = 'element_classified_by']/value]"/>

	<!-- These are the Technology Composites that make up the architecture of the Application's supporting technology platform -->
	<xsl:variable name="childEnvironments" select="/node()/simple_instance[name = $childEnvUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>

	<!-- This section retrieves the Technology Components across the supporting technology platform -->
	<xsl:variable name="childEnvArchitectures" select="/node()/simple_instance[name = $childEnvironments/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="childEnvComponentUsages" select="/node()/simple_instance[name = $childEnvArchitectures/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>

	<xsl:variable name="childEnvComponents" select="/node()/simple_instance[name = $childEnvComponentUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>



	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="count($rootEnv) = 0">
				<xsl:call-template name="RenderEmptyUMLModel">
					<xsl:with-param name="message">
						<xsl:value-of select="eas:i18n('No Technology Platform Defined')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise> @startuml skinparam svek true skinparam packageStyle rect skinparam classBackgroundColor #ffffff skinparam classBorderColor #666666 skinparam classArrowColor #666666 skinparam classFontColor #333333 skinparam classFontSize 11 skinparam classFontName Arial skinparam circledCharacterFontColor #ffffff skinparam packageFontName "Arial Black" skinparam packageFontSize 14 skinparam packageFontStyle normal skinparam packageBorderColor #666666 skinparam packageBackgroundColor #eeeeee hide empty members hide circle <!-- CREATE TIERS AS PACKAGES CONTAINING PACKAGES -->
				<xsl:for-each select="$relevantTiers">
					<xsl:sort select="own_slot_value[slot_reference = 'taxonomy_term_label']/value"/>
					<xsl:variable name="currentTier" select="current()"/>
					<xsl:variable name="tierEnvUsages" select="$childEnvUsages[own_slot_value[slot_reference = 'element_classified_by']/value = $currentTier/name]"/>
					<xsl:variable name="tierName" select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:for-each select="$tierEnvUsages">
						<xsl:variable name="tierEnvUsageName" select="current()/own_slot_value[slot_reference = 'technology_architecture_display_label']/value"/>
						<xsl:variable name="tierEnv" select="$childEnvironments[name = current()/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
						<xsl:variable name="tierEnvArchitecture" select="$childEnvArchitectures[name = $tierEnv/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
						<xsl:variable name="tierEnvComponentUsages" select="$childEnvComponentUsages[name = $tierEnvArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value]"/> package "<xsl:value-of select="$tierName"/>" #bdd0e5 { package "<xsl:value-of select="$tierEnvUsageName"/>" } end package package "<xsl:value-of select="$tierEnvUsageName"/>" #eeeeee { <xsl:choose>
							<xsl:when test="count($tierEnvComponentUsages) > 0">
								<xsl:for-each select="$tierEnvComponentUsages">
									<xsl:variable name="componentUsageName" select="current()/own_slot_value[slot_reference = 'technology_architecture_display_label']/value"/>
									<xsl:variable name="fullCompName" select="concat($tierEnvUsageName, $componentUsageName)"/>
									<xsl:variable name="strippedCompName" select="translate($fullCompName, translate($fullCompName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/> class <xsl:value-of select="$strippedCompName"/> as "<xsl:value-of select="$componentUsageName"/>" </xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="strippedCompName" select="translate($tierEnvUsageName, translate($tierEnvUsageName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/> class <xsl:value-of select="$strippedCompName"/> as "<xsl:value-of select="' '"/>" </xsl:otherwise>
						</xsl:choose> } end package <xsl:text>&#10;</xsl:text>
						<xsl:for-each select="$tierEnvComponentUsages">
							<xsl:variable name="componentUsageName" select="current()/own_slot_value[slot_reference = 'technology_architecture_display_label']/value"/>
							<xsl:variable name="fullCompName" select="concat($tierEnvUsageName, $componentUsageName)"/>
							<xsl:variable name="strippedCompName" select="translate($fullCompName, translate($fullCompName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>
							<xsl:variable name="comp" select="$childEnvComponents[name = current()/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
							<xsl:call-template name="RenderComponentLink">
								<xsl:with-param name="techComp" select="$comp"/>
								<xsl:with-param name="techCompName" select="$strippedCompName"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="$childEnvDependencies">
					<xsl:variable name="fromUsage" select="$childEnvUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
					<xsl:variable name="fromUsageName" select="$fromUsage/own_slot_value[slot_reference = 'technology_architecture_display_label']/value"/>
					<xsl:variable name="toUsage" select="$childEnvUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
					<xsl:variable name="toUsageName" select="$toUsage/own_slot_value[slot_reference = 'technology_architecture_display_label']/value"/> "<xsl:value-of select="$fromUsageName"/>" -right-> "<xsl:value-of select="$toUsageName"/>"<xsl:text>&#10;</xsl:text>
					<!--<xsl:choose>
				<xsl:when test="count($childEnvDependencies[(own_slot_value[slot_reference=':FROM']/value = $toUsage/name) and (own_slot_value[slot_reference=':TO']/value = $fromUsage/name)]) > 0">
					"<xsl:value-of select="$fromUsageName"/>" &lt;-right-> "<xsl:value-of select="$toUsageName"/>"<xsl:text>&#10;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					"<xsl:value-of select="$fromUsageName"/>" -right-> "<xsl:value-of select="$toUsageName"/>"<xsl:text>&#10;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>-->
				</xsl:for-each> @enduml </xsl:otherwise>
		</xsl:choose>

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
				<xsl:with-param name="theXSL" select="'technology/togaf_tl_tech_comp_summary.xsl'"/>
				<xsl:with-param name="theInstanceID" select="$techComp/name"/>
				<xsl:with-param name="theHistoryLabel" select="concat('Technology Component Summary - ', $techComp/own_slot_value[slot_reference = 'name']/value)"/>
				<!--<xsl:with-param name="theParam4" select="$param4"/>-->
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
	<!-- Associate two Technology Components within or across Environment-->
	<xsl:template name="AssociateTechComponents">
		<xsl:param name="sourceTechCompName"/>
		<xsl:param name="targetTechCompName"/>
		<xsl:param name="interfaceName"/> &#10;"<xsl:value-of select="$sourceTechCompName"/>" --> <xsl:value-of select="$targetTechCompName"/><!--<xsl:if test="string-length($interfaceName) > 0"><xsl:text> : </xsl:text><xsl:value-of select="$interfaceName"></xsl:value-of></xsl:if>--><xsl:text>&#10;</xsl:text>
	</xsl:template>




</xsl:stylesheet>
