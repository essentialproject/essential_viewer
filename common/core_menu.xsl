<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="pro xalan xs functx fn eas" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xpath-default-namespace="http://protege.stanford.edu/xml" version="2.0" 
	xmlns:eas="http://www.enterprise-architecture.org/essential" 
	xmlns:xalan="http://xml.apache.org/xslt" 
	xmlns:pro="http://protege.stanford.edu/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:functx="http://www.functx.com"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<!--
        * Copyright ©2008-2019 Enterprise Architecture Solutions Limited.
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
	<!-- 14.03.2012 JP - Contains a generic template to create the popup for the menu identified by the given parameter -->
	<!-- 29.01.2015 JWC - Added the security clearance check implementation -->
	<!-- 02.04.2019	JWC - Improved rendering of labels in URLs -->
	<xsl:import href="../WEB-INF/security/viewer_security.xsl"/>

	<!-- Set up the required variables for the menu -->
	<xsl:variable name="allMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="allMenuGroups" select="/node()/simple_instance[type = 'Report_Menu_Group']"/>
	<xsl:variable name="allMenuItems" select="/node()/simple_instance[(type = 'Report_Menu_Item') and (own_slot_value[slot_reference = 'report_menu_item_is_enabled']/value = 'true')]"/>
	<xsl:variable name="allMenuItemCategories" select="/node()/simple_instance[type = 'Menu_Item_Category']"/>
	
	<xsl:variable name="allMenuItemTargets" select="/node()/simple_instance[name = $allMenuItems/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>
	<xsl:variable name="allTargetEditorSections" select="$allMenuItemTargets[type = 'Editor_Section']"/>
	<xsl:variable name="allTargetEditors" select="/node()/simple_instance[name = $allTargetEditorSections/own_slot_value[slot_reference = 'editor_section_parent']/value]"/>
	<xsl:variable name="allTargetReports" select="$allMenuItemTargets[type = 'Report']"/>
	<xsl:variable name="allReportMenuItems" select="$allMenuItems[own_slot_value[slot_reference = 'report_menu_item_target_report']/value = $allTargetReports/name]"/>
	<xsl:variable name="allEditorMenuItems" select="$allMenuItems[own_slot_value[slot_reference = 'report_menu_item_target_report']/value = $allTargetEditorSections/name]"/>
	
	<xsl:variable name="allTargetReportParameters" select="/node()/simple_instance[name = ($allTargetReports, $allTargetEditors)/own_slot_value[slot_reference = 'report_parameters']/value]"/>
	<xsl:variable name="allTargetReportParameterInstanceVals" select="/node()/simple_instance[name = $allTargetReportParameters/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>
	<xsl:variable name="allMenuTargetReportTypes" select="/node()/simple_instance[type = 'Report_Implementation_Type']"/>

	<!-- Define any constant values that are used throughout -->
	<xsl:variable name="urlNameSuffix" select="'URL'"/>
	<xsl:variable name="editorXSLPath" select="'ess_editor.xsl'"/>

	<xsl:template name="RenderPopUpJavascript">
		<!-- thisMenu = the menu to be presented -->
		<xsl:param name="thisMenu"/>
		<!-- boolean as to whether a new window/tab should be opened -->
		<xsl:param name="newWindow" select="false()"/>
		
		<script type="text/javascript">
        <xsl:for-each select="$thisMenu">
            <xsl:variable name="thisMenuShortName" select="current()/own_slot_value[slot_reference = 'report_menu_short_name']/value"/>
            <xsl:variable name="thisMenuDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>
            <xsl:variable name="thisMenuGroups" select="$allMenuGroups[name = current()/own_slot_value[slot_reference = 'report_menu_groups']/value]"/>
            <xsl:variable name="thisMenuItems" select="$allMenuItems[name = $thisMenuGroups/own_slot_value[slot_reference = 'report_menu_items']/value]"/>
        	<xsl:variable name="thisReportMenuItems" select="$thisMenuItems[name = $allReportMenuItems/name]"/>
        	<xsl:variable name="thisEditorMenuItems" select="$thisMenuItems[name = $allEditorMenuItems/name]"/>
            <!-- Define the menu intro text -->
        	<xsl:variable name="thisMenuIntro">
                <xsl:choose>
                    <xsl:when test="string-length($thisMenuDesc) > 0"><xsl:value-of select="$thisMenuDesc"/></xsl:when>
                    <xsl:otherwise>Select a View/Editor:</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
        	<!-- Render the functions for menu items that target Reports -->
            <xsl:apply-templates mode="RenderReportMenuItemFunction" select="$thisReportMenuItems">
            	<xsl:with-param name="newWindow" select="$newWindow"/>
            </xsl:apply-templates>
        	<!-- Render the functions for menu items that target Editors -->
        	<!--<xsl:if test="$eipMode = 'true'">
        		<xsl:apply-templates mode="RenderEditorMenuItemFunction" select="$thisEditorMenuItems"/>
        	</xsl:if>-->
        	<xsl:apply-templates mode="RenderEditorMenuItemFunction" select="$thisEditorMenuItems"/>
        	
        	<!-- Render the function that pops up the context menu -->
            $(function(){$.contextMenu({selector: '.context-menu-<xsl:value-of select="$thisMenuShortName"/>',trigger: 'left',ignoreRightClick: true,autoHide: false,animation: {duration: 100, show: "fadeIn", hide: "fadeOut"},items: {title:	{type: "html", html: '<span class="uppercase fontBold menuTitle"><xsl:value-of select="$thisMenuIntro"/></span>', icon: "none"},
        		<!-- Render the entries for menu items that target Reports -->
        		<xsl:apply-templates mode="RenderMenuGroupEntries" select="$thisMenuGroups"/>
        		<!-- If defined, render the entries for menu items that target Editors -->
        		<!-- UNCOMMENT WHEN PUBLISHING -->
        		<!--<xsl:if test="($eipMode = 'true') and (count($thisEditorMenuItems) > 0)">
        			, "sep1": "-\-\-\-\-\-\-\-\-",<xsl:apply-templates mode="RenderMenuItemEntries" select="$thisEditorMenuItems"/>
        		</xsl:if>-->
        		<xsl:if test="count($thisEditorMenuItems) > 0">, "sep1": "---------",<xsl:apply-templates mode="RenderMenuItemEntries" select="$thisEditorMenuItems"/></xsl:if>}});
        	});
        </xsl:for-each>
        </script>
	</xsl:template>





	<xsl:template mode="RenderReportMenuItemFunction" match="node()">
		<!-- boolean as to whether a new window/tab should be opened -->
		<xsl:param name="newWindow" select="false()"/>
		
		<xsl:variable name="menuItemShortName" select="current()/own_slot_value[slot_reference = 'menu_item_short_name']/value"/>
		<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $urlNameSuffix)"/>
		<xsl:variable name="menuItemTargetReport" select="$allTargetReports[name = current()/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>
		<xsl:variable name="menuItemTargetXSLPath" select="$menuItemTargetReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		<xsl:variable name="menuItemTargetContextXSLPath" select="$menuItemTargetReport/own_slot_value[slot_reference = 'report_context_xsl_filename']/value"/>
		<xsl:variable name="menuItemTargetHistoryLabel" select="fn:encode-for-uri($menuItemTargetReport/own_slot_value[slot_reference = 'report_history_label']/value)"/>
		<xsl:variable name="menuItemTargetReportType" select="$allMenuTargetReportTypes[name = $menuItemTargetReport/own_slot_value[slot_reference = 'report_implementation_type']/value]"/>
		<xsl:variable name="menuItemTargetReportParameters" select="$allTargetReportParameters[name = $menuItemTargetReport/own_slot_value[slot_reference = 'report_parameters']/value]"/>
		<xsl:variable name="menuItemTargetReportParameterInstanceVals" select="$allTargetReportParameterInstanceVals[name = $menuItemTargetReportParameters/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>
		
		<xsl:variable name="menuItemParamString">
			<xsl:apply-templates mode="RenderMenuItemParameters" select="$menuItemTargetReportParameters"><xsl:with-param name="paramInstanceVals" select="$menuItemTargetReportParameterInstanceVals"/></xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="pathPrefix">
			<xsl:choose>
				<xsl:when test="$menuItemTargetReportType/own_slot_value[slot_reference = 'enumeration_value']/value = 'uml'">uml_model.jsp</xsl:when>
				<xsl:otherwise>report</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$newWindow">
				function <xsl:value-of select="$menuItemFunctionName"/>(key,opt) { window.open("<xsl:value-of select="$pathPrefix"/>" + opt.$trigger.attr("href") + "&amp;XSL=<xsl:value-of select="$menuItemTargetXSLPath"/>&amp;PAGEXSL=<xsl:value-of select="$menuItemTargetContextXSLPath"/><xsl:value-of select="$menuItemParamString"/>&amp;LABEL=<xsl:value-of select="$menuItemTargetHistoryLabel"/>" + encodeURI(opt.$trigger.attr("id")), "_blank"); }
			</xsl:when>
			<xsl:otherwise>
				function <xsl:value-of select="$menuItemFunctionName"/>(key,opt) { window.location="<xsl:value-of select="$pathPrefix"/>" + opt.$trigger.attr("href") + "&amp;XSL=<xsl:value-of select="$menuItemTargetXSLPath"/>&amp;PAGEXSL=<xsl:value-of select="$menuItemTargetContextXSLPath"/><xsl:value-of select="$menuItemParamString"/>&amp;LABEL=<xsl:value-of select="$menuItemTargetHistoryLabel"/>" + encodeURI(opt.$trigger.attr("id")); }
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template mode="RenderEditorMenuItemFunction" match="node()">
		<!-- boolean as to whether a new window/tab should be opened -->
		
		<xsl:variable name="menuItemShortName" select="current()/own_slot_value[slot_reference = 'menu_item_short_name']/value"/>
		<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $urlNameSuffix)"/>
		<xsl:variable name="menuItemTargetEditorSection" select="$allTargetEditorSections[name = current()/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>
		<xsl:variable name="menuItemTargetEditorSectionId" select="$menuItemTargetEditorSection/own_slot_value[slot_reference = 'editor_section_anchor_id']/value"/>
		<xsl:variable name="menuItemTargetEditor" select="$allTargetEditors[name = $menuItemTargetEditorSection/own_slot_value[slot_reference = 'editor_section_parent']/value]"/>
		<xsl:variable name="menuItemTargetHistoryLabel" select="$menuItemTargetEditor/own_slot_value[slot_reference = 'report_history_label']/value"/>
		<xsl:variable name="menuItemTargetReportType" select="$allMenuTargetReportTypes[name = $menuItemTargetEditor/own_slot_value[slot_reference = 'report_implementation_type']/value]"/>
		<xsl:variable name="menuItemTargetReportParameters" select="$allTargetReportParameters[name = $menuItemTargetEditor/own_slot_value[slot_reference = 'report_parameters']/value]"/>
		<xsl:variable name="menuItemTargetReportParameterInstanceVals" select="$allTargetReportParameterInstanceVals[name = $menuItemTargetReportParameters/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>
		
		<xsl:variable name="menuItemParamString">
			<xsl:apply-templates mode="RenderMenuItemParameters" select="$menuItemTargetReportParameters"><xsl:with-param name="paramInstanceVals" select="$menuItemTargetReportParameterInstanceVals"/></xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="pathPrefix">report</xsl:variable>
		
		function <xsl:value-of select="$menuItemFunctionName"/>(key,opt) { window.open("<xsl:value-of select="$pathPrefix"/>" + opt.$trigger.attr("href") + "&amp;XSL=<xsl:value-of select="$editorXSLPath"/><xsl:value-of select="$menuItemParamString"/>&amp;LABEL=<xsl:value-of select="$menuItemTargetHistoryLabel"/>&amp;EDITOR=<xsl:value-of select="$menuItemTargetEditor/name"/>&amp;SECTION=<xsl:value-of select="$menuItemTargetEditorSectionId"/>", "_blank"); }
	</xsl:template>


	<xsl:template mode="RenderMenuGroupEntries" match="node()">
		<!--<xsl:variable name="menuGroupLabel" select="current()/own_slot_value[slot_reference = 'report_menu_group_label']/value"/>-->
		<xsl:variable name="thisGroupReportMenuItems" select="$allReportMenuItems[name = current()/own_slot_value[slot_reference = 'report_menu_items']/value]"/>

		<xsl:choose>
			<xsl:when test="count($thisGroupReportMenuItems) > 0">
				<xsl:if test="position() > 1">, "sep1": "---------",</xsl:if>
				<!--   title:	{type: "html", html: '<span class="uppercase fontBlack text-darkgrey"><xsl:value-of select="$menuGroupLabel"/></span>', icon: "none"},-->
				<xsl:apply-templates mode="RenderMenuItemEntries" select="$thisGroupReportMenuItems"/>
			</xsl:when>
			<xsl:otherwise> title: {type: "html", html: '<span class="uppercase fontBlack menuTitle"><em>No view menu items defined</em></span>', icon: "none"} </xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	
	

	<xsl:template mode="RenderMenuItemEntries" match="node()">

		<!-- Check that user can access target report before rendering the menu item -->
		<xsl:variable name="menuItemTargetReport" select="$allMenuItemTargets[name = current()/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>
		<xsl:if test="eas:isUserAuthZ($menuItemTargetReport)">
			<xsl:variable name="menuItemShortName" select="current()/own_slot_value[slot_reference = 'menu_item_short_name']/value"/>
			<xsl:variable name="menuItemLabel" select="current()/own_slot_value[slot_reference = 'menu_item_label']/value"/>
			<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $urlNameSuffix)"/>
			<xsl:variable name="menuItemCategory" select="$allMenuItemCategories[name = current()/own_slot_value[slot_reference = 'report_menu_item_category']/value]"/>
			<xsl:variable name="menuItemIconName" select="$menuItemCategory/own_slot_value[slot_reference = 'enumeration_icon']/value"/>
			<xsl:value-of select="$menuItemShortName"/>: {name: "<xsl:value-of select="$menuItemLabel"/>", icon: "<xsl:value-of select="$menuItemIconName"/>", callback: <xsl:value-of select="$menuItemFunctionName"/>}<xsl:if test="not(position() = last())">,</xsl:if>
		</xsl:if>
		<!-- If not cleared, render nothing -->
	</xsl:template>
	
	
	
	<xsl:template mode="RenderMenuItemParameters" match="node()">
		<xsl:param name="paramInstanceVals" select="()"/>
		
		<xsl:variable name="thisParam" select="current()"/>
		<xsl:variable name="thisParamInstanceVal" select="$paramInstanceVals[name = $thisParam/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>
		
		<xsl:variable name="thisParamName" select="$thisParam/own_slot_value[slot_reference = 'report_parameter_name']/value"/>
		<xsl:variable name="thisParamValue">
			<xsl:choose>
				<xsl:when test="count($thisParamInstanceVal) > 0">
					<xsl:value-of select="$thisParamInstanceVal/name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$thisParam/own_slot_value[slot_reference = 'report_parameter_string_value']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="(string-length($thisParamName) > 0) and (string-length($thisParamValue) > 0)">&amp;<xsl:value-of select="$thisParamName"/>=<xsl:value-of select="$thisParamValue"/></xsl:if>
		
	</xsl:template>


	<xsl:template mode="RenderMenuItemParameters" match="node()">
		<xsl:param name="paramInstanceVals" select="()"/>
		
		<xsl:variable name="thisParam" select="current()"/>
		<xsl:variable name="thisParamInstanceVal" select="$paramInstanceVals[name = $thisParam/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>
		
		<xsl:variable name="thisParamName" select="$thisParam/own_slot_value[slot_reference = 'report_parameter_name']/value"/>
		<xsl:variable name="thisParamValue">
			<xsl:choose>
				<xsl:when test="count($thisParamInstanceVal) > 0">
					<xsl:value-of select="$thisParamInstanceVal/name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$thisParam/own_slot_value[slot_reference = 'report_parameter_string_value']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="(string-length($thisParamName) > 0) and (string-length($thisParamValue) > 0)">&amp;<xsl:value-of select="$thisParamName"/>=<xsl:value-of select="$thisParamValue"/></xsl:if>
		
	</xsl:template>


	<xsl:template name="RenderMenuItemEntriesOLD">
		<xsl:param name="menuItems"/>

		<xsl:variable name="menuItemsSize" select="count($menuItems)"/>
		<xsl:for-each select="$menuItems">
			<xsl:variable name="menuItemShortName" select="current()/own_slot_value[slot_reference = 'menu_item_short_name']/value"/>
			<xsl:variable name="menuItemLabel" select="current()/own_slot_value[slot_reference = 'menu_item_label']/value"/>
			<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $urlNameSuffix)"/>
			<xsl:variable name="menuItemCategory" select="$allMenuItemCategories[name = current()/own_slot_value[slot_reference = 'report_menu_item_category']/value]"/>
			<xsl:variable name="menuItemIconName" select="$menuItemCategory/own_slot_value[slot_reference = 'enumeration_icon']/value"/>
			<xsl:value-of select="$menuItemShortName"/>: {name: "<xsl:value-of select="$menuItemLabel"/>", icon: "<xsl:value-of select="$menuItemIconName"/>", callback: <xsl:value-of select="$menuItemFunctionName"/>}<xsl:if test="not(index = $menuItemsSize)">, </xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	
	<!-- function that returns the names of the classes for which a given report is defined -->
	<xsl:function name="eas:getClassNamesForReport">
		<xsl:param name="theReport"/>
		
		<xsl:variable name="repMenuItem" select="$allMenuItems[own_slot_value[slot_reference = 'report_menu_item_target_report']/value = $theReport/name]"/>
		<xsl:variable name="repMenuGroup" select="$allMenuGroups[own_slot_value[slot_reference = 'report_menu_items']/value = $repMenuItem/name]"/>
		<xsl:variable name="repMenus" select="$allMenus[own_slot_value[slot_reference = 'report_menu_groups']/value = $repMenuGroup/name]"/>
		
		<xsl:sequence select="$repMenus/own_slot_value[slot_reference = 'report_menu_class']/value"/>
		
	</xsl:function>


	<!-- TEMPLATE TO CREATE THE QUERY STRING FOR PASSING THE MENU ID PARAMETER -->
	<!--<xsl:template name="ConstructMenuParamQueryString">
        <xsl:param name="menuPassed"/>
        <xsl:text>&amp;menuId=</xsl:text><xsl:value-of select="$menuPassed/name"/>
    </xsl:template>-->


</xsl:stylesheet>
