<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:include href="../../common/core_roadmap_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
	<!--
		* Copyright © 2008-2019 Enterprise Architecture Solutions Limited.
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
	<!-- 03.09.2019 JP  Created	 -->
   
<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>    
<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
<xsl:key name="techOrgUser2RolesKey" match="$techOrgUser2Roles" use="name"/>
<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/>
<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>    
<xsl:variable name="allTechSuppliers" select="/node()/simple_instance[type='Supplier']"/>	
<xsl:key name="supplierKey" match="/node()/simple_instance[type='Supplier']" use="name"/>
<xsl:variable name="allTechComponents" select="/node()/simple_instance[type = ('Technology_Component','Technology_Composite')]"/>
<xsl:key name="allTechComponentsKey" match="/node()/simple_instance[type = ('Technology_Component','Technology_Composite')]" use="own_slot_value[slot_reference = 'realised_by_technology_products']/value"/>
 <xsl:key name="allTechProdRolesKey" match="/node()/simple_instance[supertype='Technology_Provider_Role']" use="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
<xsl:key name="techCapsKey" match="/node()/simple_instance[type='Technology_Capability']" use="own_slot_value[slot_reference = 'realised_by_technology_components']/value"/>
 <xsl:variable name="allStandardStrengths" select="/node()/simple_instance[type='Standard_Strength']"/>
<xsl:variable name="allStandardStyles" select="/node()/simple_instance[type='Element_Style'][name = $allStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>	
<xsl:key name="techProdStandardsKey" match="/node()/simple_instance[type='Technology_Provider_Standard_Specification']" use="own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value"/>
<xsl:key name="lifecycleModel" match="/node()/simple_instance[type='Vendor_Lifecycle_Model']" use="own_slot_value[slot_reference = 'lifecycle_model_subject']/value"/>
<xsl:key name="lifecycleModelStages" match="/node()/simple_instance[type='Vendor_Lifecycle_Status_Usage']" use="own_slot_value[slot_reference = 'used_in_lifecycle_model']/value"/>
<xsl:variable name="thisClass" select="/node()/class[name = ('Technology_Provider','Technology_Product', 'Technology_Composite')]" />

<xsl:variable name="thisSlots" select="/node()/slot[name = $thisClass/template_slot]" />
<xsl:variable name="parentEnumClass" select="/node()/class[superclass = 'Enumeration']" />
<xsl:variable name="subEnumClass" select="/node()/class[superclass = $parentEnumClass/name]" />
<xsl:variable name="enumClass" select="$parentEnumClass union $subEnumClass" />
<xsl:key name="allTechFamily" match="/node()/simple_instance[type='Technology_Product_Family']" use="own_slot_value[slot_reference='groups_technology_products']/value"/>
 
<xsl:variable name="targetSlots" select="$thisSlots/own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value[2]"/>
<xsl:variable name="allthisSlotsBoo" select="$thisSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value='Boolean']"/> 
<xsl:variable name="allthisSlots" select="$thisSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=$enumClass/name]"/> 

<xsl:variable name="allSlots" select="$thisSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value]"/> 
<xsl:variable name="allEnumClass" select="$enumClass[name=$targetSlots]"/> 
<xsl:variable name="alltargetClass" select="/node()/class[name=$targetSlots]"/> 
<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Technology_Product','Technology_Provider', 'Supplier')]"></xsl:variable>

    <!-- END ROADMAP VARIABLES -->
	
	
	<xsl:template match="knowledge_base">
		

		{	 	"meta":[<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>],
			"technology_products": [
        <xsl:apply-templates select="$allTechProds" mode="RenderTechProducts"/>
			], 
			"filters":[<xsl:apply-templates select="$allEnumClass" mode="createFilterJSON"></xsl:apply-templates><xsl:if test="$allthisSlotsBoo">,<xsl:apply-templates select="$allthisSlotsBoo" mode="createBooleanFilterJSON"></xsl:apply-templates></xsl:if>]	 
		}
	</xsl:template>
	
	<xsl:template mode="RenderTechProducts" match="node()">
		<xsl:variable name="thisTechProd" select="current()"/>
        <xsl:variable name="thisTechOrgUser2Roles2" select="$techOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		
		<xsl:variable name="thisTechOrgUser2Roles" select="key('techOrgUser2RolesKey', current()/own_slot_value[slot_reference = 'stakeholders']/value)"/>
		
		<xsl:variable name="thsTechUsers" select="$thisTechOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
		<xsl:variable name="theLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'vendor_product_lifecycle_status']/value]"/>
		<xsl:variable name="theDeliveryModel" select="$allTechProdDeliveryTypes[name = current()/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
		<xsl:variable name="theStatusScore" select="$theLifecycleStatus/own_slot_value[slot_reference = 'enumeration_score']/value"/>
		<!--	<xsl:variable name="thisTPR" select="$allTechProdRoles[name=current()/own_slot_value[slot_reference='implements_technology_components']/value]"/>-->
		<xsl:variable name="thisTPR" select="key('allTechProdRolesKey', current()/name)"/>
		<!--
	<xsl:variable name="thisTechComp" select="$allTechComponents[name=$thisTPR/own_slot_value[slot_reference='implementing_technology_component']/value]"/> -->
		<xsl:variable name="thisTechComp" select="key('allTechComponentsKey', $thisTPR/name)"/> 
 
		<!--<xsl:variable name="thisTechCap" select="$allTechCaps[name=$thisTechComp/own_slot_value[slot_reference='realisation_of_technology_capability']/value]"/> -->
		<xsl:variable name="thisTechCap" select="key('techCapsKey',$thisTechComp/name)"/> 
		 
		<xsl:variable name="thislifecycleModel" select="key('lifecycleModel', current()/name)"/>
		<xsl:variable name="thislifecycleModelStages" select="key('lifecycleModelStages', $thislifecycleModel/name)"/>
<xsl:variable name="thisFamilies" select="key('allTechFamily', current()/name)"/>
 		<xsl:variable name="theSupplier" select="key('supplierKey', current()/own_slot_value[slot_reference='supplier_technology_product']/value)"/>
	{  
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>", 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"supplierId":"<xsl:value-of select="eas:getSafeJSString($theSupplier/name)"/>",	
			"member_of_technology_product_families":[<xsl:for-each select="$thisFamilies">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>", 
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
			"vendor_lifecycle":[<xsl:for-each select="$thislifecycleModelStages"><xsl:variable name="thisLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'lcm_lifecycle_status']/value]"/>{"id":"<xsl:value-of select="current()/name"/>", "start_date":"<xsl:value-of select="current()/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>", "status":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$thisLifecycleStatus"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>","statusId":"<xsl:value-of select="eas:getSafeJSString($thisLifecycleStatus/name)"/>","order":"<xsl:value-of select="$thisLifecycleStatus/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>"}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"caps":[<xsl:for-each select="$thisTechCap">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>", 
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
		 	"comp":[
			<xsl:for-each select="$thisTPR[own_slot_value[slot_reference = 'implementing_technology_component']/value]">
				<!--<xsl:variable name="thisTechProdStandards" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = current()/name]"/>-->
				<xsl:variable name="thisTechProdStandards" select="key('techProdStandardsKey', current()/name)"/>
				<xsl:variable name="thisStandardStrengths" select="$allStandardStrengths[name = $thisTechProdStandards/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
				<xsl:variable name="thisStandardStyles" select="$allStandardStyles[name = $thisStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
			<!--	<xsl:variable name="thisTechComp" select="$allTechComponents[name=current()/own_slot_value[slot_reference='implementing_technology_component']/value]"/> -->
				<xsl:variable name="thisTechComp" select="key('allTechComponentsKey', current()/name)"/> 
	 
				 <xsl:for-each select="$thisTechComp[name]">
				{ 
				"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isForJSONAPI" select="true()"/>
					</xsl:call-template>", 
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","std":"<xsl:choose><xsl:when test="$thisStandardStrengths"><xsl:value-of select="$thisStandardStrengths/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>No Standard Defined</xsl:otherwise></xsl:choose>","stdStyle":"<xsl:value-of select="$thisStandardStyles/own_slot_value[slot_reference = 'element_style_class']/value"/>",
				"stdColour":"<xsl:value-of select="$thisStandardStyles/own_slot_value[slot_reference = 'element_style_colour']/value"/>",
				"stdTextColour":"<xsl:value-of select="$thisStandardStyles/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>], 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
					'supplier': string(translate(translate($theSupplier/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"status": "<xsl:value-of select="translate($theLifecycleStatus/name, '.', '_')"/>",
	 	"lifecycleStatus": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$theLifecycleStatus"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"statusScore": <xsl:choose><xsl:when test="$theStatusScore > 0"><xsl:value-of select="$theStatusScore"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
		"ea_reference":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ea_reference']/value"/>",
		"delivery": "<xsl:value-of select="translate($theDeliveryModel/name, '.', '_')"/>",
		"techOrgUsers": [<xsl:for-each select="$thsTechUsers">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
		"orgUserIds": [<xsl:for-each select="$thisTechOrgUser2Roles">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], 
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],		
		<xsl:for-each select="$allSlots"><xsl:variable name="slt" select="current()/name"/>"<xsl:value-of select="$slt"/>":[<xsl:for-each select="$thisTechProd/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], </xsl:for-each>
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="not(position()=last())">,
	</xsl:if>
	</xsl:template>
	<xsl:template mode="createFilterJSON" match="node()">	
		<xsl:variable name="thisSlot" select="$thisSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
		<xsl:variable name="releventEnums" select="/node()/simple_instance[type = current()/name]"/> 
		{"id": "<xsl:value-of select="current()/name"/>",
		"name": "<xsl:value-of select="translate(current()/name, '_',' ')"/>",
		"valueClass": "<xsl:value-of select="current()/name"/>",
		"description": "",
		"slotName":"<xsl:value-of select="$thisSlot/name"/>",
		"isGroup": false,
		"icon": "fa-circle",
		"color":"#93592f",
		"values": [
		<xsl:for-each select="$releventEnums"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isForJSONAPI" select="true()"></xsl:with-param>
		</xsl:call-template>",
		"enum_name":"<xsl:call-template name="RenderMultiLangInstanceSlot">
		<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
		<xsl:with-param name="displaySlot" select="'enumeration_value'"/>
		<xsl:with-param name="isForJSONAPI" select="true()"></xsl:with-param>
		</xsl:call-template>",
		"sequence":"<xsl:value-of select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
		"backgroundColor":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
		"colour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>"}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]
		<!--,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>-->
	}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:template>	
<xsl:template mode="createBooleanFilterJSON" match="node()">	
		<xsl:variable name="thisSlot" select="$thisSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
		<xsl:variable name="releventEnums" select="/node()/simple_instance[type = current()/name]"/> 
		{"id": "<xsl:value-of select="current()/name"/>",
		"name": "<xsl:value-of select="translate(current()/name, '_',' ')"/>",
		"valueClass": "<xsl:value-of select="current()/name"/>",
		"description": "",
		"slotName":"<xsl:value-of select="current()/name"/>",
		"isGroup": false,
		"icon": "fa-circle",
		"color":"#93592f",
		"values": [{"id":"none", "name":"Not Set"},{"id":"true", "name":"True"},{"id":"false", "name":"False"} ]}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>			
		
<xsl:template match="node()" mode="classMetaData"> 
	<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
	{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>
</xsl:stylesheet>
