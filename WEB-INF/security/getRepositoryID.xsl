<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pro="http://protege.stanford.edu/xml"
    xpath-default-namespace="http://protege.stanford.edu/xml"
    version="2.0">
    
    <!--
		* Copyright ©2015-2016 Enterprise Architecture Solutions Limited.
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
    <!-- View to extract the repository ID from the repository snapshot
    -->
    <!-- 26.03.2015	JWC First implementation	 -->
    
    <xsl:output method="text" indent="no"/>
    
    <xsl:template match="knowledge_base">
        <!-- Find the repository/repositoryID tag value -->
        <xsl:value-of select="//repository/repositoryID"></xsl:value-of>
    </xsl:template>
    
</xsl:stylesheet>