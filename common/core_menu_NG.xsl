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
	<!-- 20.049.2023	JP - Migrated to Next Gen Viewer -->
	
	<xsl:import href="../WEB-INF/security/viewer_security.xsl"/>
	<xsl:include href="core_modal_reports_NG.xsl"/>
	
	<xsl:param name="allMenuRepoVersionsXML"/>
	<xsl:param name="allMenusXML"/>
	<xsl:param name="allMenuGroupsXML"/>
	<xsl:param name="allMenuItemsXML"/>
	<xsl:param name="allMenuItemCategoriesXML"/>
	<xsl:param name="allMenuItemTargetsXML"/>
	<xsl:param name="menuIdeationConstantInstXML"/>
	<xsl:param name="menuEdmEditConstantInstXML"/>
	<xsl:param name="allMenuReportParamsXML"/>
	<xsl:param name="allMenuTargetReportTypesXML"/>
	
	
	<eas:apiRequests>
		
		{
			"apiRequestSet": [
				{
				"variable": "allMenuRepoVersionsXML",
				"query": "/instances/type/Meta_Model_Version"
				},
				{
				"variable": "allMenusXML",
				"query": "/instances/type/Report_Menu"
				},
				{
				"variable": "allMenuGroupsXML",
				"query": "/instances/type/Report_Menu_Group"
				},
				{
				"variable": "allMenuItemsXML",
				"query": "/instances/type/Report_Menu_Item"
				},
				{
				"variable": "allMenuItemCategoriesXML",
				"query": "/instances/type/Menu_Item_Category"
				},
				{
				"variable": "allMenuItemTargetsXML",
				"query": "/instances/multiple_types?type=Report&amp;type=Editor&amp;type=Simple_Editor&amp;type=Configured_Editor&amp;type=Editor_Section"
				},
				{
				"variable": "menuIdeationConstantInstXML",
				"query": "/instances/type/Report_Constant?name=Ideation Enabled"
				},
        {
				"variable": "menuEdmEditConstantInstXML",
				"query": "/instances/type/Report_Constant?name=Edit in Repository Enabled"
				},
				{
				"variable": "allMenuReportParamsXML",
				"query": "/instances/type/Report_Parameter"
				},
				{
				"variable": "allMenuTargetReportTypesXML",
				"query": "/instances/type/Report_Implementation_Type"
				}
			]
		}  
		
	</eas:apiRequests>

	<xsl:variable name="allMenuRepoVersions" select="$allMenuRepoVersionsXML//simple_instance"/>
	<xsl:variable name="allMenus" select="$allMenusXML//simple_instance"/>
	<xsl:variable name="allMenuGroups" select="$allMenuGroupsXML//simple_instance"/>
	<xsl:variable name="allMenuItems" select="$allMenuItemsXML//simple_instance"/>
	<xsl:variable name="allMenuItemCategories" select="$allMenuItemCategoriesXML//simple_instance"/>
	<xsl:variable name="allMenuItemTargets" select="$allMenuItemTargetsXML//simple_instance"/>
	<xsl:variable name="menuIdeationConstantInst" select="$menuIdeationConstantInstXML//simple_instance"/>
	<xsl:variable name="menuEdmEditConstantInst" select="$menuEdmEditConstantInstXML//simple_instance"/>
	<xsl:variable name="allMenuReportParams" select="$allMenuReportParamsXML//simple_instance"/>
	<xsl:variable name="allMenuTargetReportTypes" select="$allMenuTargetReportTypesXML//simple_instance"/>
	

	<!-- Set up the required variables for the menu -->
	<!--<xsl:variable name="allMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="allMenuGroups" select="/node()/simple_instance[type = 'Report_Menu_Group']"/>
	<xsl:variable name="allMenuItems" select="/node()/simple_instance[(type = 'Report_Menu_Item') and (own_slot_value[slot_reference = 'report_menu_item_is_enabled']/value = 'true')]"/>
	<xsl:variable name="allMenuItemCategories" select="/node()/simple_instance[type = 'Menu_Item_Category']"/>-->
	
	<!--<xsl:variable name="allMenuItemTargets" select="/node()/simple_instance[name = $allMenuItems/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>-->
	<xsl:variable name="menuRepoVersion" select="$allMenuRepoVersions[1]/own_slot_value[slot_reference = 'meta_model_version_id']/value"/>
	<xsl:variable name="allTargetEditorSections" select="$allMenuItemTargets[type = 'Editor_Section']"/>
	<xsl:variable name="allTargetSimpleEditors" select="$allMenuItemTargets[type = 'Simple_Editor']"/>
	<xsl:variable name="allTargetEditors" select="($allTargetSimpleEditors, $allMenuItemTargets[name = $allTargetEditorSections/own_slot_value[slot_reference = 'editor_section_parent']/value])"/>
	<xsl:variable name="allTargetReports" select="$allMenuItemTargets[type = 'Report']"/>
	<xsl:variable name="allReportMenuItems" select="$allMenuItems[own_slot_value[slot_reference = 'report_menu_item_target_report']/value = $allTargetReports/name]"/>
	<xsl:variable name="allEditorMenuItems" select="$allMenuItems[own_slot_value[slot_reference = 'report_menu_item_target_report']/value = ($allTargetEditorSections, $allTargetSimpleEditors)/name]"/>
	
	<xsl:variable name="allTargetReportParameters" select="$allMenuReportParams[name = ($allTargetReports, $allTargetEditors)/own_slot_value[slot_reference = 'report_parameters']/value]"/>
	<!--<xsl:variable name="allTargetReportParameterInstanceVals" select="/node()/simple_instance[name = $allTargetReportParameters/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>-->
	<!--<xsl:variable name="allMenuTargetReportTypes" select="/node()/simple_instance[type = 'Report_Implementation_Type']"/>-->
	
	<!--The published repo Name and ID-->
	<xsl:variable name="repoName" select="/node()/repository/name"/>
	<xsl:variable name="repoID" select="/node()/repository/repositoryID"/>

	<!-- Define any constant values that are used throughout -->
	<xsl:variable name="urlNameSuffix" select="'URL'"/>
	<xsl:variable name="editorXSLPath" select="'ess_editor.xsl'"/>
	<xsl:variable name="configuredEditorXSLPath" select="'ess_editor.xsl'"/>

	<xsl:variable name="menuIdeationConstant" select="$menuIdeationConstantInst/own_slot_value[slot_reference = 'report_constant_value']/value"/>
	<xsl:variable name="menuIdeationIsOn" select="string-length($menuIdeationConstant[1])"/>
	
	<xsl:variable name="menuEdmEditConstant" select="$menuEdmEditConstantInst/own_slot_value[slot_reference = 'report_constant_value']/value"/>
	<xsl:variable name="menuEdmEditIsOn" select="string-length($menuEdmEditConstant[1]) > 0"/>
	<!--<xsl:variable name="menuEdmEditIsOn" select="'true'"/>-->

	<xsl:variable name="menuSupportsCollab" select="eas:menuCompareVersionNumbers($menuRepoVersion, '6.6')"/>

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
            <xsl:variable name="thisMenuItems" select="$allMenuItems[(eas:isUserAuthZ(.)) and (name = $thisMenuGroups/own_slot_value[slot_reference = 'report_menu_items']/value)]"/>
        	<xsl:variable name="thisReportMenuItems" select="$thisMenuItems[name = $allReportMenuItems/name]"/>
        	<xsl:variable name="thisEditorMenuItems" select="$thisMenuItems[name = $allEditorMenuItems/name]"/>
            
        	<xsl:variable name="thisMenuModals" select="$essAllModalReports[own_slot_value[slot_reference = 'modal_report_for_classes']/value = current()/own_slot_value[slot_reference = 'report_menu_class']/value]"/>
        	<!-- Define the menu intro text -->
        	<xsl:variable name="thisMenuIntro">
                <xsl:choose>
                    <xsl:when test="string-length($thisMenuDesc) > 0"><xsl:value-of select="$thisMenuDesc"/></xsl:when>
                    <xsl:otherwise>Select a View/Editor:</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
        	<!-- Render the functions for menu items that target Modal Reports -->
            <xsl:apply-templates mode="RenderModalMenuItemFunction" select="$thisMenuModals"/>            
        	
        	<!-- Render the functions for menu items that target Reports -->
            <xsl:apply-templates mode="RenderReportMenuItemFunction" select="$thisReportMenuItems">
            	<xsl:with-param name="newWindow" select="$newWindow"/>
            </xsl:apply-templates>
        	<!-- Render the functions for menu items that target Editors -->
        	<!--<xsl:if test="$eipMode = 'true'">
        		<xsl:apply-templates mode="RenderEditorMenuItemFunction" select="$thisEditorMenuItems"/>
        	</xsl:if>-->
        	<xsl:apply-templates mode="RenderEditorMenuItemFunction" select="$thisEditorMenuItems"/>
        	
        	<!--Build the Edit in EDM Menu Functions-->
        	<xsl:call-template name="edmEditMenu"/>

        	<!-- Render the function that pops up the context menu -->
            $(function(){$.contextMenu({selector: '.context-menu-<xsl:value-of select="$thisMenuShortName"/>',zIndex: 1000, trigger: 'left',ignoreRightClick: true,autoHide: false,animation: {duration: 100, show: "fadeIn", hide: "fadeOut"},items: {title:	{type: "html", html: '<span class="uppercase fontBold menuTitle"><xsl:value-of select="$thisMenuIntro"/></span>', icon: "none"}
        		
        		<!-- Render the entries for menu items that target Reports -->
        		<xsl:apply-templates mode="RenderMenuGroupEntries" select="$thisMenuGroups"/>
        		<!-- If defined, render the entries for menu items that target Editors -->
        		<xsl:if test="($eipMode = 'true') and $menuSupportsCollab and (count($thisEditorMenuItems) > 0)">, "sep1": "---------"<xsl:apply-templates mode="RenderMenuItemEntries" select="$thisEditorMenuItems"/></xsl:if>
        		<xsl:if test="($menuEdmEditIsOn) and ($eipMode = 'true')">
        			, "sep2": "---------"
        			, edmEditMenu: {name: "Edit in <xsl:value-of select="$repoName"/> Repository",icon: "edit",callback: edmEditURL}
        		</xsl:if>
        		<xsl:if test="($menuIdeationIsOn) and ($eipMode = 'true') and $menuSupportsCollab and (count($thisMenuModals) > 0)">
					, "sep3": "---------"
	        		<xsl:apply-templates mode="RenderMenuItemModalEntries" select="$thisMenuModals"/>
        		</xsl:if>}});
        	});
        </xsl:for-each>
        </script>
	</xsl:template>
	
	<xsl:template name="edmEditMenu">
        <xsl:variable name="edmEditURL" select="concat('/app/#/Repo/',$repoID,'/EditInstance/')"/>
        function edmEditURL(key,opt){
        	var instanceHref= opt.$trigger.attr("href");
			//console.log(instanceHref);
			const urlParams = new URLSearchParams(instanceHref);
			const instanceID = urlParams.get('PMA')
			//console.log(instanceID);
			theURL = "<xsl:value-of select="$edmEditURL"/>"+instanceID
        	window.open(theURL, "edmWindow");
		}
	</xsl:template>
	
	<xsl:template name="RenderEditorPopUpJavascript">
		<!-- thisMenu = the menu to be presented -->
		<xsl:param name="thisMenu"/>
		<!-- boolean as to whether a new window/tab should be opened -->
		<xsl:param name="newWindow" select="false()"/>
		
		<script type="text/javascript">
        <xsl:for-each select="$thisMenu">
            <xsl:variable name="thisMenuShortName" select="current()/own_slot_value[slot_reference = 'report_menu_short_name']/value"/>
            <xsl:variable name="thisMenuDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>
            <xsl:variable name="thisMenuGroups" select="$allMenuGroups[name = current()/own_slot_value[slot_reference = 'report_menu_groups']/value]"/>
            <xsl:variable name="thisMenuItems" select="$allMenuItems[(eas:isUserAuthZ(.)) and (name = $thisMenuGroups/own_slot_value[slot_reference = 'report_menu_items']/value)]"/>
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
            	<xsl:with-param name="fromEditor" select="true()"/>
            	<xsl:with-param name="newWindow" select="$newWindow"/>
            </xsl:apply-templates>
        	<xsl:apply-templates mode="RenderEditorMenuItemFunction" select="$thisEditorMenuItems"/>
        	
        	<!-- Render the function that pops up the context menu -->
            $(function(){$.contextMenu({selector: '.context-menu-<xsl:value-of select="$thisMenuShortName"/>',zIndex: 100, trigger: 'left',ignoreRightClick: true,autoHide: false,animation: {duration: 100, show: "fadeIn", hide: "fadeOut"},items: {title:	{type: "html", html: '<span class="uppercase fontBold menuTitle"><xsl:value-of select="$thisMenuIntro"/></span>', icon: "none"}
        		
        		<!-- Render the entries for menu items that target Reports -->
        		<xsl:apply-templates mode="RenderMenuGroupEntries" select="$thisMenuGroups"/>
        		<!-- If defined, render the entries for menu items that target Editors -->
        		<xsl:if test="($eipMode = 'true') and $menuSupportsCollab and (count($thisEditorMenuItems) > 0)">, "1": "---------"<xsl:apply-templates mode="RenderMenuItemEntries" select="$thisEditorMenuItems"/></xsl:if>
        		}});
        	});
        </xsl:for-each>
        </script>
	</xsl:template>

	
	
	<xsl:template mode="RenderModalMenuItemFunction" match="node()">		
		<xsl:call-template name="RenderShowModalJSFunction">
			<xsl:with-param name="aModal" select="current()"/>
		</xsl:call-template>
	</xsl:template>



	<xsl:template mode="RenderReportMenuItemFunction" match="node()">
		<!-- boolean as to whether a new window/tab should be opened -->
		<xsl:param name="newWindow" select="false()"/>
		<xsl:param name="fromEditor" select="false()"/>
		
		<xsl:variable name="menuItemShortName" select="current()/own_slot_value[slot_reference = 'menu_item_short_name']/value"/>
		<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $urlNameSuffix)"/>
		<xsl:variable name="menuItemTargetReport" select="$allTargetReports[name = current()/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>
		<xsl:variable name="menuItemTargetXSLPath" select="$menuItemTargetReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		<xsl:variable name="menuItemTargetContextXSLPath" select="$menuItemTargetReport/own_slot_value[slot_reference = 'report_context_xsl_filename']/value"/>
		<xsl:variable name="menuItemTargetHistoryLabel" select="fn:encode-for-uri($menuItemTargetReport/own_slot_value[slot_reference = 'report_history_label']/value)"/>
		<xsl:variable name="menuItemTargetReportType" select="$allMenuTargetReportTypes[name = $menuItemTargetReport/own_slot_value[slot_reference = 'report_implementation_type']/value]"/>
		<xsl:variable name="menuItemTargetReportParameters" select="$allTargetReportParameters[name = $menuItemTargetReport/own_slot_value[slot_reference = 'report_parameters']/value]"/>
		<!--<xsl:variable name="menuItemTargetReportParameterInstanceVals" select="$allTargetReportParameterInstanceVals[name = $menuItemTargetReportParameters/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>-->
		
		<xsl:variable name="menuItemParamString">
			<xsl:apply-templates mode="RenderNGMenuItemParameters" select="$menuItemTargetReportParameters"/>
		</xsl:variable>
		
		<xsl:variable name="pathPrefix">
			<xsl:choose>
				<xsl:when test="$menuItemTargetReportType/own_slot_value[slot_reference = 'enumeration_value']/value = 'uml'">uml_model.jsp</xsl:when>
				<xsl:otherwise>report</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$fromEditor">
				function <xsl:value-of select="$menuItemFunctionName"/>(key,opt) { window.open("<xsl:value-of select="$pathPrefix"/>" + opt.$trigger.attr("href") + "&amp;XSL=<xsl:value-of select="$menuItemTargetXSLPath"/>&amp;PAGEXSL=<xsl:value-of select="$menuItemTargetContextXSLPath"/><xsl:value-of select="$menuItemParamString"/>&amp;LABEL=<xsl:value-of select="$menuItemTargetHistoryLabel"/>" + encodeURIComponent(opt.$trigger.attr("id")), "viewerWindow"); }
			</xsl:when>
			<xsl:when test="$newWindow">
				function <xsl:value-of select="$menuItemFunctionName"/>(key,opt) { window.open("<xsl:value-of select="$pathPrefix"/>" + opt.$trigger.attr("href") + "&amp;XSL=<xsl:value-of select="$menuItemTargetXSLPath"/>&amp;PAGEXSL=<xsl:value-of select="$menuItemTargetContextXSLPath"/><xsl:value-of select="$menuItemParamString"/>&amp;LABEL=<xsl:value-of select="$menuItemTargetHistoryLabel"/>" + encodeURIComponent(opt.$trigger.attr("id")), "_blank"); }
			</xsl:when>
			<xsl:otherwise>
				function <xsl:value-of select="$menuItemFunctionName"/>(key,opt) { window.location="<xsl:value-of select="$pathPrefix"/>" + opt.$trigger.attr("href") + "&amp;XSL=<xsl:value-of select="$menuItemTargetXSLPath"/>&amp;PAGEXSL=<xsl:value-of select="$menuItemTargetContextXSLPath"/><xsl:value-of select="$menuItemParamString"/>&amp;LABEL=<xsl:value-of select="$menuItemTargetHistoryLabel"/>" + encodeURIComponent(opt.$trigger.attr("id")); }
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template mode="RenderEditorMenuItemFunction" match="node()">
		<!-- boolean as to whether a new window/tab should be opened -->
		
		<xsl:variable name="thisMenuItem" select="current()"/>
		<xsl:variable name="menuItemShortName" select="current()/own_slot_value[slot_reference = 'menu_item_short_name']/value"/>
		<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $urlNameSuffix)"/>
		<xsl:variable name="menuItemTargetEditorSection" select="$allTargetEditorSections[name = $thisMenuItem/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>
		<xsl:variable name="menuItemTargetEditorSectionId" select="$menuItemTargetEditorSection/own_slot_value[slot_reference = 'editor_section_anchor_id']/value"/>
		<xsl:variable name="menuItemTargetEditor" select="$allTargetEditors[name = ($menuItemTargetEditorSection, $thisMenuItem)/own_slot_value[slot_reference = ('editor_section_parent', 'report_menu_item_target_report')]/value]"/>
		<xsl:variable name="menuItemTargetHistoryLabel" select="$menuItemTargetEditor/own_slot_value[slot_reference = 'report_history_label']/value"/>
		<xsl:variable name="menuItemTargetReportType" select="$allMenuTargetReportTypes[name = $menuItemTargetEditor/own_slot_value[slot_reference = 'report_implementation_type']/value]"/>
		<xsl:variable name="menuItemTargetReportParameters" select="$allTargetReportParameters[name = $menuItemTargetEditor/own_slot_value[slot_reference = 'report_parameters']/value]"/>
		<!--<xsl:variable name="menuItemTargetReportParameterInstanceVals" select="$allTargetReportParameterInstanceVals[name = $menuItemTargetReportParameters/own_slot_value[slot_reference = 'report_parameter_instance_value']/value]"/>-->
		
		<xsl:variable name="menuItemParamString">
			<xsl:apply-templates mode="RenderNGMenuItemParameters" select="$menuItemTargetReportParameters"/>
		</xsl:variable>
		
		<xsl:variable name="pathPrefix">report</xsl:variable>
		
		<xsl:variable name="menuItemEditorXSLPath">
			<xsl:choose>
				<xsl:when test="$menuItemTargetEditor/type = 'Configured_Editor'"><xsl:value-of select="$configuredEditorXSLPath"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$editorXSLPath"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		function <xsl:value-of select="$menuItemFunctionName"/>(key,opt) { window.open("<xsl:value-of select="$pathPrefix"/>" + opt.$trigger.attr("href") + "&amp;XSL=<xsl:value-of select="$menuItemEditorXSLPath"/><xsl:value-of select="$menuItemParamString"/>&amp;LABEL=<xsl:value-of select="$menuItemTargetHistoryLabel"/>&amp;EDITOR=<xsl:value-of select="$menuItemTargetEditor/name"/>&amp;SECTION=<xsl:value-of select="$menuItemTargetEditorSectionId"/>", "_blank"); }
	</xsl:template>


	<xsl:template mode="RenderMenuGroupEntries" match="node()">
		<!--<xsl:variable name="menuGroupLabel" select="current()/own_slot_value[slot_reference = 'report_menu_group_label']/value"/>-->
		<xsl:variable name="thisGroupReportMenuItems" select="$allReportMenuItems[name = current()/own_slot_value[slot_reference = 'report_menu_items']/value]"/>

		<xsl:choose>
			<xsl:when test="count($thisGroupReportMenuItems) > 0">
				<xsl:if test="position() > 1">, "sep1": "---------"</xsl:if>
				<!--   title:	{type: "html", html: '<span class="uppercase fontBlack text-darkgrey"><xsl:value-of select="$menuGroupLabel"/></span>', icon: "none"},-->
				<xsl:apply-templates mode="RenderMenuItemEntries" select="$thisGroupReportMenuItems"/>
			</xsl:when>
			<xsl:otherwise><!--,title: {type: "html", html: '<span class="uppercase fontBlack menuTitle"><em>No view menu items defined</em></span>', icon: "none"} --></xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	
	<xsl:template mode="RenderMenuItemModalEntries" match="node()">
		<xsl:variable name="thisModal" select="current()"/>
		
		<!-- Check that user can accessmodal before rendering the menu item -->
		<xsl:if test="eas:isUserAuthZ($thisModal)">
			<xsl:variable name="menuItemShortName" select="$thisModal/own_slot_value[slot_reference = 'modal_report_js_name']/value"/>
			<xsl:variable name="menuItemLabel" select="$thisModal/own_slot_value[slot_reference = 'modal_report_menu_label']/value"/>
			<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $essModalFunctionSuffix)"/>
			<xsl:variable name="menuItemCategory" select="$allMenuItemCategories[name = $thisModal/own_slot_value[slot_reference = 'modal_report_menu_item_category']/value]"/>
			<xsl:variable name="menuItemIconName" select="$menuItemCategory/own_slot_value[slot_reference = 'enumeration_icon']/value"/>
			,<xsl:value-of select="$menuItemShortName"/>
: {disabled: function(){return (typeof essIdeas === 'undefined' || essIdeas === null || !essIdeas.ready);}, name: "<xsl:value-of select="$menuItemLabel"/>
", icon: "<xsl:value-of select="$menuItemIconName"/>
", callback: <xsl:value-of select="$menuItemFunctionName"/>
}<xsl:if test="not(position() = last())">,</xsl:if>
		</xsl:if>
		<!-- If not cleared, render nothing -->
	</xsl:template>
	

	<xsl:template mode="RenderMenuItemEntries" match="node()">

		<!-- Check that user can access target report before rendering the menu item -->
		<xsl:variable name="menuItemTargetReport" select="$allMenuItemTargets[name = current()/own_slot_value[slot_reference = 'report_menu_item_target_report']/value]"/>
		<xsl:variable name="isAuth" select="eas:isUserAuthZ($menuItemTargetReport)"/>
		<xsl:if test="$isAuth">
			<xsl:variable name="menuItemShortName" select="current()/own_slot_value[slot_reference = 'menu_item_short_name']/value"/>
			<xsl:variable name="menuItemLabel" select="current()/own_slot_value[slot_reference = 'menu_item_label']/value"/>
			<xsl:variable name="menuItemFunctionName" select="concat($menuItemShortName, $urlNameSuffix)"/>
			<xsl:variable name="menuItemCategory" select="$allMenuItemCategories[name = current()/own_slot_value[slot_reference = 'report_menu_item_category']/value]"/>
			<xsl:variable name="menuItemIconName" select="$menuItemCategory/own_slot_value[slot_reference = 'enumeration_icon']/value"/>
			,<xsl:value-of select="$menuItemShortName"/>: {name: "<xsl:value-of select="$menuItemLabel"/>", icon: "<xsl:value-of select="$menuItemIconName"/>", callback: <xsl:value-of select="$menuItemFunctionName"/>}
		</xsl:if>
		<!-- If not cleared, render nothing -->
	</xsl:template>
	
	
	<xsl:template mode="RenderNGMenuItemParameters" match="node()">
		
		<xsl:variable name="thisParam" select="current()"/>
		<xsl:variable name="thisParamName" select="$thisParam/own_slot_value[slot_reference = 'report_parameter_name']/value"/>

		<xsl:if test="string-length($thisParamName) > 0">
			<xsl:variable name="thisParamInstanceIds" select="$thisParam/own_slot_value[slot_reference = 'report_parameter_instance_value']/value"/>
			<xsl:choose>
				<xsl:when test="count($thisParamInstanceIds) > 0">&amp;<xsl:value-of select="$thisParamName"/>=<xsl:value-of select="$thisParamInstanceIds[1]"/></xsl:when>
				<xsl:otherwise>
					<xsl:variable name="thisParamInstanceStringVal" select="$thisParam/own_slot_value[slot_reference = 'report_parameter_string_value']/value"/>
					<xsl:if test="string-length($thisParamInstanceStringVal) > 0">&amp;<xsl:value-of select="$thisParamName"/>=<xsl:value-of select="$thisParamInstanceStringVal"/></xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
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

	<xsl:template name="RenderJSMenuLinkFunctions">
		<xsl:param name="linkClasses" select="()"/>
		const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
		var esslinkMenuNames = {
			<xsl:call-template name="RenderClassMenuDict">
				<xsl:with-param name="menuClasses" select="$linkClasses"/>
			</xsl:call-template>
		}
		
		function essGetMenuName(instance) {
			let menuName = null;
			if(instance.meta?.anchorClass) {
				menuName = esslinkMenuNames[instance.meta.anchorClass];
			} else if(instance.className) {
				menuName = esslinkMenuNames[instance.className];
			}
			return menuName;
		}
		
		Handlebars.registerHelper('essRenderInstanceMenuLink', function(instance){
			if(instance != null) {
				let linkMenuName = essGetMenuName(instance);
				let instanceLink = instance.name;
				if(linkMenuName) {
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
					
					<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
				}
				return instanceLink;
			} else {
				return '';
			}
		});
	</xsl:template>

	<xsl:template name="RenderClassMenuDict">
		<xsl:param name="menuClasses" select="()"/>
		<xsl:for-each select="$menuClasses">
			<xsl:variable name="this" select="."/>
			<xsl:variable name="thisMenus" select="$allMenus[own_slot_value[slot_reference = 'report_menu_class']/value = $this]"/>
			"<xsl:value-of select="$this"/>": <xsl:choose><xsl:when test="count($thisMenus) > 0">"<xsl:value-of select="$thisMenus[1]/own_slot_value[slot_reference = 'report_menu_short_name']/value"></xsl:value-of>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose><xsl:if test="not(position() = last())">,
			</xsl:if>
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
	
	<!-- function to test if a given version number is greater than, or equal to a second verson number -->
	<xsl:function name="eas:menuCompareVersionNumbers" as="xs:boolean">
		<xsl:param name="currentVersionNum"/>
		<xsl:param name="testVersionNum"/>
		
		<xsl:variable name="currVersionTokens" select="tokenize($currentVersionNum, '\.')"/>
		<xsl:variable name="testVersionTokens" select="tokenize($testVersionNum, '\.')"/>
		
		<xsl:variable name="compareList">
			<xsl:for-each select="$currVersionTokens">
				<xsl:variable name="tokenIndex" select="position()"/>
				<xsl:variable name="thisToken" select="."/>
				<xsl:variable name="testToken" select="$testVersionTokens[$tokenIndex]"/>
				<xsl:sequence select="number($thisToken) >= number($testToken)"/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:value-of select="not(contains($compareList, 'false'))"/>
		
	</xsl:function>


</xsl:stylesheet>
