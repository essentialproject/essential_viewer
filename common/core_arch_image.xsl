<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" version="2.0">
	<xsl:variable name="imageFolder">graph_images/</xsl:variable>
	<xsl:variable name="imageSuffix">.png</xsl:variable>
	<xsl:output method="html"/>
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
	<!-- Common architecture model image. Create the code to add an image for the specified architecture
        to the report that is calling this template
    -->
	<!-- 24.11.2009    JWC    1st implementation -->

	<!-- Produce an HTML <div> for rendering an image for the specified architecture node -->

	<!-- Render an image and a caption for the specified architecture model, e.g. a business process flow,
        application static architecture etc. 
         Apply this template by passing in the node corresponding to the architecture's simple_instance
         in the knowledge base. e.g.
         
         <xsl:apply-templates select="/node()/simple_instance[name=$yourArchitecture]" mode="RenderArchitectureImage">"
    -->
	<xsl:template match="node()" mode="RenderArchitectureImage">
		<xsl:variable select="own_slot_value[slot_reference = 'description']/value" name="aDesc"/>
		<!-- Print a caption -->
		<p class="impact">
			<xsl:value-of select="$aDesc"/>
		</p>
		<br/>
		<!--print the image-->
		<img>
			<xsl:attribute name="class">architectureImage</xsl:attribute>
			<xsl:attribute name="src">
				<xsl:value-of select="$imageFolder"/>
				<xsl:value-of select="name"/>
				<xsl:value-of select="$imageSuffix"/>
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:text>Architecture Image: </xsl:text>
				<xsl:value-of select="name"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="$aDesc"/>
			</xsl:attribute>
		</img>

	</xsl:template>

</xsl:stylesheet>
