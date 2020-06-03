<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan xs functx eas ess" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:include href="../common/core_analytics.xsl"/>
	<xsl:variable name="errorFile" select="document('../platform/errorXML.xml')"/>
	<xsl:variable name="currentViewerVersion" select="$errorFile//ess:viewerversion"/>
	<xsl:variable name="updateFile" select="document('https://s3.amazonaws.com/essential-updater/viewerLatestVersion.xml')"/>
	<xsl:variable name="latestViewerVersion" select="$updateFile//ess:viewerversion"/>
	

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
	<!-- 04.11.2008 JWC Migration to report servlet -->
	<!-- 06.11.2008	JWC Fixed page history for link from logo image -->
	<!-- 28.11.2008	JWC	Updated search URL to production Sharepoint server -->
	<!-- 28.01.2009 JWC	Migrate to use of divs for header -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- 25.11.2016	JWC Extended to ensure a sensible and useful timestamp is presented on the error page -->
	<!-- 14.08.2017 NJW Added Essential Update Check Feature-->

	<xsl:template match="node()" name="Footer">
		<!--Setup footers-->
		<footer>
			<div class="col-xs-9 bg-black text-white">
				<xsl:variable name="aTimestamp" select="timestamp"/>
				<xsl:choose>
					<xsl:when test="string-length($aTimestamp) > 0">
						<xsl:variable name="utcTimeStamp" select="format-dateTime($aTimestamp, '[M]/[D]/[Y] [h]:[m]:[s] [PN,2-2]')"/>
						<!--<span class="pageFooterLabel"><xsl:value-of select="eas:i18n('Essential Viewer last updated')"/>:&#160;<xsl:value-of select="format-dateTime($aTimestamp, '[h]:[m01][Pn] on [FNn] [D] [MNn] [Y]')"/></span>-->
						<span class="pageFooterLabel"><xsl:value-of select="eas:i18n('Essential Viewer last updated')"/>:&#160;</span>
						<span id="date">
							<script type="text/javascript">
							function localize(t){
							  var d=new Date(t+" UTC");
							  document.write(d.toString());
							};
							localize("<xsl:value-of select="$utcTimeStamp"/>");
						</script>
						</span>
						<xsl:if test="$eipMode = 'true'">
							<span class="pageFooterLabel"> from the <xsl:value-of select="repository/name"/> repository</span>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="currentTime" select="current-dateTime()"/>
						<xsl:variable name="utcTimeStamp" select="format-dateTime($currentTime, '[M]/[D]/[Y] [h]:[m]:[s] [PN,2-2]')"/>
						<span class="pageFooterLabel"><xsl:value-of select="eas:i18n('Essential Viewer: error occurred at')"/>&#160;</span>
						<span id="date">
							<script type="text/javascript">
								function localize(t){
								  var d=new Date(t+" UTC");
								  document.write(d.toString());
								};
								localize("<xsl:value-of select="$utcTimeStamp"/>");
							</script>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="col-xs-3 bg-black text-white alignRight">
				<xsl:value-of select="eas:i18n('Essential Viewer Version')"/>&#160;<xsl:value-of select="$currentViewerVersion"/><span class="text-white" id="viewerUpdateText"/>
			</div>
			<input type="hidden" id="currentViewerVersion">
				<xsl:attribute name="value" select="$currentViewerVersion"/>
			</input>
			<input type="hidden" id="viewerLatestVersion" >
				<xsl:attribute name="value" select="$latestViewerVersion"/>
			</input>
		</footer>
		<!--Essential Update Check - Comment out the lines below to stop checking for updates-->
		<script type="text/javascript" src="js/compareVersions.js"/>
		<script>
			$(document).ready(function(){
				var viewerCurrentVersion =  $('#currentViewerVersion').val();
				var viewerLatestVersion =  $('#viewerLatestVersion').val();
				if (compareVersions(viewerCurrentVersion,viewerLatestVersion)) {
					$('#viewerUpdateText').html(' - <a href="https://www.enterprise-architecture.org/essential_update.php?viewerCurrentVersion='+viewerCurrentVersion+'&amp;viewerLatestVersion='+viewerLatestVersion+'" target="_blank">Update Available</a>');
				};
			});
		</script>
		<!--Essential Update Check End-->
		<!--Repository Configured Analytics - Use Report_Constant to configure Code-->
		<xsl:call-template name="analytics"/>
	</xsl:template>

</xsl:stylesheet>
