<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan xs functx eas ess" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:template match="node()" name="analytics">
		<xsl:variable name="trackingCode" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Analytics']"/>
			<xsl:value-of select="$trackingCode/own_slot_value[slot_reference='report_constant_value']/value" disable-output-escaping="yes"/>
	</xsl:template>
</xsl:stylesheet>
