<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Activity', 'Individual_Business_Role', 'Group_Business_Role')"/>
	<!-- END GENERIC LINK VARIABLES -->



	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	<!-- 23.04.2015 JP	Created -->


	<xsl:variable name="allDataCardinalities" select="/node()/simple_instance[type = 'Data_Attribute_Cardinality']"/>
	<xsl:variable name="allPrimitiveDataTypes" select="/node()/simple_instance[type = 'Primitive_Data_Object']"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[type = 'Data_Object']"/>

	<xsl:variable name="modelSubject" select="$allDataObjects[name = $param1]"/>
	<xsl:variable name="modelSubjectName">
		<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$modelSubject"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="modelSubjectDesc">
		<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="$modelSubject"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="umlClassMinimumHeight" select="75"/>
	<xsl:variable name="umlAttributeLineHeight" select="11"/>


	<xsl:variable name="pageTitle" select="concat('Logical Model for Data Object - ', $modelSubjectName)"/>
	<xsl:variable name="dataAttributesForSubject" select="/node()/simple_instance[own_slot_value[slot_reference = 'type_for_data_attribute']/value = $param1]"/>
	<xsl:variable name="inScopeDataAttributes" select="/node()/simple_instance[name = $modelSubject/own_slot_value[slot_reference = 'contained_data_attributes']/value]"/>

	<xsl:variable name="dataObjectsForSubject" select="$allDataObjects[(name = $param1) or (name = $inScopeDataAttributes/own_slot_value[slot_reference = 'type_for_data_attribute']/value)]"/>


	<xsl:variable name="otherDataObjects" select="$allDataObjects[not(name = $dataObjectsForSubject/name) and (own_slot_value[slot_reference = 'contained_data_attributes']/value = $dataAttributesForSubject/name)]"/>

	<xsl:variable name="objectDataAttributes" select="$inScopeDataAttributes[own_slot_value[slot_reference = 'type_for_data_attribute']/value = ($dataObjectsForSubject union $otherDataObjects)/name]"/>
	<xsl:variable name="childDataObjects" select="$allDataObjects[name = $modelSubject/own_slot_value[slot_reference = 'data_object_specialisations']/value]"/>
	<xsl:variable name="parentDataObjects" select="$allDataObjects[name = $modelSubject/own_slot_value[slot_reference = 'data_object_generalisations']/value]"/>

	<xsl:variable name="dataObjectModelReport" select="eas:get_report_by_name('Core: Data Object Model')"/>

	<xsl:variable name="DEBUG" select="''"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageTitle"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>
				<script src="js/lodash/index.js"/>
				<script src="js/backbone/backbone.js"/>
				<script src="js/graphlib/graphlib.core.js"/>
				<script src="js/dagre/dagre.core.js"/>
				<script src="js/jointjs/joint.min.js"/>
				<script src="js/jointjs/ga.js" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.js"/>
				<style type="text/css">
					.link-tools,
					.marker-arrowheads,
					.connection-wrap{
						display: 'none'
					}</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--ADD THE CONTENT-->
				<!--<xsl:variable name="modelSubjectDesc" select="$modelSubject/own_slot_value[slot_reference='description']/value" />-->

				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 id="viewName">
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey">
									<xsl:value-of select="$pageTitle"/>
								</span>
								<xsl:value-of select="$DEBUG"/>
							</h1>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Description')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:value-of select="$modelSubjectDesc"/>
							</div>
						</div>
						<div class="sectionDividerHorizontal"/>
						<div class="clear"/>

						<!--Setup UML Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">Model</h2>
							</div>
							<div class="verticalSpacer_20px"/>
							<div class="content-section">
								<div class="simple-scroller">
									<div id="modelContainer"/>
								</div>
								
								<xsl:call-template name="modelScript">
									<xsl:with-param name="targetID">modelContainer</xsl:with-param>
								</xsl:call-template>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="modelScript">
		<xsl:param name="targetID"/>
		<script>
			var graph = new joint.dia.Graph;
			var windowWidth = $(window).width()-100;
			var windowHeight = $(window).height()-300;
			
			var paper = new joint.dia.Paper({
			    el: $('#<xsl:value-of select="$targetID"/>'),
			    gridSize: 1,
			    width: windowWidth * 2,
			    height: windowHeight * 3,
			    model: graph
			});
			
			var uml = joint.shapes.uml;
			
			var classes = {
			
				<xsl:apply-templates mode="RenderDataObjectUML" select="$dataObjectsForSubject union $otherDataObjects union $childDataObjects union $parentDataObjects"/>			
			};
			
			_.each(classes, function(c) { graph.addCell(c); });
			
			var relations = [
               
				<xsl:apply-templates mode="RenderObjectAssociations" select="$dataAttributesForSubject union $objectDataAttributes"/>
            <xsl:if test="$childDataObjects"><xsl:if test="$dataAttributesForSubject union $objectDataAttributes">,</xsl:if></xsl:if>       
				<xsl:apply-templates mode="RenderObjectGeneralisations" select="$childDataObjects"/>
              <xsl:if test="$parentDataObjects"><xsl:if test="$childDataObjects or ($dataAttributesForSubject union $objectDataAttributes)">,</xsl:if><xsl:apply-templates mode="RenderObjectSpecialisations" select="$parentDataObjects"/>
                  </xsl:if>   
			];
			
			_.each(relations, function(r) { graph.addCell(r); });
			
			joint.layout.DirectedGraph.layout(graph, { setLinkVertices: false });
			paper.scale(0.8, 0.8);
			
		</script>
	</xsl:template>

	<!-- TEMPLATE TO RENDER A DATA OBJECT AS A UML CLASS -->
	<xsl:template mode="RenderDataObjectUML" match="node()">
		<xsl:variable name="currentDataObject" select="current()"/>
		<xsl:variable name="dataObjectName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$currentDataObject"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="jsDataObjectName" select="eas:get_js_name_for_data_object($dataObjectName)"/>
		<xsl:variable name="primitiveAttributes" select="$inScopeDataAttributes[(name = $currentDataObject/own_slot_value[slot_reference = 'contained_data_attributes']/value) and (own_slot_value[slot_reference = 'type_for_data_attribute']/value = $allPrimitiveDataTypes/name)]"/>
		<xsl:variable name="umlClassType">
			<xsl:choose>
				<xsl:when test="$currentDataObject/name = $dataObjectsForSubject/name">DataObject</xsl:when>
				<xsl:otherwise>OtherDataObject</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="attributeCount" select="count($primitiveAttributes)"/>
		<xsl:variable name="classBoxHeight">
			<xsl:choose>
				<xsl:when test="$attributeCount = 0"><xsl:value-of select="$umlClassMinimumHeight"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$umlClassMinimumHeight + ($attributeCount * $umlAttributeLineHeight)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dataObjectLinkHref">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theInstanceID" select="$currentDataObject/name"/>
				<xsl:with-param name="theXSL" select="$dataObjectModelReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="translate(translate(translate(translate(translate($jsDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'), '&amp;','and')"/>: new uml.<xsl:value-of select="$umlClassType"/>({ size: { width: 240, height: <xsl:value-of select="$classBoxHeight"/> }, position: { x: 0, y: 0 }, attrs: { a: { 'xlink:href': '<xsl:value-of select="$dataObjectLinkHref"/>', cursor: 'pointer' } } , name: '<xsl:value-of select="$dataObjectName"/>'<xsl:if test="(count($primitiveAttributes) > 0) and not($umlClassType = 'OtherDataObject')">, attributes: [<xsl:apply-templates mode="RenderPrimitiveDataAttributeUML" select="$primitiveAttributes"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>]</xsl:if> })<xsl:if test="not(position() = last())">,</xsl:if><xsl:text>
			
			
		</xsl:text>
	</xsl:template>


	<!-- TEMPLATE TO RENDER A DATA OBJECT ATTRIBUTE AS A UML CLASS ATTRIBUTE -->
	<xsl:template mode="RenderPrimitiveDataAttributeUML" match="node()">
		<xsl:variable name="dataAttributeName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="primitiveType" select="$allPrimitiveDataTypes[name = current()/own_slot_value[slot_reference = 'type_for_data_attribute']/value]"/>
		<xsl:variable name="primitiveTypeName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$primitiveType"/></xsl:call-template>
		</xsl:variable> '<xsl:value-of select="$dataAttributeName"/>: <xsl:value-of select="$primitiveTypeName"/>'<xsl:if test="not(position() = last())">,</xsl:if><xsl:text>
			
		</xsl:text>
	</xsl:template>


	<!-- TEMPLATE TO RENDER AN ASSOCIATION BETWEEN DATA OBJECTS -->
	<xsl:template mode="RenderObjectAssociations" match="node()">
		<xsl:variable name="attName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="attCardinality" select="$allDataCardinalities[name = current()/own_slot_value[slot_reference = 'data_attribute_cardinality']/value]"/>
		<xsl:variable name="cardinalitySymbol" select="$attCardinality/own_slot_value[slot_reference = 'enumeration_value']/value"/>
		<xsl:variable name="sourceDataObject" select="$allDataObjects[name = current()/own_slot_value[slot_reference = 'belongs_to_data_object']/value]"/>
		<xsl:variable name="sourceDataObjectName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$sourceDataObject"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="jsSourceDataObjectName" select="eas:get_js_name_for_data_object($sourceDataObjectName)"/>
		<xsl:variable name="targetDataObject" select="$allDataObjects[name = current()/own_slot_value[slot_reference = 'type_for_data_attribute']/value]"/>
		<xsl:variable name="targetDataObjectName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$targetDataObject"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="jsTargetDataObjectName" select="eas:get_js_name_for_data_object(translate(translate(translate(translate(translate($targetDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and'))"/> new uml.Association({ source: { id: classes.<xsl:value-of select="translate(translate(translate(translate(translate($jsSourceDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and')"/>.id }, target: { id: classes.<xsl:value-of select="translate(translate(translate(translate($jsTargetDataObjectName, '-', ''), ' ', ''), ',', ''),'&amp;','and')"/>.id }, labels: [ { position: -20, attrs: { text: { text: '<xsl:value-of select="$cardinalitySymbol"/>' } }}, { position: .2, attrs: { text: { text: '<xsl:value-of select="lower-case($attName)"/>' } } } ]})<xsl:if test="not(position() = last())">,</xsl:if><xsl:text>
			
		</xsl:text>
	</xsl:template>


	<!-- TEMPLATE TO RENDER A GENERALISATION LINK BETWEEN DATA OBJECTS -->
	<xsl:template mode="RenderObjectGeneralisations" match="node()">
		<xsl:variable name="childDataObject" select="current()"/>
		<xsl:variable name="childDataObjectName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$childDataObject"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="jsChildDataObjectName" select="eas:get_js_name_for_data_object($childDataObjectName)"/>
		<xsl:variable name="parentDataObject" select="$modelSubject"/>
		<xsl:variable name="parentDataObjectName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$parentDataObject"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="jsParentDataObjectName" select="eas:get_js_name_for_data_object(translate(translate(translate(translate(translate($parentDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and'))"/> new uml.Generalization({ source: { id: classes.<xsl:value-of select="translate(translate(translate(translate(translate($jsChildDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and')"/>.id }, target: { id: classes.<xsl:value-of select="translate(translate(translate(translate(translate($jsParentDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and')"/>.id }})<xsl:if test="not(position() = last())">,</xsl:if><xsl:text>
			
		</xsl:text>
	</xsl:template>


	<!-- TEMPLATE TO RENDER A SPECIALISATION LINK BETWEEN DATA OBJECTS -->
	<xsl:template mode="RenderObjectSpecialisations" match="node()">
		<xsl:variable name="parentDataObject" select="current()"/>
		<xsl:variable name="parentDataObjectName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$parentDataObject"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="jsParentDataObjectName" select="eas:get_js_name_for_data_object($parentDataObjectName)"/>
		<xsl:variable name="childDataObject" select="$modelSubject"/>
		<xsl:variable name="childDataObjectName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$childDataObject"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="jsChildDataObjectName" select="eas:get_js_name_for_data_object(translate(translate(translate(translate(translate($childDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and'))"/> new uml.Generalization({ source: { id: classes.<xsl:value-of select="translate(translate(translate(translate(translate($jsChildDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and')"/>.id }, target: { id: classes.<xsl:value-of select="translate(translate(translate(translate(translate($jsParentDataObjectName, '-', ''), ' ', ''), ',', ''), ':', '_'),'&amp;','and')"/>.id }})<xsl:if test="not(position() = last())">,</xsl:if><xsl:text>
			
		</xsl:text>
	</xsl:template>


	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:get_js_name_for_data_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="lowerCaseName" select="lower-case($dataObjectName)"/>
		<xsl:variable name="noOpenBrackets" select="translate($lowerCaseName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:variable name="noSqBracketsOpen" select="translate($noCloseBrackets, '[', ' ')"/>
		<xsl:variable name="noSqBracketsClosed" select="translate($noSqBracketsOpen, ']', ' ')"/>
		<xsl:value-of select="translate($noSqBracketsClosed, ' ', '')"/>

	</xsl:function>

	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:no_specials_js_name_for_data_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="noOpenBrackets" select="translate($dataObjectName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:variable name="noSqBracketsOpen" select="translate($noCloseBrackets, '[', ' ')"/>
		<xsl:variable name="noSqBracketsClosed" select="translate($noSqBracketsOpen, ']', ' ')"/>
		<xsl:value-of select="$noSqBracketsClosed"/>

	</xsl:function>


</xsl:stylesheet>
