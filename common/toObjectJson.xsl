<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://protege.stanford.edu/xml">

    <xsl:function name="eas:escapeJSONString">
        <xsl:param name="theString"/>
        <xsl:value-of select="replace(replace(replace(replace(replace($theString, '\\', '\\\\'), '&quot;', '\\&quot;'), '&#09;', '\\t'), '&#10;', '\\n'), '&#13;', '\\r')"/>
    </xsl:function>

    <xsl:template match="node()" mode="toJsonObject2">
        <xsl:param name="mapping" select="''"/><xsl:param name="types" select="''"/>{
        "id": "<xsl:value-of select="./name"/>",
        "type": "<xsl:value-of select="./type"/>"<xsl:for-each select="./own_slot_value">
        <xsl:variable name="key"><xsl:call-template name="keyLookup"><xsl:with-param name="mapping" select="concat(',',$mapping,',')"/></xsl:call-template></xsl:variable>
        <xsl:if test="$key != ''">,<xsl:variable name="type"><xsl:call-template name="typeLookup"><xsl:with-param name="mapping" select="concat(',',$types,',')"/><xsl:with-param name="key" select="$key"/></xsl:call-template></xsl:variable>
            "<xsl:copy-of select="eas:escapeJSONString($key)"/>": <xsl:choose>
                <xsl:when test="$type='array' or count(current()/value) > 1">[
                    <xsl:for-each select="current()/value">"<xsl:copy-of select="eas:escapeJSONString(current())"/>"<xsl:if test="not(position()=last())">,
                    </xsl:if></xsl:for-each>
                    ]</xsl:when>
                <xsl:when test="$type='boolean' and current()/value = 'false'">false</xsl:when>
                <xsl:when test="$type='boolean' and current()/value = 'true'">true</xsl:when>
                <xsl:when test="$type='boolean'">undefined</xsl:when>
                <xsl:when test="$type='number'"><xsl:copy-of select="current()/value/text()"/></xsl:when>
                <xsl:otherwise>"<xsl:copy-of select="eas:escapeJSONString(current()/value)"/>"</xsl:otherwise>
            </xsl:choose></xsl:if>
    </xsl:for-each>
        }<xsl:if test="not(position()=last())">,
    </xsl:if></xsl:template>
    <xsl:template name="keyLookup">
        <xsl:param name="mapping" select="."/>
        <xsl:variable name="slot" select="current()/slot_reference"/>
        <xsl:variable name="key" select="substring-before(substring-after($mapping, concat(',',$slot,'=')),',')"/>
        <xsl:variable name="all" select="substring-before(substring-after($mapping, ',*='),',')"/>
        <xsl:choose>
            <xsl:when test="$slot='name'">name</xsl:when>
            <xsl:when test="$slot='description'">description</xsl:when>
            <xsl:when test="$slot='system_last_modified_datetime_iso8601'">lastModified</xsl:when>
            <xsl:when test="$slot='system_creation_datetime_iso8601'">created</xsl:when>
            <xsl:when test="$slot='system_author_id'">createdBy</xsl:when>
            <xsl:when test="$slot='system_last_modified_author_id'">lastModifiedBy</xsl:when>
            <xsl:when test="$key != ''"><xsl:value-of select="$key"/></xsl:when>
            <xsl:when test="substring-before(substring-after($mapping, concat(',',$slot,'=')),',') != ''"><xsl:value-of select="$key"/></xsl:when>
            <xsl:when test="$all != ''"><xsl:value-of select="$slot"/></xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="typeLookup">
        <xsl:param name="mapping" select="."/>
        <xsl:param name="key" select="."/>
        <xsl:variable name="type" select="substring-before(substring-after($mapping, concat(',',$key,'=')),',')"/>
        <xsl:choose>
            <xsl:when test="$type != ''"><xsl:value-of select="$type"/></xsl:when>
            <xsl:otherwise>string</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>