<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Capability', 'Application_Service', 'Application_Provider', 'Technology_Capability', 'Technology_Component')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Application Organisation User')]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
	

	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>

	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Composite_Application_Provider','Application_Provider')]"/>
	<xsl:variable name="allAppCodebases" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
	<xsl:variable name="allAppDeliveryModels" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = $allApps/name]"/>
	
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
	
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
	
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[name = $allTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	
	<!--<xsl:variable name="techProdDeliveryTaxonomy" select="/node()/simple_instance[(type='Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Technology Product Delivery Types')]"/>-->
	<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[name = $allTechProds/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
	
	<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
	<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
	
	<xsl:variable name="allBusinessUnits" select="/node()/simple_instance[name = ($appOrgUser2Roles, $techOrgUser2Roles)/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allBusinessUnitOffices" select="/node()/simple_instance[name = $allBusinessUnits/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeGeoRegions" select="/node()/simple_instance[name = $allBusinessUnitOffices/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeLocations" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
	<xsl:variable name="allBusinessUnitLocationCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_locations']/value = $allBusinessUnitOfficeLocations/name]"/>
	<xsl:variable name="allBusinessUnitOfficeCountries" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
	<xsl:variable name="allBusinessUnitCountries" select="$allBusinessUnitLocationCountries union $allBusinessUnitOfficeCountries"/>
		<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="L1BusCaps" select="$allBusCaps[name = $L0BusCaps/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
    <xsl:variable name="allCaptoParent" select="/node()/simple_instance[type='BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
    <xsl:variable name="posnCap" select="$allCaptoParent[own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value=$allBusCaps/name]"/>
    <xsl:variable name="busCapRole" select="/node()/simple_instance[type='Business_Capability_Role']"/>
       <xsl:variable name="vendorLifecycle" select="/node()/simple_instance[type='Vendor_Lifecycle_Status']"/>
    <xsl:variable name="lifecycleStatusVals" select="/node()/simple_instance[type='Lifecycle_Status']"/>
     <xsl:variable name="codebaseStatus" select="/node()/simple_instance[type='Codebase_Status']"/>
     <xsl:variable name="appDeliveryStatus" select="/node()/simple_instance[type='Application_Delivery_Model']"/>
        <xsl:variable name="techDeliveryStatus" select="/node()/simple_instance[type='Technology_Delivery_Model']"/>
       <xsl:variable name="lifecycleColour" select="/node()/simple_instance[type='Element_Style']"/>
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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>IT Asset Dashboard</title>
	
			
				<style>
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
					}
					
					h2:hover{
						cursor: pointer;
					}
					
					.map{
						width: 100%;
						height: 250px;
					}
					
					.popover{
						max-width: 800px;
					}
				</style>
				
		 
				
	
				<!--Ends-->
			</head>
<body>
    <!-- ADD THE PAGE HEADING -->
    <xsl:call-template name="Heading"/>

<!--ADD THE CONTENT-->
<div class="container-fluid">
    <div class="row">
        <div class="col-xs-12">
            <div class="page-header">
                <h1>
                    <span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
                    <span class="text-darkgrey">IT Asset Dashboard Checker</span>
                </h1>
            </div>
        </div>
        <div class="col-xs-12">

<div class="col-xs-4">
    <h3> Foundation Data</h3>
    <table>
        <xsl:variable name="data1">
            <xsl:choose>
                <xsl:when test="count($allBusCaps) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Business Capabilities</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$data1}"><xsl:value-of select="count($allBusCaps)"/></span> <br/><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#5093fd">L1:<xsl:value-of select="count($L0BusCaps)" /></span><xsl:text> </xsl:text><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#5093fd">L2:<xsl:value-of select="count($L1BusCaps)" /></span>
            </td>
        </tr>
         <xsl:variable name="L1toAC">
            <xsl:choose>
                <xsl:when test="count($L1BusCaps[name=$allAppCaps/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Business Capabilities to Application Capabilities @ Level 1</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$L1toAC}"><xsl:value-of select="count($L1BusCaps[name=$allAppCaps/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value])" /></span>  
                
            </td>
        </tr>
        <xsl:variable name="data2">
            <xsl:choose>
                <xsl:when test="count($allAppCaps) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Application Capabilities</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$data2}"><xsl:value-of select="count($allAppCaps)"/></span></td>
        </tr>
        <xsl:variable name="data3">
            <xsl:choose>
                <xsl:when test="count($allTechCaps) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Technology Capabilities</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$data3}"><xsl:value-of select="count($allTechCaps)"/></span></td>
        </tr>
        <xsl:variable name="data7">
            <xsl:choose>
                <xsl:when test="count($allApps) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Applications</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$data7}"><xsl:value-of select="count($allApps)"/></span></td>
        </tr>
        <xsl:variable name="data4">
            <xsl:choose>
                <xsl:when test="count($allAppServices) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Application Services</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$data4}"><xsl:value-of select="count($allAppServices)"/></span></td>
        </tr>


        <xsl:variable name="apr">
            <xsl:choose>
                <xsl:when test="count($allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $allAppServices/name]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Application Services tied to Application Provider Roles</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$apr}"><xsl:value-of select="count($allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $allAppServices/name])"/></span></td>
        </tr>
        <xsl:variable name="apr2a">
            <xsl:choose>
                <xsl:when test="count($allApps[name = $allAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Application tied to Application Provider Roles</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$apr2a}"><xsl:value-of select="count($allApps[name = $allAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value])"/></span></td>
        </tr>


        <xsl:variable name="data5">
            <xsl:choose>
                <xsl:when test="count($allTechComps) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Technology Components</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$data5}"><xsl:value-of select="count($allTechComps)"/></span></td>
        </tr>

        <xsl:variable name="data6">
            <xsl:choose>
                <xsl:when test="count($allTechProds) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Technology Products</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$data6}"><xsl:value-of select="count($allTechProds)"/></span></td>
        </tr>
        <xsl:variable name="tdm">
            <xsl:choose>
                <xsl:when test="$techDeliveryStatus">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Technology Delivery Model</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$tdm}"><xsl:if test="$tdm='#ef9090'">No </xsl:if>EUP Installed</span></td>
        </tr>
    </table>
</div>
<div class="col-xs-4">
    <h3> Relations</h3>
    <table>
        <xsl:variable name="rc">
            <xsl:choose>
                <xsl:when test="/node()/simple_instance[type='Report_Constant'][own_slot_value[slot_reference='report_constant_ea_elements']/value=$allBusCaps/name]">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Root Capability Set</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$rc}"><i class="fa fa-crosshairs"></i>  </span><i class="fa fa-question-circle" onclick="$('#root').show()"></i></td>
        </tr>
        <tr style="display:none;border:1pt solid #d3d3d3" id="root">
            <td colspan="2">You need to create a root node for your Capability Model.  Go to EASupport > Essential Viewer > Report Configuration > Report Constant and set the 'Root Business Capability' Associated Instances slot to the Level 0 capability, which is the foundation for your capabilities hierarchy. You will need to tie capabilities to this root capability <i class="fa fa-close" onclick="$('#root').hide()"></i></td>        
        </tr>
    <xsl:variable name="repConst" select="/node()/simple_instance[type='Report_Constant'][own_slot_value[slot_reference='name']/value='Root Business Capability']"/>    
    <xsl:variable name="myroot" select="$allBusCaps[name=$repConst/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>    
       <xsl:variable name="rcc">
            <xsl:choose>
                <xsl:when test="count($myroot/own_slot_value[slot_reference='contained_business_capabilities']/value) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr><td>Number of Business Capabilities root is tied to</td><td><span class="badge badge-primary badge-pill" style="background-color:{$rcc}"><xsl:value-of select="count($myroot/own_slot_value[slot_reference='contained_business_capabilities']/value)"/></span></td></tr>
        
        
        <xsl:variable name="ind0">
            <xsl:choose>
                <xsl:when test="count($appOrgUser2Roles) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Application Organisation User is Set</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind0}"><xsl:value-of select="count($appOrgUser2Roles)"/></span></td>
        </tr>
        <xsl:variable name="ind1">
            <xsl:choose>
                <xsl:when test="count($allApps[own_slot_value[slot_reference = 'stakeholders']/value = $appOrgUser2Roles/name]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Users are associated with Applications</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind1}"><xsl:value-of select="count($allApps[own_slot_value[slot_reference = 'stakeholders']/value = $appOrgUser2Roles/name])"/></span></td>
        </tr>
        <xsl:variable name="ind2">
            <xsl:choose>
                <xsl:when test="count($allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $allAppCaps/name]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr>
            <td>Application Services mapped to Application Capabilities</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind2}"><xsl:value-of select="count($allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $allAppCaps/name])"/></span></td>
        </tr>
        <xsl:variable name="ind3">
            <xsl:choose>
                <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'app_cap_supports_bus_cap']/value = $allBusCaps/name]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Application Capabilities mapped to Business Capabilities</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind3}"><xsl:value-of select="count($allAppCaps[own_slot_value[slot_reference = 'app_cap_supports_bus_cap']/value = $allBusCaps/name])"/></span></td>
        </tr>
        <xsl:variable name="appStat">
            <xsl:choose>
                <xsl:when test="count($allApps[own_slot_value[slot_reference = 'ap_delivery_model']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Applications assigned Delivery Model</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$appStat}"><xsl:value-of select="count($allApps[own_slot_value[slot_reference = 'ap_delivery_model']/value])"/></span></td>
        </tr>
        <xsl:variable name="appLife">
            <xsl:choose>
                <xsl:when test="count($allApps[own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Applications assigned Lifecycle</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$appLife}"><xsl:value-of select="count($allApps[own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value])"/></span></td>
        </tr>

        <xsl:variable name="ind4">
            <xsl:choose>
                <xsl:when test="count($techOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $allBusinessUnits/name]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr>
            <td>Users Associated with Technology</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind4}"><xsl:value-of select="count($techOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $allBusinessUnits/name])"/></span></td>
        </tr>
        <xsl:variable name="ind5">
            <xsl:choose>
                <xsl:when test="count($allTechCaps[name = $allTechComps/own_slot_value[slot_reference = 'realisation_of_technology_capability']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr>
            <td>Technology Capabilities mapped to Technology Components</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind5}"><xsl:value-of select="count($allTechCaps[name = $allTechComps/own_slot_value[slot_reference = 'realisation_of_technology_capability']/value])"/></span></td>
        </tr>
        <xsl:variable name="ind6">
            <xsl:choose>
                <xsl:when test="count($allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Technology Products mapped to Technology Components</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind6}"><xsl:value-of select="count($allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name])"/></span></td>
        </tr>
        <xsl:variable name="techStat">
            <xsl:choose>
                <xsl:when test="count($allTechProds[own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Technology Products assigned Delivery Model</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind6}"><xsl:value-of select="count($allTechProds[own_slot_value[slot_reference = 'technology_provider_delivery_model']/value])"/></span></td>
        </tr>
        <xsl:variable name="techStat">
            <xsl:choose>
                <xsl:when test="count($allTechProds[own_slot_value[slot_reference = 'vendor_product_lifecycle_status']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Technology Products assigned Vendor Lifecycle</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$ind6}"><xsl:value-of select="count($allTechProds[own_slot_value[slot_reference = 'vendor_product_lifecycle_status']/value])"/></span></td>
        </tr>
        <xsl:variable name="sites">
            <xsl:choose>
                <xsl:when test="count($allGroupActors[own_slot_value[slot_reference = 'actor_based_at_site']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Sites Set</td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$sites}"><xsl:value-of select="count($allGroupActors[own_slot_value[slot_reference = 'actor_based_at_site']/value])"/></span></td>
        </tr>
        <xsl:variable name="legacyScore">
            <xsl:choose>
                <xsl:when test="count($vendorLifecycle[own_slot_value[slot_reference = 'enumeration_score']/value]) &gt; 0">#3cad3c</xsl:when>
                <xsl:otherwise>#ef9090</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <td>Vendor Lifecycle Scores Set (1-end of life, 10 - GA)  <i class="fa fa-question-circle" onclick="$('#vendlifeh2').show()"></i></td>
            <td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:{$legacyScore}"><xsl:value-of select="count($vendorLifecycle[own_slot_value[slot_reference = 'enumeration_score']/value])"/></span></td>
        </tr>
         <tr style="display:none;border:1pt solid #d3d3d3" id="vendlifeh2">
            <td colspan="2">The Launchpad load via the import utility can add these or you can add these manually against the Vendor_Lifecycle_Status. Go to EA Support > Utilities > Enumeration>Lifecycle_Status and you’ll see a Relative Score field, this needs setting to 1 for Out of Support and 10 for General Availability, the rest must be numbers in between.  <i class="fa fa-close" onclick="$('#vendlifeh2').hide()"></i></td>        
        </tr>

    </table>
</div>
<div class="col-xs-4">
    <h3> Formatting</h3>
    <table>
        <tr>
            <td colspan="2" style="background-color:#d3d3d3">Business Capability Model  <i class="fa fa-question-circle" onclick="$('#buscaph2').show()"></i></td>
        </tr>    
         <tr style="display:none;border:1pt solid #d3d3d3" id="buscaph2">
            <td colspan="2">You need to associate your Business Capabilities with a position.  The spreadsheet upload will do this or to do this manually, against each Level 1 Business Capability, look for the ‘Roles within Parent Business Capabilities’ slot and associate it with the parent (the root). In this form make the role Front, Manage or Back.  You only need this for the top level capabilities  <i class="fa fa-close" onclick="$('#buscaph2').hide()"></i></td>        
        </tr>
        <tr>
            <td>Business Capabilities tied to Front</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Front']/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Front']/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ffffff"><xsl:value-of select="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Front']/name])"/></span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Business Capabilities tied to Manage</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Manage']/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Manage']/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ffffff"><xsl:value-of select="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Manage']/name])"/></span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Business Capabilities tied to Back</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Back']/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Back']/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ffffff"><xsl:value-of select="count($posnCap[own_slot_value[slot_reference='buscap_to_parent_role']/value=$busCapRole[own_slot_value[slot_reference='name']/value='Back']/name])"/></span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td colspan="2"  style="background-color:#d3d3d3">Application Capability Model <i class="fa fa-question-circle" onclick="$('#appcaph2').show()"></i></td>
        </tr>
         <tr style="display:none;border:1pt solid #d3d3d3" id="appcaph2">
            <td colspan="2">You need to associate your Application Capabilities with a position.  The spreadsheet upload will do this or to do this manually, under EA Support>Taxonomy_Management, look for the ‘Reference Model Layout: {position}’ taxonomy terms and in the Classify Elements slot add the Application Capabilities for each position <i class="fa fa-close" onclick="$('#appcaph2').hide()"></i></td>        
        </tr>
        <tr>
            <td>Application Capabilities tied to Top</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#3cad3c"><xsl:value-of select="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
       
        <tr>
            <td>Application Capabilities tied to Left</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name])"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Application Capabilities tied to Middle</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <td colspan="2"  style="background-color:#d3d3d3">Technology Reference Model <i class="fa fa-question-circle" onclick="$('#techrefh2').show()"></i></td>
        <tr style="display:none;border:1pt solid #d3d3d3" id="techrefh2">
            <td colspan="2">You need to associate your Technology Domains with a position.  The spreadsheet upload will do this or to do this manually, under EA Support>Taxonomy_Management, look for the ‘Reference Model Layout: {position}’ taxonomy terms and in the Classify Elements slot add the Technology Domains for each position <i class="fa fa-close" onclick="$('#techrefh2').hide()"></i></td>        
        </tr>
        <tr>
            <td>Technology Domains tied to Right</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Technology Domains tied to Top</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Technology Domains tied to Left</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Technology Domains tied to Middle</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Technology Domains tied to Right</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Technology Domains tied to Bottom</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name])&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#ffffff"><xsl:value-of select="count($allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name])"/></span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">0</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <tr>
            <td>Layer Taxonomy Set</td>
            <td>
                <xsl:choose>
                    <xsl:when test="count($refLayerTaxonomy)&gt;0"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#3cad3c;color:#3cad3c">Y</span></xsl:when>
                    <xsl:otherwise><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">N</span></xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </table>
</div>
<div class="col-xs-3"></div>
<div class="col-xs-12">

    <hr/>
    <h5> The view requires valid colours to be set against the Element Style Class used in the Element Style Classes slot <i class="fa fa-question-circle" onclick="$('#colors').show()"></i><br/><span style="font-size:8pt">
                                <span class="badge badge-primary badge-pill badge-xs" style="cursor:pointer;background-color:#3cad3c;color:#3cad3c">.</span> Valid colour setting <span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">.</span> Colour setting is not a HEX value, e.g. #d3d3d3t</span>
    </h5>
    <span id="colors" style="display:none">If you import the last four worksheets in the launchpad worksheet using the import utility, that will fix your colours.  Alternatively, manually, under EA Support > Utilities > Enumeration> and against the various Lifecycle_Status, Codebase Status, Application_Delivery_Model and Technology_Delivery_Model you can set a style for each under Element Styling Classes (look under the System tab), add a new one, or edit the exisiting and it is the Element Style Colour slot that needs a HEX color in it. <i class="fa fa-close" onclick="$('#colors').hide()"></i></span>
</div>
<div class="col-xs-12">
    <hr/>
    <div class="col-xs-2">
        <table>
            <tr>
                <td valign="top">Vendor Styling</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table style="font-size:8pt">
                        <xsl:apply-templates select="$vendorLifecycle" mode="colours"></xsl:apply-templates>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div class="col-xs-3">
        <table>
            <tr>
                <td valign="top">Codebase Styling</td>
            </tr>

            <tr>
                <td colspan="2">
                    <table style="font-size:8pt">
                        <xsl:apply-templates select="$codebaseStatus" mode="colours"></xsl:apply-templates>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div class="col-xs-2">
        <table>
            <tr>
                <td valign="top">Lifecycle Styling</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table style="font-size:8pt">
                        <xsl:apply-templates select="$lifecycleStatusVals" mode="colours"></xsl:apply-templates>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div class="col-xs-2">
        <table>
            <tr>
                <td valign="top">Application Delivery Styling</td>
            </tr>

            <tr>
                <td colspan="2">
                    <table style="font-size:8pt">
                        <xsl:apply-templates select="$appDeliveryStatus" mode="colours"></xsl:apply-templates>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div class="col-xs-3">
        <table>
            <tr>
                <td valign="top">Technology Delivery Styling</td>
            </tr>

            <tr>
                <td colspan="2">
                    <table style="font-size:8pt">
                        <xsl:apply-templates select="$techDeliveryStatus" mode="colours"></xsl:apply-templates>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</div>
</div>
</div>
</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					$(document).ready(function(){
						$('.match1').matchHeight();
						
						$('.fa-info-circle').click(function() {
							$('[role="tooltip"]').remove();
							return false;
						});
						$('.fa-info-circle').popover({
							container: 'body',
							html: true,
							trigger: 'click',
							content: function(){
								return $(this).next().html();
							}
						});
						
					});
				</script>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="colours">
        <xsl:variable name="ls" select="current()"/>
        <xsl:variable name="this" select="$lifecycleColour[own_slot_value[slot_reference='style_for_elements']/value=$ls/name]"/>
        <tr><td width="50%"> <xsl:value-of select="$ls/own_slot_value[slot_reference='name']/value"/></td><td><xsl:choose><xsl:when test="not(contains($this/own_slot_value[slot_reference='element_style_colour']/value,'#'))"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">.</span></xsl:when><xsl:when test="not($this)"><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#ef9090;color:#ef9090">.</span></xsl:when><xsl:otherwise><span class="badge badge-primary badge-pill" style="font-size:8pt;cursor:pointer;background-color:#3cad3c;color:#3cad3c">.</span></xsl:otherwise></xsl:choose></td></tr>
     
    </xsl:template>    



</xsl:stylesheet>
