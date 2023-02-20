<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml">
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

	<xsl:import href="core_utilities.xsl"/>
	<xsl:import href="datatables_includes.xsl"/>
	<xsl:key name="allstyles_key" match="/node()/simple_instance[type = 'Viewer_Styling']" use="own_slot_value[slot_reference = 'style_is_active']/value"/>
	<xsl:variable name="activeViewerStylePre" select="key('allstyles_key','true')"/>
	<xsl:variable name="activeViewerStyle" select="$activeViewerStylePre[1]"/>
<!--
	<xsl:variable name="allViewerStyles" select="/node()/simple_instance[type = 'Viewer_Styling']"/>
	<xsl:variable name="activeViewerStyle" select="$allViewerStyles[own_slot_value[slot_reference = 'style_is_active']/value = 'true'][1]"/>
-->
	<xsl:template match="node()" name="commonHeadContent">
		<xsl:param name="requiresDataTables" select="true()"/>
		<!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<!--Setup common content for html head tag	-->
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
		<meta http-equiv="pragma" content="no-cache"/>
		<meta http-equiv="cache-control" content="no-cache"/>
		<!--<meta http-equiv="expires" content="-1" />-->
		<!--<meta http-equiv="X-UA-Compatible" content="chrome=1" />-->
		<meta name="viewport" content="width=device-width, initial-scale=1"/>
		<link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png"/>
		<link rel="shortcut icon" type="image/png" href="favicon-32x32.png" sizes="32x32"/>
		<link rel="shortcut icon" type="image/png" href="favicon-16x16.png" sizes="16x16"/>
		<link rel="manifest" href="manifest.json"/>
		<link rel="mask-icon" href="safari-pinned-tab.svg" color="#c3193c"/>
		<meta name="theme-color" content="#ffffff"/>
		<link rel="stylesheet" href="js/bootstrap-3.4.1-dist/css/bootstrap.min.css?release=6.17" type="text/css"/>
		<link rel="stylesheet" href="js/context-menu/jquery.contextMenu.min.css?release=6.17" type="text/css"/>
		<link rel="stylesheet" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css?release=6.17" type="text/css"/>
		<link href="js/select2/css/select2.min.css?release=6.17" rel="stylesheet"/>
		<link href="js/select2/css/select2-bootstrap.min.css?release=6.17" rel="stylesheet"/>
		<link href="js/hopscotch/css/ess-hopscotch.css?release=6.17" rel="stylesheet"/>
		<link rel="stylesheet" href="css/essential-core.css?release=6.17" type="text/css"/>
		<link href="fonts/source-sans/source-sans-pro.css?release=6.17" rel="stylesheet" type="text/css"/>
		<xsl:if test="$currentLanguage/own_slot_value[slot_reference = 'right_to_left_text']/value = 'true'">
			<link rel="stylesheet" href="css/essential_rtl.css?release=6.17" type="text/css"/>
		</xsl:if>
		<link rel="stylesheet" href="user/custom.css" type="text/css"/>
		<!--Standard JQuery Library-->
		<script type="text/javascript" src="js/jquery/jquery-3.6.3.min.js?release=6.17"/>
		<!--Custom JQuery UI library to support various visual effects-->
		<script type="text/javascript" src="js/jquery-ui/jquery-ui.min.js?release=6.17"/>
		<!--Resolve name collision between jQuery UI and Twitter Bootstrap-->
		<script>
		$.widget.bridge('uibutton', $.ui.button);
		$.widget.bridge('uitooltip', $.ui.tooltip);
		</script>
		<!-- file saver library -->
		<script type="text/javascript" src="js/FileSaver.min.js?release=6.17"/>
		<!--JQuery plugin to support popup menus for link navigation-->
		<script type="text/javascript" src="js/context-menu/jquery.contextMenu.js?release=6.17"/>
		<!--script to support the feedback page-->
		<script src="js/feedbackformmailer.js?release=6.17" type="text/javascript"/>
		<!--JQuery plugin to support vertical align within divs-->
		<script type="text/javascript" src="js/jquery.verticalalign.js?release=6.17"/>
		<!--Bootstrap JS library-->
		<script type="text/javascript" src="js/bootstrap-3.4.1-dist/js/bootstrap.min.js?release=6.17"/>
		<!--Match Height Library-->
		<script src="js/jquery.matchHeight.js?release=6.17" type="text/javascript"/>
		<script src="js/select2/js/select2.full.min.js?release=6.17"/>
		<!-- Handlebars templating library -->
		<script src="js/handlebars.min-v4.7.7.js?release=6.17"/>
		<!-- Date formatting library -->
		<script src="js/moment/moment.js?release=6.17"/>
		<!--Help text and tour library-->
		<script src="js/hopscotch/js/hopscotch.min.js?release=6.17"/>
		<!--script to show hide sections by click on the icon-->
		<script>
			$(document).ready(function () {$('.sectionIcon').click(function (){$(this).parent().children('.content-section').slideToggle(200);});});
		</script>
		<xsl:if test="$requiresDataTables">
			<xsl:call-template name="dataTablesLibrary"/>
		</xsl:if>
		<!--Later versions of bootstrap use Sanitize to filter certain DOM elements from popovers (including tables). This is our custom whitelist to workaround this-->
		<script>
			$(document).ready(function(){
				if($.fn.tooltip.Constructor != null) {
					var myDefaultWhiteList = $.fn.tooltip.Constructor.DEFAULTS.whiteList;
					myDefaultWhiteList.table = [];
					myDefaultWhiteList.thead = [];
					myDefaultWhiteList.tbody = [];
					myDefaultWhiteList.tfoot = [];
					myDefaultWhiteList.tr = [];
					myDefaultWhiteList.th = [];
					myDefaultWhiteList.td = [];
				}
			});
			
			this.name = "viewerWindow";
			
		</script>
		<xsl:variable name="viewerPrimaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'primary_header_colour_viewer']/value"/>
		<xsl:variable name="viewerSecondaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'secondary_header_colour_viewer']/value"/>
		<xsl:variable name="viewerAnchor" select="$activeViewerStyle/own_slot_value[slot_reference = 'link_anchor_colour']/value"/>
		<xsl:variable name="vIcon" select="$activeViewerStyle/own_slot_value[slot_reference = 'viewer_icon_colour']/value"/>
		<xsl:variable name="viewerPrimaryText" select="$activeViewerStyle/own_slot_value[slot_reference = 'viewer_text_primary_colour']/value"/>
		<xsl:variable name="viewerSecondaryText" select="$activeViewerStyle/own_slot_value[slot_reference = 'viewer_text_secondary_colour']/value"/>

		<style type="text/css">
			<xsl:if test="count($viewerPrimaryHeader) &gt; 0">.nav-color{background-color:<xsl:value-of select="$viewerPrimaryHeader"/>!important;}</xsl:if>
			<xsl:if test="count($viewerSecondaryHeader) &gt; 0">.app-brand-header{background-color:<xsl:value-of select="$viewerSecondaryHeader"/>!important;}</xsl:if>
			<xsl:if test="count($viewerAnchor) &gt; 0">a,a:hover{color:<xsl:value-of select="$viewerAnchor"/>}</xsl:if>
			<xsl:if test="count($vIcon) &gt; 0">.icon-color{color:<xsl:value-of select="$vIcon"/> !important;}</xsl:if>
			<xsl:if test="count($viewerPrimaryText) &gt; 0">.text-primary{color:<xsl:value-of select="$viewerPrimaryText"/> !important;}</xsl:if>
			<xsl:if test="count($viewerSecondaryText) &gt; 0">.text-secondary{color:<xsl:value-of select="$viewerSecondaryText"/>!important;}</xsl:if>
			<xsl:if test="count($viewerPrimaryHeader) &gt; 0">.bg-primary{background-color:<xsl:value-of select="$viewerPrimaryHeader"/>!important;}</xsl:if>
			<xsl:if test="count($viewerSecondaryHeader) &gt; 0">.bg-secondary{background-color:<xsl:value-of select="$viewerSecondaryHeader"/>!important;}</xsl:if>
		</style>
	</xsl:template>
</xsl:stylesheet>
