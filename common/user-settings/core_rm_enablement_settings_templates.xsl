<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../../common/core_utilities.xsl"/>

	<xsl:variable name="roadmapPlansAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'System: Roadmap Planned Changes API']"/>
    <xsl:variable name="roadmapPlannedChangesAPIUrl">
		<xsl:call-template name="RenderAPILinkText">
			<xsl:with-param name="theXSL" select="$roadmapPlansAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
    </xsl:variable>

	<xsl:variable name="roadmapPlansProjectsAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'System: Roadmap, Plans and Projects API']"/>
	<xsl:variable name="roadmapsPlansProjectsAPIUrl">
		<xsl:call-template name="RenderAPILinkText">
			<xsl:with-param name="theXSL" select="$roadmapPlansProjectsAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
    </xsl:variable>
	
	<xsl:template name="RoadmapEnablementJSUI">
		<!--
		<script>
			<xsl:choose>
				<xsl:when test="count($roadmapPlansAPI) > 0 and count($roadmapPlansProjectsAPI) > 0">
					const essPlannedChangesAPIURL = '<xsl:value-of select="$roadmapPlannedChangesAPIUrl"/>';
					const essRoadmapsPlansProjectsAPIURL = '<xsl:value-of select="$roadmapsPlansProjectsAPIUrl"/>';
				</xsl:when>
				<xsl:otherwise>
					const essPlannedChangesAPIURL = '';
					const essRoadmapsPlansProjectsAPIURL = '';
				</xsl:otherwise>
			</xsl:choose>
		</script> -->
		
		<!-- handlebars template for the Roadmap Enablement UI -->
		<script id="ess-rm-enablement-template" type="text/x-handlebars-template">
			<option/>{{#each this}}<option><xsl:attribute name="value">{{id}}</xsl:attribute>{{name}}</option>{{/each}}
		</script>
	</xsl:template>

</xsl:stylesheet>