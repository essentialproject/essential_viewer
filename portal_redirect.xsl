<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="common/core_header.xsl"/>
	<xsl:include href="common/core_page_history.xsl"/>
	<xsl:include href="common/core_doctype.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="i18n"/>
	<xsl:param name="pageHistory"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<xsl:variable name="headerHomeReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Home Page')]"/>
		<xsl:variable name="homePageXSL" select="$headerHomeReportConstant/own_slot_value[slot_reference = 'report_constant_value']/value"/>
		<xsl:variable name="portalConstant" select="$headerHomeReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value"/>
		<xsl:variable name="portalContantTemplateXSL" select="/node()/simple_instance[type = 'Portal' and name = $portalConstant]/own_slot_value[slot_reference = 'portal_xsl_filename']/value"/>
		<xsl:variable name="portalConstantURL" select="concat('report?XML=',$reposXML,'&amp;PMA=',$portalConstant,'&amp;XSL=',$portalContantTemplateXSL,'&amp;cl=',$currentLanguage/own_slot_value[slot_reference='name']/value,'&amp;LABEL=','Home')"/>
		<xsl:variable name="homePageConstantURL" select="concat('report?XML=',$reposXML,'&amp;XSL=',$homePageXSL,'&amp;cl=',$currentLanguage/own_slot_value[slot_reference='name']/value,'&amp;LABEL=','Home')"/>
		<xsl:variable name="defaultURL" select="concat('report?XML=',$reposXML,'&amp;XSL=','home.xsl','&amp;cl=',$currentLanguage/own_slot_value[slot_reference='name']/value,'&amp;LABEL=','Home')"/>
		<html>
			<head>

				<xsl:choose>
					<xsl:when test="count($portalConstant) &gt; 0">
						<script type="text/javascript">                          
                               function Redirect() {
                                  window.location="<xsl:value-of select="$portalConstantURL"/>";
                               }        
                               Redirect()
                         </script>
					</xsl:when>
					<xsl:when test="(count($portalConstant) = 0) and string-length($homePageXSL) &gt; 0">
						<script type="text/javascript">                          
                               function Redirect() {
                                  window.location="<xsl:value-of select="$homePageConstantURL"/>";
                               }        
                               Redirect()    
                         </script>
					</xsl:when>
					<xsl:otherwise>
						<script type="text/javascript">                          
                               function Redirect() {
                                  window.location="<xsl:value-of select="$defaultURL"/>";
                               }        
                               Redirect()     
                         </script>
					</xsl:otherwise>
				</xsl:choose>
				<title>Loading</title>
			</head>
			<body/>
		</html>
	</xsl:template>

</xsl:stylesheet>
