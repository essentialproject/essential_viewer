<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:key name="controlSolutions" match="/node()/simple_instance[type=('Control_Solution')]" use="type"/>
	<xsl:key name="controlSolutionsName" match="/node()/simple_instance[type=('Control_Solution')]" use="current()/own_slot_value[slot_reference = 'control_solution_for_controls']/value"/>
	<xsl:key name="controlAssessmentType" match="/node()/simple_instance[type=('Control_Solution_Assessment')]" use="type"/>
	<xsl:key name="controlSolutionAssessment" match="/node()/simple_instance[type=('Control_Solution_Assessment')]" use="name"/>
	<xsl:key name="controlAssessmentFinding" match="/node()/simple_instance[type=('Control_Assessment_Finding')]" use="name"/>
	<xsl:key name="actor" match="/node()/simple_instance[type=('Individual_Actor')]" use="name"/>
	<xsl:key name="role" match="/node()/simple_instance[type=('Individual_Business_Role')]" use="type"/>
	<xsl:key name="processes" match="/node()/simple_instance[type=('Business_Process')]" use="name"/>
	<xsl:key name="a2r" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]" use="type"/>
	<xsl:key name="refLink" match="/node()/simple_instance[type=('External_Reference_Link')]" use="type"/>
	<xsl:key name="controlType" match="/node()/simple_instance[type=('Control')]" use="type"/>
	<xsl:key name="control" match="/node()/simple_instance[type=('Control')]" use="name"/>
	<xsl:key name="controlFrameworkCtrl" match="/node()/simple_instance[type=('Control_Framework')]" use="own_slot_value[slot_reference='cf_controls']/value"/>
	<xsl:key name="controlFramework" match="/node()/simple_instance[type=('Control_Framework')]" use="type"/>
	<xsl:key name="controlToElement" match="/node()/simple_instance[type=('CONTROL_TO_ELEMENT_RELATION')]" use="own_slot_value[slot_reference = 'control_to_element_control']/value"/>
	<xsl:key name="controlAssessment" match="/node()/simple_instance[type=('Control_Assessment')]" use="own_slot_value[slot_reference = 'control_assessed_element']/value"/>
	<xsl:key name="impactedElement" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface', 'Business_Process', 'Technology_Product', 'Technology_Product_Build' )]" use="name"/>
	<xsl:key name="a2r" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION' )]" use="name"/>
	<xsl:key name="links" match="/node()/simple_instance[type=('External_Reference_Link' )]" use="name"/>
	<!--
		* Copyright © 2008-2019 Enterprise Architecture Solutions Limited.
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
	<!-- 03.09.2019 JP  Created	 -->
	 
	<xsl:template match="knowledge_base">
		{"assessment":[<xsl:apply-templates select="key('controlAssessmentType', 'Control_Solution_Assessment')" mode="controlSolutionAssessment"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"controlSolutions":[<xsl:apply-templates select="key('controlSolutions', 'Control_Solution')" mode="controlSolutions"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"control":[<xsl:apply-templates select="key('controlType', 'Control')" mode="controls"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"framework_controls":[<xsl:apply-templates select="key('controlFramework', 'Control_Framework')" mode="frameworks"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],"version":"620"}
	</xsl:template>

	
<xsl:template match="node()" mode="controlSolutionAssessment"> 
	<xsl:variable name="thisprocesses" select="key('processes', current()/own_slot_value[slot_reference='assessed_control_solution']/value)"/>
	<xsl:variable name="thisassessor" select="key('actor', current()/own_slot_value[slot_reference='control_solution_assessor']/value)"/>
	<xsl:variable name="thiscsols" select="key('control', current()/own_slot_value[slot_reference='control_solution_for_controls']/value)"/>
	<xsl:variable name="thisfinding" select="key('controlAssessmentFinding', current()/own_slot_value[slot_reference='assessment_finding']/value)"/>
	{
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'control_solution_assessor': string(translate(translate($thisassessor/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'assessment_finding': string(translate(translate($thisfinding/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'assessment_date': string(translate(translate(current()/own_slot_value[slot_reference = 'assessment_date_iso_8601']/value, '}', ')'), '{', ')')),
			'assessment_comments': string(translate(translate(current()/own_slot_value[slot_reference = 'ca_finding_impact_comments']/value, '}', ')'), '{', ')'))
			
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"controls":[<xsl:for-each select="$thiscsols">{
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')'))
			
			}"/>}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template><xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="controlSolutions">
	 
		<xsl:variable name="thisprocesses" select="key('processes', current()/own_slot_value[slot_reference='control_solution_business_elements']/value)"/>
		<xsl:variable name="thiscsa" select="key('controlSolutionAssessment', current()/own_slot_value[slot_reference='control_solution_assessments']/value)"/>
		<xsl:variable name="thiscsols" select="key('control', current()/own_slot_value[slot_reference='control_solution_for_controls']/value)"/>
	
	
    	{
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"processes":[<xsl:for-each select="$thisprocesses">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
		],
		"assessments":[<xsl:for-each select="$thiscsa">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'assessment_date': string(translate(translate(current()/own_slot_value[slot_reference = 'assessment_date_iso_8601']/value, '}', ')'), '{', ')')),
			'assessment_comments': string(translate(translate(current()/own_slot_value[slot_reference = 'ca_finding_impact_comments']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
		],
		"solutionForControl":[<xsl:for-each select="$thiscsols">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
		],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
<xsl:template match="node()" mode="controls">
	<xsl:variable name="ctrl" select="key('controlFrameworkCtrl', current()/name)"/>
	<xsl:variable name="thiscontrolSolutions" select="key('controlSolutionsName', current()/name)"/> 
	<xsl:variable name="thiscontrolElements" select="key('controlToElement', current()/name)"/> 
	{ 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')')),
			'framework': string(translate(translate($ctrl[1]/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/> 
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"controlAssessessments":[
			<xsl:for-each select="$thiscontrolElements">
				<xsl:variable name="thiscontrolAssessment" select="key('controlAssessment', current()/name)"/> 
				<xsl:variable name="thisimpactedElements" select="key('impactedElement', current()/own_slot_value[slot_reference = 'control_to_element_ea_element']/value)"/> 
				{ 
					"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					<xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
						'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')'))
						}"/> 
						<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
						<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
					"elements":[
					<xsl:for-each select="$thisimpactedElements"> 
						{
							"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
							"type":"<xsl:value-of select="current()/type"/>",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')'))
								}"/> 
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
						}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					],	
					"assessments":[
					<xsl:for-each select="$thiscontrolAssessment">
						<xsl:variable name="thisassessor" select="key('actor', current()/own_slot_value[slot_reference='control_assessor']/value)"/> 
						<xsl:variable name="thisfinding" select="key('controlAssessmentFinding', current()/own_slot_value[slot_reference='assessment_finding']/value)"/>
						{
							"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'control_solution_assessor': string(translate(translate($thisassessor/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'assessment_finding': string(translate(translate($thisfinding/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'assessment_date': string(translate(translate(current()/own_slot_value[slot_reference = 'assessment_date_iso_8601']/value, '}', ')'), '{', ')')),
								'assessment_comments': string(translate(translate(current()/own_slot_value[slot_reference = 'ca_finding_impact_comments']/value, '}', ')'), '{', ')'))
								}"/> 
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>

						}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					]
				}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
		
			],
		"controlSolutions":[
			<xsl:for-each select="$thiscontrolSolutions">
			<xsl:variable name="thisprocesses" select="key('processes', current()/own_slot_value[slot_reference='control_solution_business_elements']/value)"/>
			<xsl:variable name="thisassessments" select="key('controlSolutionAssessment', current()/own_slot_value[slot_reference='control_solution_assessments']/value)"/>
			 
				{
					"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')')),
					'framework': string(translate(translate($ctrl[1]/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
					}"/> 
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
					<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"thisassessments":[<xsl:for-each select="$thisassessments"> 
					<xsl:variable name="thisassessor" select="key('actor', current()/own_slot_value[slot_reference='control_solution_assessor']/value)"/> 
					<xsl:variable name="thisfinding" select="key('controlAssessmentFinding', current()/own_slot_value[slot_reference='assessment_finding']/value)"/>
					{<xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
						'control_solution_assessor': string(translate(translate($thisassessor/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
						'assessment_finding': string(translate(translate($thisfinding/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
						'assessment_date': string(translate(translate(current()/own_slot_value[slot_reference = 'assessment_date_iso_8601']/value, '}', ')'), '{', ')')),
						'assessment_comments': string(translate(translate(current()/own_slot_value[slot_reference = 'ca_finding_impact_comments']/value, '}', ')'), '{', ')'))
						}"/> 
						<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
						<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
					}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>], 
				"thisprocesses":[<xsl:for-each select="$thisprocesses"> 
					<xsl:variable name="thisa2r" select="key('a2r', current()/own_slot_value[slot_reference = 'stakeholders']/value)"/>
					<xsl:variable name="actor" select="key('actor', $thisa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>
					<xsl:variable name="extlinks" select="key('links', current()/own_slot_value[slot_reference = 'external_reference_links']/value)"/>
				
					
					{<xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
						'owner': string(translate(translate($actor/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
						'externalLinks':string(translate(translate($extlinks[1]/own_slot_value[slot_reference = 'external_reference_url']/value, '}', ')'), '{', ')')),
						'extName':string(translate(translate($extlinks[1]/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
						}"/> 
						<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
						<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
					}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>] 
				}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="frameworks">

	{
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"controls":[<xsl:for-each select="current()/own_slot_value[slot_reference='cf_controls']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
