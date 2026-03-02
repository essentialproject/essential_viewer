<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:err="http://www.w3.org/2005/xqt-errors">
<xsl:strip-space elements="*"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<xsl:param name="includeSuppliers" as="xs:boolean" select="true()"/>
	<xsl:param name="includeOutlook"   as="xs:boolean" select="false()"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Composite_Application_Provider', 'Application_Provider', 'Technology_Product', 'Business_Process')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="archivedStatus" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'SYS_CONTENT_ARCHIVED']"/>

	<xsl:variable name="organisationITUsers" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference = 'name']/value = ('Application Organisation User','Application User') or own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User']"/>
	<xsl:variable name="allActorNames" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allTechnologyProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $allActorNames/name]"/>
	<xsl:variable name="actorPlayingRole" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_to_role']/value = $organisationITUsers/name]"/>
	
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:key name="allBusProcs" match="/node()/simple_instance[type = 'Business_Process']" use="type"/>
<!--	
	<xsl:variable name="technologyProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
-->
	<xsl:key name="technologyProducts" match="/node()/simple_instance[type = ('Technology_Product')]" use="type"/>
	<xsl:variable name="tprsForTechnologyProducts" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
	<xsl:variable name="technologyComponents" select="/node()/simple_instance[type = 'Technology_Component'][own_slot_value[slot_reference = 'realised_by_technology_products']/value = $tprsForTechnologyProducts/name]"/>
	<!--
	<xsl:variable name="applications" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	-->
	<xsl:key name="applications" match="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]" use="type"/>

	<xsl:variable name="applications"
  select="if ($includeSuppliers)
          then /node()/simple_instance[type='Composite_Application_Provider']
          else ()"/>

<xsl:variable name="technologyProducts"
  select="if ($includeSuppliers or $includeOutlook)
          then /node()/simple_instance[type='Technology_Product']
          else ()"/>


	<xsl:key name="allBusProcsSupplier_key" match="/node()/simple_instance[type = 'Business_Process']" use="own_slot_value[slot_reference = 'business_process_supplier']/value"/>
	<xsl:key name="allAppsSupplier_key" match="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'ap_supplier']/value"/>
	<xsl:key name="alltechSupplier_key" match="/node()/simple_instance[type = 'Technology_Product']" use="own_slot_value[slot_reference = 'supplier_technology_product']/value"/>
	<xsl:key name="allExternalLink_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/>
	<!--
    <xsl:variable name="aprs" select="/node()/simple_instance[type = 'Application_Provider_Role'][own_slot_value[slot_reference = 'role_for_application_provider']/value = $applications/name]"/>
    <xsl:variable name="services" select="/node()/simple_instance[type = ('Application_Service','Composite_Application_Service')][own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $aprs/name]"/>-->
	<xsl:key name="allSuppliers" match="/node()/simple_instance[type = ('Supplier')]" use="name"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[(type = 'Supplier') and not(own_slot_value[slot_reference = 'system_content_lifecycle_status']/value = $archivedStatus/name)]"/>
	<xsl:variable name="appSupplierNames" select="distinct-values($applications/own_slot_value[slot_reference='ap_supplier']/value)"/>
	<xsl:variable name="techSupplierNames" select="distinct-values($technologyProducts/own_slot_value[slot_reference='supplier_technology_product']/value)"/>
	<xsl:variable name="supplier" select="(key('allSuppliers', $appSupplierNames), key('allSuppliers', $techSupplierNames))[not(own_slot_value[slot_reference = 'system_content_lifecycle_status']/value = $archivedStatus/name)]"/>
	<xsl:variable name="supplierRelStatii" select="key('supplierRelStatii', $allSuppliers/own_slot_value[slot_reference='supplier_relationship_status']/value)"/>
	<xsl:key name="supplierRelStatii_key" match="/node()/simple_instance[type='Supplier_Relationship_Status']" use="type"/>
<!--	<xsl:variable name="supplierContracts" select="/node()/simple_instance[type = 'OBLIGATION_COMPONENT_RELATION']"/>[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $technologyProducts/name or own_slot_value[slot_reference = 'obligation_component_to_element']/value = $applications/name]-->
	
	<xsl:key name="kByType" match="/node()/simple_instance" use="type"/>
	<xsl:variable name="allContracts" select="/node()/simple_instance[(type='Contract')  and not(own_slot_value[slot_reference = 'system_content_lifecycle_status']/value = $archivedStatus/name)]"/>
	<xsl:key name="allContracts_type" match="/node()/simple_instance[(type='Contract')]" use="type"/>
	<xsl:key name="allContractsKey" match="/node()/simple_instance[(type='Contract')]" use="own_slot_value[slot_reference = 'contract_supplier']/value"/>
	<xsl:key name="allContractsforKey" match="/node()/simple_instance[(type='Contract')]" use="own_slot_value[slot_reference = 'contract_for']/value"/>

	<xsl:variable name="allContractSuppliers" select="key('allSuppliers', $allContracts/own_slot_value[slot_reference = 'contract_supplier']/value)"/>
	<xsl:variable name="allContractLinks" select="key('allExternalLink_key', $allContracts/own_slot_value[slot_reference = 'external_reference_links']/value)"/>

	<xsl:variable name="allContractToElementRels" select="key('ccrfromContract_Key', $allContracts/name)"/>
	<xsl:key name="ccr_Key" match="simple_instance[(type='CONTRACT_COMPONENT_RELATION')]" use="own_slot_value[slot_reference = 'contract_component_to_element']/value"/>
	<xsl:key name="ccrfromContract_Key" match="simple_instance[(type='CONTRACT_COMPONENT_RELATION')]" use="own_slot_value[slot_reference = 'contract_component_from_contract']/value"/>

 	<xsl:key name="supplierRelStatii" match="simple_instance[type='Supplier_Relationship_Status']" use="name"/>
	 <xsl:key name="licenceKey" match="simple_instance[type='License']" use="name"/>
	<xsl:variable name="allLicenses" select="/node()/simple_instance[name = $allContractToElementRels/own_slot_value[slot_reference = 'ccr_license']/value]"/> 
	<xsl:key name="allRenewalModels" match="/node()/simple_instance[type='Contract_Renewal_Model']" use="name"/> 
	<xsl:key name="allContractTypes" match="/node()/simple_instance[type='Contract_Type']" use="name"/>
	<xsl:key name="allContractTypes_key" match="/node()/simple_instance[type='Contract_Type']" use="type"/>
	<xsl:variable name="currencyRC" select="/node()/simple_instance[type='Report_Constant'][own_slot_value[slot_reference='name']/value='Default Currency']"/>
	<xsl:variable name="allCurrencies" select="/node()/simple_instance[type='Currency']"/>
	<xsl:key name="allCurrencies" match="simple_instance[type='Currency']" use="name"/>
	<xsl:variable name="defCurrency" select="$allCurrencies[own_slot_value[slot_reference='currency_is_default']/value = 'true']"/>
	<xsl:variable name="currency" select="key('allCurrencies', $currencyRC/own_slot_value[slot_reference='report_constant_ea_elements']/value)"/>
	
	<xsl:variable name="baseCurrency"
	select="
		if ($defCurrency)
		then $defCurrency[1]
		else if ($currency)
		then $currency[1]
		else key('allCurrencies', (key('allCurrencies', *)/name)[1])[1]
	"/>
	<xsl:variable name="baseCurrencySymbol" select="$baseCurrency/own_slot_value[slot_reference = 'currency_symbol']/value"/>
	<xsl:variable name="baseCurrencyCode" select="$baseCurrency/own_slot_value[slot_reference = 'currency_code']/value"/>
	<xsl:variable name="baseCurrencyExchangeRate" select="if (string-length($baseCurrency/own_slot_value[slot_reference = 'currency_exchange_rate']/value) > 0) then $baseCurrency/own_slot_value[slot_reference = 'currency_exchange_rate']/value else '1'"/>
	<xsl:variable name="baseCurrencyName">
		<xsl:choose>
			<xsl:when test="$baseCurrency">
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$baseCurrency"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="contractedBusProcs" select="key('allBusProcs','Business_Process')"/>
	<xsl:variable name="contractedApps" select="key('applications',('Application_Provider', 'Composite_Application_Provider'))"/>
	<xsl:variable name="contractedTechProds" select="key('technologyProducts','Technology_Product')"/>
	
	<xsl:variable name="allSolutionProviders" select="key('allSuppliers', ($allBusProcs, $applications, $technologyProducts)/own_slot_value[slot_reference = ('business_process_supplier', 'ap_supplier', 'supplier_technology_product')]/value)"></xsl:variable>

	<!-- Sorted helper variables -->
	<xsl:variable name="allSolutionProvidersSorted" as="element(simple_instance)*">
	  <xsl:perform-sort select="$allSolutionProviders">
	    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
	  </xsl:perform-sort>
	</xsl:variable>

	<xsl:variable name="allContractSuppliersSorted" as="element(simple_instance)*">
	  <xsl:perform-sort select="$allContractSuppliers">
	    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
	  </xsl:perform-sort>
	</xsl:variable>

	<xsl:variable name="busProcessesSorted" as="element(simple_instance)*">
	  <xsl:perform-sort select="key('allBusProcs', 'Business_Process')">
	    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
	  </xsl:perform-sort>
	</xsl:variable>

	<xsl:variable name="applicationsSorted" as="element(simple_instance)*">
	  <xsl:perform-sort select="key('applications', ('Application_Provider','Composite_Application_Provider'))">
	    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
	  </xsl:perform-sort>
	</xsl:variable>

	<xsl:variable name="techProductsSorted" as="element(simple_instance)*">
	  <xsl:perform-sort select="key('technologyProducts', 'Technology_Product')">
	    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
	  </xsl:perform-sort>
	</xsl:variable>

	<xsl:key name="allContractsBySupplier"
         match="/node()/simple_instance[type='Contract']"
         use="own_slot_value[slot_reference='contract_supplier']/value"/>

	
	<!--<xsl:variable name="alllicenses" select="/node()/simple_instance[type = 'License']"/>
	<xsl:variable name="contracts" select="/node()/simple_instance[type = 'Compliance_Obligation'][own_slot_value[slot_reference = 'compliance_obligation_licenses']/value = $alllicenses/name]"/>
    
	<xsl:variable name="licenses" select="/node()/simple_instance[type = 'License'][name = $contracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
	<xsl:variable name="actualContracts" select="/node()/simple_instance[type = 'Contract'][own_slot_value[slot_reference = 'contract_uses_license']/value = $licenses/name]"/>-->
	<xsl:variable name="licenseType" select="/node()/simple_instance[type = 'License_Type']"/>
	<xsl:key name="licenseTypekey" match="/node()/simple_instance[type = 'License_Type']" use="name"/>
	
	
	<xsl:variable name="viewerPrimaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'primary_header_colour_viewer']/value"/>
	<xsl:variable name="viewerSecondaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'secondary_header_colour_viewer']/value"/>
	<xsl:variable name="vIcon" select="$activeViewerStyle/own_slot_value[slot_reference = 'viewer_icon_colour']/value"/>
	
	<xsl:variable name="busProcIcon">fa-sitemap</xsl:variable>
	<xsl:variable name="appIcon">fa-desktop</xsl:variable>
	<xsl:variable name="techProdIcon">fa-cogs</xsl:variable>
	
	<xsl:variable name="reviewDateColour">#f0b649</xsl:variable>
	<xsl:variable name="cancelNoticeDateColour">#f04969</xsl:variable>
	<xsl:variable name="renewalDateColour">black</xsl:variable>
	
	<xsl:variable name="contractRowCount" select="count($allSuppliers) + count($allContracts)"/>
	
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
                <!--<xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>-->
                <script type="text/javascript" src="js/d3/d3_4-11/d3.min.js"/>
				<!-- Searchable Select Box Libraries and Styles -->
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<!-- Bootstrap integer spinner -->
				<script type="text/javascript" src="js/bootstrap-input-spinner.js"/>
				<!-- Year Picker UI component -->
				<link rel="stylesheet" href="js/yearpicker/yearpicker.css"/>
				<script type="text/javascript" src="js/yearpicker/yearpicker.js"/>
				
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Supplier License Management</title>
				<style>
					.supplier{
						border: 1pt solid #d3d3d3;
						border-radius: 3px;
						box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
						margin: 4px 0px;
						background-color: #fff;
						border-left: 3pt solid #333;
						padding: 3px;
						cursor: pointer;
					}
					
					#supplier-summary-table > tbody > tr > th{
						width: 25%;
						background-color: #eee;
					}
					
					#supplier-summary-table > tbody > tr > th,
					#supplier-summary-table > tbody > tr > td{
						font-size: 1.2em;
						padding: 5px;
					}
					
					#supplier-summary-table {
						border-collapse: separate;
						border-spacing: 0 5px; 
					}
					

					.supplier,
					.product,
					.contract,
					.doc-popover-trigger {
						outline: none;
					}

					/* Strong visible focus indicator */
					.supplier:focus,
					.product:focus,
					.contract:focus,
					.doc-popover-trigger:focus {
						box-shadow: 0 0 0 3px rgba(0, 123, 255, .6);
						outline: 2px solid #005a9e;
						outline-offset: 2px;
					}
					.dateHeader {
						font-weight: bold;
						text-align: center;
					}
					
					.groupHeaderText {
						font-weight: bold;
					}
					
					.intro{
						background-color: #aaa;
						color: #ffffff;
						padding: 5px;
					}
					
					.detail{
						background-color: #f7f7f7;
						margin: 2px;
					}
					
					.licenceInfo{
						border: 1pt solid #ccc;
						border-radius: 4px;
						padding: 3px;
						float: left;
					}
					.licenceInfo.potentials{min-width:40px}
					.licenceInfo.contract{min-width:150px}
					.licenceInfo.type{min-width:100px}
					.licenceInfo.date{min-width:100px}
					.licenceInfo.poss{text-align: center; min-width: 30px;}
					
					.product, .contract {
						border: 1pt solid #aaa;
						border-radius: 4px;
						box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
						margin: 0 0 5px 0;
						padding: 5px;
						float: left;
						width: 100%;
					}
					
					#mnths{
						margin-bottom: 4px;
					}
					
					.monthView{
						margin-bottom: 4px;
					}
					
					.costcolumn{
						font-size: 14pt;
					}
					
					.dateBlock{
						height: 15px;
						border: 1pt solid #d3d3d3
					}
					
					#candidateLicenses{
						display: flex;
						flex-direction: column;
					}
					
					.supplier.active {
						border-left: 3pt solid <xsl:value-of select="$vIcon"/>;
					}
					
					.review-outlook-period {
						background-color: <xsl:value-of select="$reviewDateColour"/>;
					}
					
					.cancel-outlook-period {
						background-color: <xsl:value-of select="$cancelNoticeDateColour"/>;
					}
					
					.renewal-outlook-period {
						background-color: <xsl:value-of select="$renewalDateColour"/>;
					}
					
					.fa-info-circle {
						cursor: pointer;
					}
					.tab-pane {padding-top: 10px;}
					.lifecycle-vert-scroller {
						width: 100%;
						height: calc(100vh - 400px);
						overflow-x: hidden;
						overflow-y: scroll;
					}
					.lifecycle-wrapper {
						width: 100%;
						overflow-x: hidden;
					}

					/* === Modern look  feel overrides === */
					:root { --card-radius: 10px; --card-shadow: 0 6px 18px rgba(0,0,0,.08); --border-subtle: #e8e8e8; --ink-1:#111; --ink-2:#555; --ink-3:#888; --bg-soft:#fafafa; }
					

					h1.text-primary { font-weight: 700; letter-spacing: .2px; }

					.nav-tabs { border-bottom: 1px solid var(--border-subtle); }
					.nav-tabs>li>a { border-radius: 999px; margin-right: 8px; padding: 8px 14px; border: 1px solid var(--border-subtle); background:#fff; transition: all .2s ease; }
					.nav-tabs>li.active>a, .nav-tabs>li.active>a:focus, .nav-tabs>li.active>a:hover { color:#fff; background: <xsl:value-of select="$viewerPrimaryHeader"/>; border-color: <xsl:value-of select="$viewerPrimaryHeader"/>; }

					/* Card-like containers */
					.supplier, .product, .contract {
					border: 1px solid var(--border-subtle);
					border-radius: var(--card-radius);
					box-shadow: var(--card-shadow);
					background: #fff;
					transition: transform .12s ease, box-shadow .12s ease;
					}
					.supplier:hover, .product:hover, .contract:hover {
					transform: translateY(-1px);
					box-shadow: 0 10px 22px rgba(0,0,0,.10);
					}

					/* Supplier list density + accent */
					.supplier {
					padding: 10px 12px;
					border-left: 4px solid <xsl:value-of select="$vIcon"/>;
					transition: box-shadow .2s ease;
					position: relative;
					overflow: hidden;
					}
					.supplier::after {
					content: '';
					position: absolute;
					top: 0;
					right: 0;
					width: 0;
					height: 100%;
					background: transparent;
					transition: width .2s ease, background .2s ease;
					}
					.supplier.active {
					border-left-color: <xsl:value-of select="$vIcon"/>;
					background: linear-gradient(0deg, rgba(66,133,244,.05), rgba(66,133,244,0));
					}
					.supplier.supplier-warning::after {
					width: 30px;
					background: #f0b649;
					}
					.supplier.supplier-critical::after {
					width: 30px;
					background: #ba3a3a;
					}

					/* Summary table */
					#supplier-summary-table > tbody > tr > th { width: 30%; background:#fff; color: var(--ink-2); border-left: 3px solid <xsl:value-of select="$viewerSecondaryHeader"/>; }
					#supplier-summary-table > tbody > tr > th,
					#supplier-summary-table > tbody > tr > td {
					font-size: 13px; padding: 10px 12px; border-top: 1px solid var(--border-subtle);
					}
					#supplier-summary-table {
					border-radius: var(--card-radius); box-shadow: var(--card-shadow); overflow: hidden; background:#fff;
					}

					/* Chips for licence info */
					.licenceInfo {
					display:inline-flex; align-items:center; gap:6px;
					background:#fff; border:1px solid var(--border-subtle); border-radius: 999px;
					padding: 4px 10px; font-size:12px; color:var(--ink-2);
					}
					.licenceInfo .fa { opacity:.7; }

					/* Popover visuals */
					.popover {
					border:1px solid var(--border-subtle);
					border-radius: 12px;
					box-shadow: 0 14px 34px rgba(0,0,0,.18);
					max-width: 380px;
					}
					.popover .small { color: var(--ink-2); }
					.fa-info-circle { opacity:.65; transition: opacity .15s ease, transform .15s ease; }
					.fa-info-circle:hover { opacity:1; transform: scale(1.04); }

					/* Inputs */
					input#supplierFilter, input#outlookSupplierFilter {
					border-radius: 8px; border:1px solid var(--border-subtle); padding:8px 10px; background:#fff;
					}
					#outlookYears { border-radius: 8px; border:1px solid var(--border-subtle); padding:6px 10px; }

					/* Timeline header + grid */
										.lifecycle-wrapper {
										border: 1px solid var(--border-subtle);
										border-radius: var(--card-radius);
										background:#fff;
										box-shadow: var(--card-shadow);
										padding: 8px 12px; /* add breathing room for timeline content */
										}
										.lifecycle-vert-scroller { padding-right: 12px; }
					.lifecycle-vert-scroller { height: calc(100vh - 360px); }
					.headerText { font-weight:600; }

					/* Keys */
					.productKey .keyLabel { color:var(--ink-2); }
					.keySampleWide { border-radius: 6px; }

					/* Row titles next to info icon */
					.row-title { font-weight:600; color: var(--ink-1); }
					.groupHeaderText { font-weight:700; color: var(--ink-1); }

					/* === Solution Supplier Modern Card === */
					.supplier-modern-card {
					position: relative;
					overflow: hidden;
					padding: 24px 26px;
					margin-bottom: 24px;
					border-radius: var(--card-radius);
					border: 1px solid var(--border-subtle);
					box-shadow: var(--card-shadow);
					background: #fff;
					}
					.supplier-modern-card:after {
					content: "";
					position: absolute;
					top: -80px;
					right: -40px;
					width: 200px;
					height: 200px;
					background: radial-gradient(circle at center, <xsl:value-of select="$viewerSecondaryHeader"/> 0%, transparent 65%);
					opacity: .15;
					}
					.supplier-modern-card > * { position: relative; z-index: 1; }
					.supplier-modern-card.supplier-warning::after {
					background: linear-gradient(180deg, rgba(240,182,73,.45), rgba(240,182,73,0));
					opacity: .35;
					}
					.supplier-modern-card.supplier-critical::after {
					background: linear-gradient(180deg, rgba(240,73,73,.55), rgba(240,73,73,0));
					opacity: .4;
					}
					.supplier-modern-header {
					display: flex;
					flex-wrap: wrap;
					gap: 24px;
					align-items: flex-start;
					justify-content: space-between;
					}
					.supplier-modern-metrics {
					display: grid;
					grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
					gap: 12px;
					margin-top: 20px;
					}
					.eyebrow-label {
					text-transform: uppercase;
					font-size: 10px;
					letter-spacing: .25em;
					color: var(--ink-3);
					display: block;
					margin-bottom: 6px;
					}
					.metric-card {
					background: var(--bg-soft);
					border-radius: var(--card-radius);
					border: 1px solid var(--border-subtle);
					padding: 12px 14px;
					box-shadow: inset 0 1px 0 rgba(255,255,255,.5);
					}
					.metric-label {
					display:block;
					font-size:11px;
					text-transform:uppercase;
					letter-spacing:.08em;
					color:var(--ink-3);
					margin-bottom:4px;
					}
					.metric-value {
					font-size:22px;
					font-weight:600;
					color:var(--ink-1);
					}

					/* Contract view */
					.contract-modern-card .chip-row { margin-top: 12px; }
					.contract-card {
					border-radius: var(--card-radius);
					border: 1px solid var(--border-subtle);
					box-shadow: var(--card-shadow);
					background: #fff;
					padding: 20px 22px;
					margin-bottom: 16px;
					}
					.contract-card__header {
					display: flex;
					justify-content: space-between;
					flex-wrap: wrap;
					gap: 16px;
					}
					.contract-card__title {
					font-size: 18px;
					font-weight: 600;
					color: var(--ink-1);
					margin: 0;
					}
					.contract-card__meta {
					display: flex;
					flex-wrap: wrap;
					gap: 8px;
					margin-top: 6px;
					color: var(--ink-2);
					font-size: 13px;
					}
					.contract-card__value {
					text-align: right;
					}
					.contract-card__amount {
					font-size: 24px;
					font-weight: 600;
					color: <xsl:value-of select="$viewerPrimaryHeader"/>;
					}
					.contract-card__docs a {
					margin-left: 6px;
					color: var(--ink-2);
					text-decoration: none;
					}
					.doc-popover-trigger {
					display: inline-flex;
					width: 34px;
					height: 34px;
					border-radius: 50%;
					border: 1px solid var(--border-subtle);
					align-items: center;
					justify-content: center;
					background:#fff;
					cursor: pointer;
					transition: background .2s ease;
					}
					.doc-popover-trigger:hover {
					background: var(--bg-soft);
					}
					.doc-popover-panel {
					position: absolute;
					min-width: 220px;
					max-width: 300px;
					background:#fff;
					border:1px solid var(--border-subtle);
					border-radius: var(--card-radius);
					box-shadow: 0 12px 30px rgba(0,0,0,.18);
					padding: 12px 14px;
					z-index: 9999;
					}
					.doc-popover-panel a {
					display:block;
					color: <xsl:value-of select="$viewerPrimaryHeader"/>;
					font-size: 13px;
					margin-bottom:6px;
					text-decoration:none;
					}
					.doc-popover-panel a:last-child { margin-bottom:0; }
					.contract-card__chips {
					margin-top: 12px;
					}
					.contract-card__body {
					margin-top: 18px;
					display: flex;
					flex-direction: column;
					gap: 14px;
					}
					.contract-component {
					border: 1px solid var(--border-subtle);
					border-radius: var(--card-radius);
					padding: 14px 16px;
					background: var(--bg-soft);
					}
					.contract-component__summary {
					display: flex;
					justify-content: space-between;
					flex-wrap: wrap;
					gap: 12px;
					}
					.contract-card.contract-warning {
					border-left: 4px solid #f0b649;
					}
					.contract-card.contract-critical {
					border-left: 4px solid #f04949;
					}
					.contract-component.contract-warning { border-color: #f0b649; background: rgba(240,182,73,.1); }
					.contract-component.contract-critical { border-color: #f04949; background: rgba(240,73,73,.1); }
					.contract-component__supplier {
					font-weight: 600;
					color: var(--ink-1);
					}
					.association-group {
					margin-top: 12px;
					}
					.association-label {
					font-size: 11px;
					text-transform: uppercase;
					letter-spacing: .08em;
					color: var(--ink-3);
					display: block;
					margin-bottom: 6px;
					}
					.association-pill-list {
					display: flex;
					flex-wrap: wrap;
					gap: 6px;
					}
					.association-pill {
					display: inline-flex;
					align-items: center;
					padding: 4px 10px;
					border-radius: 999px;
					border: 1px solid var(--border-subtle);
					background: #fff;
					font-size: 12px;
					color: var(--ink-2);
					}
					.supplier-modern-name {
					font-size: 26px;
					font-weight: 700;
					color: var(--ink-1);
					line-height: 1.2;
					}
					.supplier-modern-desc {
					color: var(--ink-2);
					margin-top: 4px;
					max-width: 520px;
					}
					.supplier-modern-value {
					font-size: 30px;
					font-weight: 600;
					color: <xsl:value-of select="$viewerPrimaryHeader"/>;
					}
					.metric-pill {
					display: inline-flex;
					align-items: center;
					gap: 6px;
					border-radius: 999px;
					border: 1px solid var(--border-subtle);
					padding: 6px 14px;
					font-size: 12px;
					text-transform: uppercase;
					letter-spacing: .04em;
					background: var(--bg-soft);
					color: var(--ink-2);
					}
					.btn-ghost {
					border-radius: 999px;
					border: 1px solid rgba(0,0,0,.15);
					background: transparent;
					padding: 5px 16px;
					font-size: 12px;
					color: var(--ink-2);
					transition: all .2s ease;
					}
					.btn-ghost:hover {
					background: rgba(0,0,0,.03);
					color: var(--ink-1);
					}
					.cost-toggle-container .cost-by-currency { margin-top: 8px; }

					/* Solutions list */
					.modern-section-heading {
					display: flex;
					flex-wrap: wrap;
					justify-content: space-between;
					align-items: center;
					gap: 12px;
					}
					.modern-filter {
					display:flex;
					align-items:center;
					gap:10px;
					}
					.solution-card {
					border-radius: var(--card-radius);
					border: 1px solid var(--border-subtle);
					box-shadow: var(--card-shadow);
					background: #fff;
					padding: 18px 20px;
					margin-bottom: 12px;
					}
					.solution-card__header {
					display: flex;
					flex-wrap: wrap;
					justify-content: space-between;
					align-items: center;
					gap: 12px;
					margin-bottom: 12px;
					}
					.solution-card__title {
					display: flex;
					align-items: center;
					gap: 10px;
					font-weight: 600;
					font-size: 16px;
					color: var(--ink-1);
					}
					.solution-card__title small {
					display: block;
					font-weight: 400;
					color: var(--ink-3);
					}
					.solution-card__contract {
					border-top: 1px solid var(--border-subtle);
					padding-top: 12px;
					margin-top: 12px;
					}
					.solution-card__contract:first-of-type {
					border-top: none;
					padding-top: 0;
					margin-top: 0;
					}
					.solution-card__contract-header {
					display:flex;
					justify-content:space-between;
					gap:8px;
					flex-wrap:wrap;
					}
					.timeline-lozenges {
					display:inline-flex;
					gap:6px;
					margin-left:8px;
					margin-right:2px;
					}
					.timeline-lozenge {
					padding:2px 6px;
					border-radius:999px;
					border:1px solid currentColor;
					font-size:10px;
					text-transform:uppercase;
					letter-spacing:.05em;
					color:var(--ink-2);
					background:#fff;
					margin-left:2px;
					margin-right:2px;
					}
					.timeline-lozenge.cancel { color:#f04949; border-color:#f04949; }
					.timeline-lozenge.renewal { color:#111; border-color:#111; }
					.timeline-key {
					position:absolute;
					top:0;
					left:0;
					display:flex;
					align-items:center;
					gap:8px;
					padding:2px 8px;
					flex-wrap:wrap;
					font-size:11px;
					color:#555;
					background:#fff;
					border-radius:20px;
					box-shadow:0 1px 3px rgba(0,0,0,.1);
					z-index:2;
					}
					.timeline-key .timeline-lozenge {
					margin:0;
					font-size:11px;
					white-space:nowrap;
					}
					#lfHeader {
					position:relative;
					min-height:30px;
					}
					.timeline-bar {
					shape-rendering:geometricPrecision;
					paint-order:stroke fill;
					}
					.solution-card__supplier {
					font-weight: 600;
					color: var(--ink-1);
					}
					.chip-row {
					display: flex;
					flex-wrap: wrap;
					gap: 6px;
					margin-top: 8px;
					}
					.contract-chip {
					display: inline-flex;
					align-items: center;
					gap: 6px;
					border-radius: 999px;
					border: 1px solid var(--border-subtle);
					padding: 4px 12px;
					background: var(--bg-soft);
					font-size: 12px;
					color: var(--ink-2);
					}
					.doc-link-pill {
					display: inline-flex;
					align-items: center;
					gap: 4px;
					border-radius: 999px;
					border: 1px solid var(--border-subtle);
					padding: 3px 10px;
					font-size: 11px;
					color: var(--ink-2);
					margin-left: 6px;
					}
					.modern-filter input {
					border-radius: 999px !important;
					padding: 6px 14px !important;
					}

					.keySampleWide {
						min-height: 12px;
						border-radius: 4px;
						border: 1px solid rgba(0,0,0,.2);
					}

					/* Make month/year labels slightly larger for readability */
					.dateHeader,
					.headerText {
						font-size: 13px;
					}
					.sr-only {
						position: absolute;
						width: 1px;
						height: 1px;
						padding: 0;
						margin: -1px;
						overflow: hidden;
						clip: rect(0,0,0,0);
						border: 0;
					}
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
  
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 class="text-primary"><xsl:value-of select="eas:i18n('Supplier License Management')"/></h1>
							<hr/>
						</div>
						<div class="col-xs-12">
							<ul class="nav nav-tabs" role="tablist">
								<li class="active">
									<a data-toggle="tab" href="#supplierTab" role="tab" aria-controls="supplierTab" aria-selected="true"><xsl:value-of select="eas:i18n('Suppliers')"/></a>
								</li>
                                <li>
                                	<a data-toggle="tab" href="#outlookTab" role="tab" aria-controls="outlookTab"  aria-selected="false"><xsl:value-of select="eas:i18n('Contract Renewal Outlook')"/></a>
								</li>
							</ul>
							<div class="tab-content">
								<div id="supplierTab" class="tab-pane fade in active" role="tabpanel" aria-labelledby="tab-suppliers">
									<!--<h3 class="strong"><xsl:value-of select="eas:i18n('Suppliers')"/></h3>		-->							
									<div class="row">										
										<div class="col-md-3">
											<fieldset class="bottom-10">
												<legend class="sr-only">
													<xsl:value-of select="eas:i18n('Supplier type')"/>
												</legend>
												<label class="radio-inline">
													<input type="radio" name="supplierType" id="contractSupplier" class="contractSupplier" value="contract" checked="checked"/>
													<xsl:value-of select="eas:i18n('Contract Suppliers/Resellers')"/>
												</label><br/>
												<label class="radio-inline">
													<input type="radio" name="supplierType" id="productSupplier" class="productSupplier" value="product"/>
													<xsl:value-of select="eas:i18n('Product/Service Suppliers')"/>
												</label>
											</fieldset>
											<div>
												<label class="right-10" for="supplierFilter">
													<xsl:value-of select="eas:i18n('Filter Suppliers')"/>:
												</label>	
												<input type="text" id="supplierFilter" style="min-width: 300px;"/>
											</div>
											<div id="supplierDetailsList" 
												class="top-15" 
												style="overflow-y:scroll;max-height:400px" 
												role="region"
												aria-live="polite"
												aria-label="Supplier list"/>
										</div>
										<div class="col-md-9">
											<div id="supplierSummary" role="region"
												aria-live="polite"
												aria-label="Supplier details"/>
										</div>
									</div>
								</div>
								<div id="outlookTab" class="tab-pane fade" role="tabpanel" aria-labelledby="tab-outlook">
									<!--<h3 class="strong"><xsl:value-of select="eas:i18n('Contract Renewal')"/> - <xsl:value-of select="eas:i18n('12 Month Outlook')"/></h3>-->
									<div class="row">
										<div class="col-xs-3">
											<!--<div class="bottom-10">
												<label class="radio-inline"><input type="radio" name="outlookListType" id="contractOutlook" value="contractOutlook" checked="checked"/><xsl:value-of select="eas:i18n('Contract Suppliers')"/></label>
												<label class="radio-inline"><input type="radio" name="outlookListType" id="productOutlook"  value="productOutlook"/><xsl:value-of select="eas:i18n('Products/Services')"/></label>																							
											</div>-->
											<div class="row">
												<div class="top-5 col-xs-12">
													<label class="right-10" for="outlookSupplierFilter">
														<xsl:value-of select="eas:i18n('Filter Contracts')"/>:
													</label>
													<input type="text" id="outlookSupplierFilter" style="min-width: 270px;"/>	
												</div>
											</div>
										</div>
										<div class="col-xs-9">
											<div class="row">
												<div class="col-xs-8">
													<div class="pull-left right-30">
														<label class="fontBold"><xsl:value-of select="eas:i18n('From Year')"/>:</label>
														<input class="date-picker form-control" style="display: inline-block; width: 100px;" data-provide="datepicker" id="outlookStartPicker"/>
													</div>
													<div class="pull-left" style="display: inline-block;">
														<label class="fontBold right-10"
															for="outlookYears"
															style="position: relative; top: 7px;">
															<xsl:value-of select="eas:i18n('Outlook')"/> (<xsl:value-of select="eas:i18n('years')"/>):
														</label>
														<!--<div class="pull-left" style="width: 120px">
															<div class="input-group number-spinner">
																<span class="input-group-btn">
																	<button class="btn btn-default btn-sm" data-dir="dwn"><i class="fa fa-minus"/></button>
																</span>
																<input id="outlookYears" class="form-control input-sm text-center" type="text"/>
																<span class="input-group-btn">
																	<button class="btn btn-sm btn-default" data-dir="up"><i class="fa fa-plus"/></button>
																</span>
															</div>
														</div>-->
													</div>
													<div style="display:inline-block; width: 120px;">
														<input id="outlookYears" class="form-control" type="number" min="1" max="6" step="1"/>
													</div>
													<div class="">
														<fieldset>
															<legend class="sr-only">
																<xsl:value-of select="eas:i18n('Sort contracts by')"/>
															</legend>
															<span class="right-10">
																<strong><xsl:value-of select="eas:i18n('Sort By')"/>:</strong>
															</span>
															<label class="radio-inline">
																<input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByName" value="name"/>
																<xsl:value-of select="eas:i18n('Name')"/>
															</label>
															<label class="radio-inline">
																<input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByReview" value="review"/>
																<xsl:value-of select="eas:i18n('Review Date')"/>
															</label>
															<label class="radio-inline">
																<input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByNotice" value="cancel"/>
																<xsl:value-of select="eas:i18n('Cancellation Deadline')"/>
															</label>
															<label class="radio-inline">
																<input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByRenewal" value="end" checked="checked"/>
																<xsl:value-of select="eas:i18n('Renewal Date')"/>
															</label>
														</fieldset>
													</div>
												</div>
												<div class="col-xs-4">
													<div class="productKey pull-right">
														<div class="clearfix"/>
														<div class="keySampleWide review-outlook-period"/>
														<div class="keyLabel"><xsl:value-of select="eas:i18n('Contract Review Period')"/></div>
														<div class="clearfix"/>
														<div class="keySampleWide cancel-outlook-period"/>
														<div class="keyLabel"><xsl:value-of select="eas:i18n('Beyond Cancellation Date')"/></div>												
														<div class="clearfix"/>
														<div class="keySampleWide renewal-outlook-period"/>
														<div class="keyLabel"><xsl:value-of select="eas:i18n('Contract Renewal Date')"/></div>
													</div>
												</div>
											</div>											
										</div>
										<div class="col-xs-12">
											<hr class="tight"/>
											<div class="lifecycle-wrapper">
												<!-- OUTLOOK SVG CONTAINER -->
												<div id="lfHeader" style="margin-left: 12px;" role="group" aria-label="Contract renewal outlook axis"></div>
												<div class="lifecycle-vert-scroller">
													<!-- OUTLOOK SVG CONTAINER -->
													<div id="box" style="margin-left: 12px;" role="img" aria-label="Contract renewal outlook timeline"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				 
			</body>

		<script>
			<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
			var viewData = {
				"supplierRelTypes": [<xsl:apply-templates select="key('supplierRelStatii_key','Supplier_Relationship_Status')" mode="RenderEnumJSON"/>],
				"contractTypes": [<xsl:apply-templates select="key('allContractTypes_key', 'Contract_Type')" mode="RenderEnumJSON"/>],
				"solutionProviders": [<xsl:apply-templates select="$allSolutionProvidersSorted" mode="RenderSolutionSupplierJSON"/>],
				"contractSuppliers": [<xsl:apply-templates select="$allContractSuppliersSorted" mode="RenderContractSupplierJSON"/>],
				"contracts": [<xsl:apply-templates select="key('allContracts_type', 'Contract')" mode="RenderContractJSON"/>],
				"contractComps": [<xsl:apply-templates select="$allContractToElementRels" mode="RenderContractCompJSON"/>],
				"busProcesses": [<xsl:apply-templates select="$busProcessesSorted" mode="RenderContractSolutionJSON"><xsl:with-param name="supplierSlot">business_process_supplier</xsl:with-param><xsl:with-param name="icon" select="$busProcIcon"/></xsl:apply-templates>],
				"applications": [<xsl:apply-templates select="$applicationsSorted" mode="RenderContractSolutionJSON"><xsl:with-param name="supplierSlot">ap_supplier</xsl:with-param><xsl:with-param name="icon" select="$appIcon"/></xsl:apply-templates>],
				"techProducts": [<xsl:apply-templates select="$techProductsSorted" mode="RenderContractSolutionJSON"><xsl:with-param name="supplierSlot">supplier_technology_product</xsl:with-param><xsl:with-param name="icon" select="$techProdIcon"/></xsl:apply-templates>],
				"currency":"<xsl:value-of select="$baseCurrencySymbol"/>",
				"baseCurrency":{
					"id":"<xsl:value-of select="if ($baseCurrency) then eas:getSafeJSString($baseCurrency/name) else ''"/>",
					"name":"<xsl:value-of select="normalize-space($baseCurrencyName)"/>",
					"code":"<xsl:value-of select="$baseCurrencyCode"/>",
					"symbol":"<xsl:value-of select="$baseCurrencySymbol"/>",
					"exchangeRate": <xsl:value-of select="$baseCurrencyExchangeRate"/>
				},
				"currencies":[<xsl:apply-templates select="key('kByType', 'Currency')" mode="RenderCurrencyJSON"/>]
			}
		 //	console.log('viewData', viewData);

			const byCode = Object.fromEntries(viewData.currencies.map(c => [c.code, c]));
			var viewIcons = {
				"busProc": "fa-people",
				"app": "fa-monitor",
				"techProd": "fa-cog",
			}
	    
	    	var supplierTemplate, contractSupplierDetailsTemplate, solutionSupplierDetailsTemplate;
	    
	    	function toNumber(value, fallback) {
	    		const num = Number(value);
	    		return Number.isFinite(num) ? num : (fallback !== undefined ? fallback : 0);
	    	}
	    
	    	function roundToTwo(value) {
	    		return Math.round((toNumber(value, 0) + Number.EPSILON) * 100) / 100;
	    	}
	    
	    	function formatCurrencyAmount(amount) {
	    		if (amount === null || amount === undefined || amount === '') {
	    			return '';
	    		}
	    		const num = toNumber(amount, NaN);
	    		if (!Number.isFinite(num)) {
	    			return amount;
	    		}
	    		const hasFraction = Math.abs(num - Math.trunc(num)) > 0;
	    		return num.toLocaleString(undefined, {
	    			minimumFractionDigits: hasFraction ? 2 : 0,
	    			maximumFractionDigits: 2
	    		});
	    	}
	    
	    	function buildExchangeRateLookup(currencies) {
	    		const lookup = {};
	    		(currencies || []).forEach(function(currency) {
	    			const rate = toNumber(currency.exchangeRate, NaN);
	    			if (Number.isFinite(rate) &amp;&amp; rate > 0) {
	    				if (currency.id) {
	    					lookup[currency.id] = rate;
	    				}
	    				if (currency.code) {
	    					lookup[currency.code.toUpperCase()] = rate;
	    				}
	    			}
	    		});
	    		return lookup;
	    	}
	    
	    	function resolveExchangeRate(entry, exchangeRates, baseRate) {
	    		if (!entry) {
	    			return baseRate;
	    		}
	    		const explicit = toNumber(entry.currencyExchangeRate, NaN);
	    		if (Number.isFinite(explicit) &amp;&amp; explicit > 0) {
	    			return explicit;
	    		}
	    		const code = entry.currencyCode ? entry.currencyCode.toUpperCase() : null;
	    		if (code) {
	    			const codeRate = toNumber(exchangeRates[code], NaN);
	    			if (Number.isFinite(codeRate) &amp;&amp; codeRate > 0) {
	    				return codeRate;
	    			}
	    		}
	    		const id = entry.currencyId;
	    		if (id) {
	    			const idRate = toNumber(exchangeRates[id], NaN);
	    			if (Number.isFinite(idRate) &amp;&amp; idRate > 0) {
	    				return idRate;
	    			}
	    		}
	    		return baseRate;
	    	}
	    
	    	function convertToBase(amount, sourceRate, baseRate) {
	    		const numericAmount = toNumber(amount, 0);
	    		if (!numericAmount) {
	    			return 0;
	    		}
	    		const fromRate = toNumber(sourceRate, baseRate);
	    		const effectiveBase = toNumber(baseRate, 1);
	    		if (!Number.isFinite(fromRate) || fromRate &lt;= 0) {
	    			return numericAmount;
	    		}
	    		if (!Number.isFinite(effectiveBase) || effectiveBase &lt;= 0) {
	    			return numericAmount / fromRate;
	    		}
	    		return (numericAmount / fromRate) * effectiveBase;
	    	}
	    
	    	function initJSONData() {
				const {
					baseCurrency = {},
					currencies = [],
					contracts = [],
					contractSuppliers = [],
					contractComps = [],
					busProcesses = [],
					applications = [],
					techProducts = [],
					supplierRelTypes = [],
					solutionProviders = [],
					currency: fallbackCurrencySymbol
				} = viewData;

				const baseRate = toNumber(baseCurrency.exchangeRate, 1);
				const defaultCurrencySymbol = baseCurrency.symbol || fallbackCurrencySymbol;
				const exchangeRates = buildExchangeRateLookup(currencies);
				const defaultCurrencyCode = baseCurrency.code;
				// ---------- fast lookups ----------
				const mapById = arr => new Map(arr.map(o => [o.id, o]));
				const suppliersById      = mapById(contractSuppliers);
				const relTypesById       = mapById(supplierRelTypes);
				const contractsById      = mapById(contracts);
				const compsById          = mapById(contractComps);
				const busProcsById       = mapById(busProcesses);
				const appsById           = mapById(applications);
				const techProdsById      = mapById(techProducts);
				const solProvidersById   = mapById(solutionProviders);

				const pickOne = (id, map) => (id != null ? map.get(id) : undefined);
				const pickMany = (ids, map) => {
					if (!Array.isArray(ids) || ids.length === 0) return [];
					const out = new Array(ids.length);
					let j = 0;
					for (let i = 0; i &lt; ids.length; i++) {
					const item = map.get(ids[i]);
					if (item) out[j++] = item;
					}
					out.length = j; // trim if some ids missing
					return out;
				};

				// ---------- contracts ----------
				for (const c of contracts) {
					c.supplier = pickOne(c.supplierId, suppliersById);

					c.contractComps = pickMany(c.contractCompIds, compsById);
					c.busProcs      = pickMany(c.busProcIds,      busProcsById);
					c.apps          = pickMany(c.appIds,          appsById);
					c.techProds     = pickMany(c.techProdIds,     techProdsById);

					const contractRate = resolveExchangeRate(c, exchangeRates, baseRate);
					c.currencyExchangeRate = contractRate;

					if (!c.currencyCode &amp;&amp; baseCurrency.code) c.currencyCode = baseCurrency.code;
					c.currency  = defaultCurrencySymbol;

					c.cost      = toNumber(c.cost, 0);
					c.costBase  = roundToTwo(convertToBase(c.cost, contractRate, baseRate));

					let contractTotalBase = 0;
					const byCurrencyTotal   = {};
					for (const cc of c.contractComps) {
						cc.cost = toNumber(cc.cost, 0);
						const componentRate = resolveExchangeRate(cc, exchangeRates, baseRate);
						cc.currencyExchangeRate = componentRate;
						cc.costBase = roundToTwo(convertToBase(cc.cost, componentRate, baseRate));
						contractTotalBase += cc.costBase;

						const currencyCode = cc.currencyCode || c.currencyCode || baseCurrency.code;
						
						if (currencyCode) {
							
							let sym=byCode[currencyCode].symbol;  
							
							if (!byCurrencyTotal[currencyCode]) {
								byCurrencyTotal[currencyCode] = { currency: currencyCode, symbol: sym, total: 0 };
							}
							byCurrencyTotal[currencyCode].total += cc.cost;
						}
						cc.currencyCode = currencyCode;
					}

					if (contractTotalBase === 0 &amp;&amp; c.contractComps.length === 0) {
						contractTotalBase = c.costBase;
						const currencyCode = c.currencyCode || baseCurrency.code;
							
						if (currencyCode) {
							
							let sym=byCode[currencyCode].symbol;  
							if (!byCurrencyTotal[currencyCode]) {
								byCurrencyTotal[currencyCode] = { currency: currencyCode, symbol: sym, total: 0 };
							}
							byCurrencyTotal[currencyCode].total += c.cost;
						}
					}
					c.byCurrencyTotal = Object.values(byCurrencyTotal);

					if (c.startDate != null)   c.prettyStartDate   = moment(c.startDate).format('DD MMM YYYY');
					if (c.renewalDate != null) c.prettyRenewalDate = moment(c.renewalDate).format('DD MMM YYYY');

					c.totalCost       = roundToTwo(contractTotalBase);
					c.prettyTotalCost = formatCurrencyAmount(c.totalCost);
				}
				

				// ---------- solution providers ----------
				for (const sp of solutionProviders) {
					sp.relStatus = pickOne(sp.relStatusId, relTypesById);

					sp.busProcs  = pickMany(sp.busProcIds,  busProcsById);
					sp.apps      = pickMany(sp.appIds,      appsById);
					sp.techProds = pickMany(sp.techProdIds, techProdsById);
					sp.contracts = pickMany(sp.contractIds, contractsById);

					let total = 0;
					const totalByCurrency = {};

					for (const c of sp.contracts) {
						total += toNumber(c.totalCost, 0);
						if (c.byCurrencyTotal &amp;&amp; Array.isArray(c.byCurrencyTotal)) {
							for (const currencyTotal of c.byCurrencyTotal) {
								const currencyCode = currencyTotal.currency;
									
								if (currencyCode) {
								

									let sym=byCode[currencyCode].symbol;  
									if (!totalByCurrency[currencyCode]) {
										totalByCurrency[currencyCode] = { currency: currencyCode, symbol: sym, total: 0 };
									}
									totalByCurrency[currencyCode].total += toNumber(currencyTotal.total, 0);
								}
							}
						}
					}

					sp.totalCost       = roundToTwo(total);
					sp.prettyTotalCost = formatCurrencyAmount(sp.totalCost);
					sp.currency        = defaultCurrencySymbol;
					sp.currencyCode = defaultCurrencyCode;
					sp.totalByCurrency = Object.values(totalByCurrency).map(item => {
						item.total = roundToTwo(item.total);
						return item;
					});

				}

				// ---------- contract suppliers ----------
				for (const cs of contractSuppliers) {
					cs.relStatus = pickOne(cs.relStatusId, relTypesById);
					cs.contracts = pickMany(cs.contractIds, contractsById);

					let total = 0;
					const totalByCurrency = {};

					for (const c of cs.contracts) {
						total += toNumber(c.totalCost, 0);
						if (c.byCurrencyTotal &amp;&amp; Array.isArray(c.byCurrencyTotal)) {
							for (const currencyTotal of c.byCurrencyTotal) {
								const currencyCode = currencyTotal.currency;
								
								if (currencyCode) {

									let sym=byCode[currencyCode].symbol;  
									if (!totalByCurrency[currencyCode]) {
										totalByCurrency[currencyCode] = { currency: currencyCode, symbol: sym, total: 0 };
									}
									totalByCurrency[currencyCode].total += toNumber(currencyTotal.total, 0);
								}
							}
						}
					}
					cs.test = baseCurrency
					cs.totalCost       = roundToTwo(total);
					cs.prettyTotalCost = formatCurrencyAmount(cs.totalCost);
					cs.currency        = defaultCurrencySymbol;
					cs.currencyCode = defaultCurrencyCode;
					cs.totalByCurrency = Object.values(totalByCurrency).map(item => {
						item.total = roundToTwo(item.total);
						return item;
					});

				}

				// ---------- contract components ----------
				for (const cc of contractComps) {
					cc.contract = pickOne(cc.contractId, contractsById);
					cc.supplier = pickOne(cc.supplierId, suppliersById);

					cc.busProcs  = pickMany(cc.busProcIds,  busProcsById);
					cc.apps      = pickMany(cc.appIds,      appsById);
					cc.techProds = pickMany(cc.techProdIds, techProdsById);

					if (typeof cc.cost === 'undefined') cc.cost = 0;

					if (typeof cc.costBase === 'undefined') {
					const componentRate = resolveExchangeRate(cc, exchangeRates, baseRate);
					cc.currencyExchangeRate = componentRate;
					cc.cost      = toNumber(cc.cost, 0);
					cc.costBase  = roundToTwo(convertToBase(cc.cost, componentRate, baseRate));
					}

					if (cc.startDate != null)   cc.prettyStartDate   = moment(cc.startDate).format('DD MMM YYYY');
					if (cc.renewalDate != null) cc.prettyRenewalDate = moment(cc.renewalDate).format('DD MMM YYYY');

					cc.prettyCost     = formatCurrencyAmount(cc.cost);
					cc.prettyCostBase = formatCurrencyAmount(cc.costBase);
				}

				// ---------- business processes / apps / tech products ----------
				for (const bp of busProcesses) {
					bp.supplier      = pickOne(bp.supplierId, solProvidersById);
					bp.contractComps = pickMany(bp.contractCompIds, compsById);
				}

				for (const app of applications) {
					app.supplier      = pickOne(app.supplierId, solProvidersById);
					app.contractComps = pickMany(app.contractCompIds, compsById);
				}

				for (const tp of techProducts) {
					tp.supplier      = pickOne(tp.supplierId, solProvidersById);
					tp.contractComps = pickMany(tp.contractCompIds, compsById);
				}
				}
	    	
	    	
	    	function registerSortOrderListener() {
	    		$('.outlook-sort-radio').click(function(){
	    			let newOrder = $(this).val();
	    			//console.log('Changed sort to: ' + newOrder);
	    			if(outlookSortOrder != newOrder) {
	    				outlookSortOrder = newOrder;
	    				if(outlookSupplierMode == PRODUCT_SUPPLIER_MODE) {
        					sortOutlookEntries(solutionOutlookData);
        					updateOutlook(solutionOutlookData);
        				} else {
        					sortOutlookEntries(contractOutlookData);
        					updateOutlook(contractOutlookData);
        				}
	    			}
	    		}); 			
	    	}
	    	
	    	function registerSupplierListeners() {
	    		const supplierCurrencySymbol = (viewData.baseCurrency &amp;&amp; viewData.baseCurrency.symbol) || viewData.currency;
				$('.supplier')
					.attr('tabindex', '0')
					.attr('role', 'button')
					.off('keydown.supplier')
					.on('keydown.supplier', function (e) {
						if (e.key === 'Enter' || e.key === ' ') {
							e.preventDefault();
							$(this).click();
						}
					});

	        	$('.supplier').click(function(){
	        		if(supplierMode == PRODUCT_SUPPLIER_MODE) {
	        			let suppId = $(this).attr('eas-id');
	        			let thisSupp = viewData.solutionProviders.find(function(aSupp) {
	        				return aSupp.id == suppId;
						});

						thisSupp.currency = supplierCurrencySymbol;
	        			if(thisSupp != null) {
	        				$('#supplierSummary').html(solutionSupplierDetailsTemplate(thisSupp)).promise().done(function(){
				       			//add event listener for filtering solutions
							   $('#solutionFilter').on( 'keyup change', function () {
						            var textVal = $(this).val().toLowerCase();
						            $('.product').each(function(i, obj) {
						                 $(this).show();			                 
						                 if(textVal != null) {
						                     var itemName = $(this).text().toLowerCase();
						                     if(!(itemName.includes(textVal))) {
						                         $(this).hide();
						                     }
						                 }
						             });
						       });
				       		});
	        			}
	        		} else {
	        			let suppId = $(this).attr('eas-id');
	        			let thisSupp = viewData.contractSuppliers.find(function(aSupp) {
	        				return aSupp.id == suppId;
						});
				
						thisSupp.currency = supplierCurrencySymbol;

						//console.log('thisSupp', thisSupp);
	        			if(thisSupp != null) {
	        				$('#supplierSummary').html(contractSupplierDetailsTemplate(thisSupp)).promise().done(function(){
				       			//add event listener for filtering solutions
					
							   $('#contractFilter').on( 'keyup change', function () {
						            var textVal = ($(this).val() || '').toLowerCase();
						            $('.contract').each(function() {
						                 var name = ($(this).attr('data-contract-name') || '').toLowerCase();
						                 var matches = !textVal || name.includes(textVal);
						                 $(this).toggle(matches);
						             });
						       });
				       		});
	        			}
	        		}	
	        	});
        	}
        	
        	//variables for outlook
        	var lifeColourJSON=[
				{"label": "Start", "styleClass": "start-date", "name":"Start Date","id":"start","val":"#e3e3e3","textcolour":"","order":0},
        		{"label": "Progress", "styleClass": "in-progress-date", "name":"Live","id":"inProgress","val":"#7ab0db","textcolour":"","order":1},
        		{"label": "Review", "styleClass": "review-date", "name":"Review Date","id":"review","val":"<xsl:value-of select="$reviewDateColour"/>","textcolour":"","order":2},
				{"label": "Cancel", "styleClass": "min-cancel-date", "name":"Min Cancel Date","id":"cancel","val":"<xsl:value-of select="$cancelNoticeDateColour"/>","textcolour":"","order":2},
				{"label": "Renew", "styleClass": "end-date", "name":"End Date","id":"end","val":"<xsl:value-of select="$renewalDateColour"/>","textcolour":"","order":2}
			]
			var datesJSON=[];
			var yearsJSON=[];
        	var outlookStartDate = moment().format('YYYY-MM-DD');
        	//var outlookStartDate = moment().format('YYYY-MM-DD');
            var monthsJSON=["J","F","M","A","M","J","J","A","S","O","N","D"];
            var startyear= new Date(new Date(outlookStartDate).getFullYear(), 0, 1).getTime(); 				
  			var yearCount=3;
  			var outlookStart = 450;
  			var svg;
  			var outlookRowCount;
  			var solutionOutlookData;
  			var contractOutlookData;
  			const NAME_SORT_ORDER = "name";
  			const REVIEW_SORT_ORDER = "review";
  			const CANCEL_SORT_ORDER = "cancel";
  			const RENEW_SORT_ORDER = "end";
  			var outlookSortOrder = RENEW_SORT_ORDER;
  			
  			
  			function sortOutlookEntries(entries) {
  				if (!Array.isArray(entries) || entries.length === 0) {
  					return;
  				}

  				function safeLower(s) {
  					return (s &amp;&amp; typeof s === 'string') ? s.toLowerCase() : '';
  				}

  				function cmpName(a, b) {
  					const an = safeLower(a.name);
  					const bn = safeLower(b.name);
  					if (an &lt; bn) return -1;
  					if (an > bn) return 1;
  					return 0;
  				}

  				function getDateKey(row, key) {
  					if (!row || !row.earliestDates) return null;
  					const v = row.earliestDates[key];
  					return (typeof v === 'string' &amp;&amp; v.length) ? v : null;
  				}

  				if (outlookSortOrder === NAME_SORT_ORDER) {
  					entries.sort(cmpName);
  					return;
  				}

  				// Date-based sort: entries with a valid date for the selected key come first,
  				// then those without (e.g., parent header rows)
 				entries.sort(function(a, b) {
 					const ad = getDateKey(a, outlookSortOrder);
 					const bd = getDateKey(b, outlookSortOrder);

  					if (ad &amp;&amp; bd) {
  						if (ad &lt; bd) return -1;
  						if (ad > bd) return 1;
  						// tie-breaker by name
  						return cmpName(a, b);
  					}
  					if (ad &amp;&amp; !bd) return -1; // a has a date, b doesn't => a first
  					if (!ad &amp;&amp; bd) return 1;  // b has a date, a doesn't => b first
  					// neither has a date (likely parent rows) => name
 					return cmpName(a, b);
 				});
 			}
 			
  			
  			
			function getRenewalSeverity(renewalDate) {
				if(!renewalDate) return null;
				const target = Date.parse(renewalDate);
				if(!Number.isFinite(target)) return null;
				const diffDays = (target - Date.now()) / 86400000;
				if (diffDays &lt;= 90) return 'critical';
				if (diffDays &lt;= 180) return 'warning';
				return null;
			}
function parseDateToMillis(value) {
  				if (!value) {
  					return null;
  				}
  				const ts = Date.parse(value);
  				return Number.isFinite(ts) ? ts : null;
  			}

  			function getLifecycleBoundary(row, targetId) {
  				if (!row) {
  					return null;
  				}
  				if (row.earliestDates &amp;&amp; row.earliestDates[targetId]) {
  					return row.earliestDates[targetId];
  				}
  				const lifecycle = Array.isArray(row.lifecycle) ? row.lifecycle : [];
  				for (let i = 0; i &lt; lifecycle.length; i++) {
  					const entry = lifecycle[i];
  					if (entry &amp;&amp; entry.id === targetId &amp;&amp; entry.dateOf) {
  						return entry.dateOf;
  					}
  				}
  				const info = row.info || {};
  				if (targetId === 'start') {
  					if (info.startDate) return info.startDate;
  					if (info.contract &amp;&amp; info.contract.startDate) return info.contract.startDate;
  				} else if (targetId === 'end') {
  					if (info.renewalDate) return info.renewalDate;
  					if (info.contract &amp;&amp; info.contract.renewalDate) return info.contract.renewalDate;
  				}
  				return null;
  			}

  			function overlapsRange(row, rangeStartTs, rangeEndTs) {
  				const startStr = getLifecycleBoundary(row, 'start');
  				const endStr = getLifecycleBoundary(row, 'end');

  				let rowStartTs = parseDateToMillis(startStr);
  				let rowEndTs = parseDateToMillis(endStr);

  				if (rowStartTs == null &amp;&amp; rowEndTs == null) {
  					return false;
  				}

  				if (rowStartTs == null) {
  					rowStartTs = rowEndTs;
  				}

  				if (rowEndTs == null || (rowStartTs != null &amp;&amp; rowEndTs &lt; rowStartTs)) {
  					rowEndTs = Number.POSITIVE_INFINITY;
  				}

  				if (!Number.isFinite(rangeStartTs) || !Number.isFinite(rangeEndTs)) {
  					return true;
  				}

  				return rowStartTs &lt;= rangeEndTs &amp;&amp; rowEndTs &gt;= rangeStartTs;
  			}
  			
  			
  			
  			function setContractEarliestLifecycleDates(aContract) {
				const earliest = { start: null, review: null, cancel: null, end: null };
				const bestTs   = { start: Infinity, review: Infinity, cancel: Infinity, end: Infinity };
				const TARGETS  = new Set(['start', 'review', 'cancel', 'end']);

				const items = aContract &amp;&amp; Array.isArray(aContract.lifecycle) ? aContract.lifecycle : [];
				for (let i = 0; i &lt; items.length; i++) {
					const e = items[i];
					const id = e &amp;&amp; e.id;
					if (!TARGETS.has(id)) continue;

					const d = e.dateOf;
					if (d == null) continue;

					// Convert once to a number for fast comparisons; accept numbers or date strings.
					const t = typeof d === 'number' ? d : Date.parse(d);
					if (!Number.isFinite(t)) continue;
 
					if (t &lt; bestTs[id]) {
					bestTs[id] = t;
					earliest[id] = d; // keep original representation
					}
				}

				aContract.earliestDates = earliest;
				return earliest;
			}
			
			
			function getSupplierEarliestLifecycleDates(contractList) {
				const earliest = { start: null, review: null, cancel: null, end: null };
				const bestTs   = { start: Infinity, review: Infinity, cancel: Infinity, end: Infinity };

				if (!Array.isArray(contractList) || contractList.length === 0) return earliest;

				for (let i = 0; i &lt; contractList.length; i++) {
					const lifecycle = contractList[i] &amp;&amp; Array.isArray(contractList[i].lifecycle)
					? contractList[i].lifecycle
					: [];

					for (let j = 0; j &lt; lifecycle.length; j++) {
					const e = lifecycle[j];
					const id = e &amp;&amp; e.id;
					// Fast membership test without allocating a Set
					if (id !== 'start' &amp;&amp; id !== 'review' &amp;&amp; id !== 'cancel' &amp;&amp; id !== 'end') continue;

					const d = e.dateOf;
					if (d == null) continue;

					const t = typeof d === 'number' ? d : Date.parse(d);
					if (!Number.isFinite(t)) continue;

					if (t &lt; bestTs[id]) {
						bestTs[id] = t;
						earliest[id] = d; // retain original value (string/number/Date)
					}
					}
				}

				return earliest;
			}
  			
  			
  			function getEarliestLifecycleDates(aContract) {
				const earliest = { start: null, review: null, cancel: null, end: null };
				const bestTs   = { start: Infinity, review: Infinity, cancel: Infinity, end: Infinity };

				const items = aContract &amp;&amp; Array.isArray(aContract.lifecycle) ? aContract.lifecycle : [];
				for (let i = 0; i &lt; items.length; i++) {
					const entry = items[i];
					const id = entry &amp;&amp; entry.id;
					// Only track these statuses
					if (id !== 'start' &amp;&amp; id !== 'review' &amp;&amp; id !== 'cancel' &amp;&amp; id !== 'end') continue;

					const d = entry.dateOf;
					if (d == null) continue;

					// Normalise to a numeric timestamp once
					const ts = typeof d === 'number'
					? d
					: (d instanceof Date ? d.getTime() : Date.parse(d));

					if (!Number.isFinite(ts)) continue;

					if (ts &lt; bestTs[id]) {
					bestTs[id] = ts;
					earliest[id] = d; // keep original representation (string/Date/number)
					}
				}

				aContract.earliestDates = earliest;
				return earliest;
			}
			function markContractSeverity(contract) {
				const severity = getRenewalSeverity(contract.renewalDate);
				contract.renewalSeverity = severity;
				return severity;
			}

			function markContractComponentSeverity(component) {
				const severity = getRenewalSeverity(component.renewalDate || (component.contract &amp;&amp; component.contract.renewalDate));
				component.renewalSeverity = severity;
				return severity;
			}

			function applyRenewalSeverityFlags() {
				(viewData.contracts || []).forEach(function(contract){
					markContractSeverity(contract);
					(contract.contractComps || []).forEach(function(cc){
						markContractComponentSeverity(cc);
					});
				});

				(viewData.contractSuppliers || []).forEach(function(supplier){
					let hasCritical = false;
					let hasWarning = false;

					(supplier.contracts || []).forEach(function(contract){
						const severity = markContractSeverity(contract);
						if (severity === "critical") {
							hasCritical = true;
						} else if (severity === "warning") {
							hasWarning = true;
						}

						(contract.contractComps || []).forEach(function(cc){
							const ccSeverity = markContractComponentSeverity(cc);
							if (ccSeverity === "critical") {
								hasCritical = true;
							} else if (ccSeverity === "warning") {
								hasWarning = true;
							}
						});
					});

					if (hasCritical) {
						supplier.renewalSeverity = "critical";
					} else if (hasWarning) {
						supplier.renewalSeverity = "warning";
					} else {
						supplier.renewalSeverity = null;
					}
				});

				(viewData.solutionProviders || []).forEach(function(provider){
					let hasCritical = false;
					let hasWarning = false;

					(provider.contracts || []).forEach(function(contract){
						const severity = markContractSeverity(contract);
						if (severity === "critical") {
							hasCritical = true;
						} else if (severity === "warning") {
							hasWarning = true;
						}

						(contract.contractComps || []).forEach(function(cc){
							const ccSeverity = markContractComponentSeverity(cc);
							if (ccSeverity === "critical") {
								hasCritical = true;
							} else if (ccSeverity === "warning") {
								hasWarning = true;
							}
						});
					});

					if (hasCritical) {
						provider.renewalSeverity = "critical";
					} else if (hasWarning) {
						provider.renewalSeverity = "warning";
					} else {
						provider.renewalSeverity = null;
					}
				});
			}

function getContractOutlookDates(aContract) {
  				let outlookDates = [];
  				let renewalDateStr = aContract.renewalDate;
  				let startDateStr = aContract.startDate;
  				if(startDateStr != null) {
  					outlookDates.push({
  						"id": "start",
  						"dateOf": startDateStr
  					});
  				}

  				if(renewalDateStr != null) {
  					let noticeDateMoment, noticeDateStr, reviewDateMoment, reviewDateStr;
  					if(aContract.renewalNoticeDays > 0) {
  						noticeDateMoment = moment(renewalDateStr).subtract(aContract.renewalNoticeDays, 'days');
  						noticeDateStr = noticeDateMoment.format('YYYY-MM-DD');
  					}
  					if(aContract.renewalReviewDays > 0) {
  						if(noticeDateMoment != null) {
  							reviewDateMoment = moment(noticeDateStr).subtract(aContract.renewalReviewDays, 'days');
  						} else {
  							reviewDateMoment = moment(renewalDateStr).subtract(aContract.renewalReviewDays, 'days');
  						}
  						reviewDateStr = reviewDateMoment.format('YYYY-MM-DD');
  						outlookDates.push({
  							"id": "review",
  							"dateOf": reviewDateStr
  						});
  						if(noticeDateMoment != null) {
  							outlookDates.push({
	  							"id": "cancel",
	  							"dateOf": noticeDateStr
	  						});
  						}
  					}
  					outlookDates.push({
  						"id": "end",
  						"dateOf": renewalDateStr
  					});	
  				}
  				return outlookDates;
  			}
  			
  			
  			
  			<!--function getContractOutlookDates(aCostComp) {
  				let outlookDates = [];
  				let renewalDateStr = aCostComp.renewalDate;
  				if(renewalDateStr == null &amp;&amp; aCostComp.contract != null) {
  					renewalDateStr = aCostComp.contract.renewalDate;
  				}
  				if(renewalDateStr != null) {
  					let noticeDateMoment, noticeDateStr, reviewDateMoment, reviewDateStr;
  					if(aCostComp.renewalNoticeDays > 0) {
  						noticeDateMoment = moment(renewalDateStr).subtract(aCostComp.renewalNoticeDays, 'days');
  						noticeDateStr = noticeDateMoment.format('YYYY-MM-DD');
  					}
  					if(aCostComp.renewalReviewDays > 0) {
  						if(noticeDateMoment != null) {
  							reviewDateMoment = moment(noticeDateStr).subtract(aCostComp.renewalReviewDays, 'days');
  						} else {
  							reviewDateMoment = moment(renewalDateStr).subtract(aCostComp.renewalReviewDays, 'days');
  						}
  						reviewDateStr = reviewDateMoment.format('YYYY-MM-DD');
  						outlookDates.push({
  							"id": "review",
  							"dateOf": reviewDateStr
  						});
  						if(noticeDateMoment != null) {
  							outlookDates.push({
	  							"id": "cancel",
	  							"dateOf": noticeDateStr
	  						});
  						}
  					}
  					outlookDates.push({
  						"id": "end",
  						"dateOf": renewalDateStr
  					});	
  				}
  				return outlookDates;
  			}-->
			
			
  			//function to initialise the outlook data for a solution
  			function setSolutionOutlookData(solutions, dataSet) {
  				solutions.filter(function(solution) {
  					return solution.contractComps.length > 0;
  				})
  				.forEach(function(aSol) {
  					let solutionData = {
  						"id": aSol.id,
  						"name": aSol.name,
  						"link": aSol.link,
  						"lifecycles": [],
  						"info": aSol
  					}
  					if(aSol.supplier != null) {
  						solutionData.name = aSol.supplier.name + ' ' + aSol.name;
  						solutionData.link = aSol.supplier.link + ' ' + aSol.link;
  					}
  					aSol.contractComps.filter(function(aCostComp) {
	  					return (aCostComp.renewalDate != null) || ((aCostComp.contract != null) &amp;&amp; (aCostComp.contract.renewalDate != null));
	  				})
	  				.forEach(function(aCC) {
	  					let ccData = {
	  						"id": aCC.id,
	  						"name": aCC.contract.description,
	  						"link": aCC.contract.description,
	  						"lifecycle": [],
	  						"info": aCC
	  					}
	  					if(aCC.supplier != null) {
	  						ccData.name = aCC.supplier.name + ' - '  + aCC.contract.description;
	  						ccData.link = aCC.supplier + ' - '  + aCC.contract.description;
	  					}
	  					ccData.lifecycle = getContractOutlookDates(aCC);
	  					solutionData.lifecycles.push(ccData);
	  				});
	  				solutionData.earliestDates = getEarliestLifecycleDates(solutionData.lifecycles);
	  				dataSet.push(solutionData);
  				});
  			}
  			
  			
  			
  			//function to initialise the outlook data for supplier contracts
  			function setSupplierOutlookData(suppliers, dataSet) {
  				suppliers.filter(function(supp) {
  					return supp.contracts.length > 0;
  				})
  				.forEach(function(aSupp) {
  					aSupp.contracts.filter(function(aContract) {
  						if(aContract.renewalDate != null) {
  							return true;
  						}
  						if(aContract.contractComps &amp;&amp; aContract.contractComps.length > 0) {
  							return aContract.contractComps.some(function(aCC) {
  								return aCC.renewalDate != null;
  							});
  						}
  						return false;
  					})
  					.forEach(function(aContract) {
  						let contractName = aSupp.name;
  						if(aContract.description != null &amp;&amp; aContract.description.length > 0) {
  							contractName = contractName + ': ' + aContract.description;
  						}
  						let contractData = {
  							"id": aContract.id,
  							"name": contractName,
  							"supplierName": aSupp.name,
  							"contractName": aContract.description,
  							"link": contractName,
  							"lifecycle": [],
  							"info": aContract,
  							"isComponent": false
  						}
  						// Parent contract header row: show with no timeline bars, always include
  						contractData.lifecycle = [];
  						setContractEarliestLifecycleDates(contractData);
  						dataSet.push(contractData);

  						if(aContract.contractComps &amp;&amp; aContract.contractComps.length > 0) {
  							aContract.contractComps.forEach(function(aCC, compIdx) {
  								const componentLifecycle = getContractOutlookDates(aCC);
  								if(componentLifecycle.length === 0) {
  									return;
  								}

  								const associationGroups = [];
  								// Order: Applications → Processes → Technology
  								if(aCC.apps &amp;&amp; aCC.apps.length > 0) {
  									associationGroups.push({
  										"label": "Applications",
  										"names": aCC.apps.map(function(app) {
  											return app.name;
  										}).filter(Boolean)
  									});
  								}
  								if(aCC.busProcs &amp;&amp; aCC.busProcs.length > 0) {
  									associationGroups.push({
  										"label": "Processes",
  										"names": aCC.busProcs.map(function(bp) {
  											return bp.name;
  										}).filter(Boolean)
  									});
  								}
  								if(aCC.techProds &amp;&amp; aCC.techProds.length > 0) {
  									associationGroups.push({
  										"label": "Technology",
  										"names": aCC.techProds.map(function(tp) {
  											return tp.name;
  										}).filter(Boolean)
  									});
  								}

  								// Detailed label with group labels for tooltips
  								const detailedLabel = associationGroups.map(function(group) {
  									if(!group.names.length) return null;
  									return group.label + ': ' + group.names.join(', ');
  								}).filter(Boolean).join(' | ');

  								// Visible name = just the names in scope (no prefixes, no contract description)
  								const nameOnlyLabel = associationGroups
  									.filter(function(g){ return g.names &amp;&amp; g.names.length; })
  									.map(function(g){ return g.names.join(', '); })
  									.join(' | ');

  								// Fallback if nothing associated
  								const finalLabel = (nameOnlyLabel &amp;&amp; nameOnlyLabel.length > 0)
  									? nameOnlyLabel
  									: (aCC.licenseModel || 'Component');

  								let componentData = {
  									"id": aCC.id,
  									// Name/Link are the in-scope Apps/Processes/Technology only
  									"name": finalLabel,
  									"link": finalLabel,
  									"supplierName": aSupp.name,
  									"contractName": aContract.description,
  									"componentLabel": finalLabel,
  									"componentDetails": detailedLabel,
  									"lifecycle": componentLifecycle,
  									"info": aCC,
  									"isComponent": true,
  									"parentContractId": aContract.id
  								}
  								setContractEarliestLifecycleDates(componentData);
  								dataSet.push(componentData);
  							});
  						}
  					});
  				});
  			}
  			
  			
  			
  			<!--//function to initialise the outlook data for a solution
  			function setContractOutlookData(contracts, dataSet) {
  				contracts.filter(function(contract) {
  					return contract.contractComps.length > 0;
  				})
  				.forEach(function(aContract) {
  					let contractData = {
  						"id": aContract.id,
  						"name": aContract.description,
  						"link": aContract.description,
  						"lifecycles": [],
  						"info": aContract
  					}
  					if(aContract.supplier != null) {
  						contractData.name = aContract.supplier.name + ' ' + aContract.description;
  						contractData.link = aContract.supplier.link + ' ' + aContract.description;
  					}
  					aContract.contractComps.filter(function(aCostComp) {
	  					return (aCostComp.renewalDate != null) || (aCostComp.contract.renewalDate != null);
	  				})
	  				.forEach(function(aCC) {
	  					let ccSolutions = aCC.busProcs.concat(aCC.apps).concat(aCC.techProds);
	  					ccSolutions.forEach(function(aSol) {
		  					let ccData = {
		  						"id": aSol.id,
		  						"name": aSol.name,
		  						"link": aSol.link,
		  						"lifecycle": [],
		  						"info": aSol
		  					}
		  					if(aSol.supplier != null) {
		  						ccData.name = aSol.supplier.name + ' '  + aSol.name;
		  						ccData.link = aSol.supplier.link + ' '  + aSol.link;
		  					}
		  					ccData.lifecycle = getContractOutlookDates(aCC);
		  					contractData.lifecycles.push(ccData);
	  					});
	  				});
	  				contractData.earliestDates = getEarliestLifecycleDates(contractData.lifecycles);
	  				dataSet.push(contractData);
  				});
  			}-->
  			
  			
  			function initOutlookData() {
  				solutionOutlookData = [];
  				setSolutionOutlookData(viewData.busProcesses, solutionOutlookData);
  				setSolutionOutlookData(viewData.applications, solutionOutlookData);
  				setSolutionOutlookData(viewData.techProducts, solutionOutlookData);
  				
  				contractOutlookData = [];
  				let validSuppliers = viewData.contractSuppliers.filter(function(aSupp) {
  					return (aSupp.contracts != null) &amp;&amp; (aSupp.contracts.length > 0);
  				});
				setSupplierOutlookData(validSuppliers, contractOutlookData);
				applyRenewalSeverityFlags();
 				<!--setContractOutlookData(viewData.contracts, contractOutlookData);-->
  				
  				<!--console.log('Solution Outlook Data');
  				console.log(solutionOutlookData);
  				
  				console.log('Contract Outlook Data');
  				console.log(contractOutlookData);-->
  			}
  			
  			
  			
  			
  			//function to refresh the outlook map
			function createMap(allRowJSON) {
  
  				// Build the working set, keeping parents with no bars above their children
  				let dataset = allRowJSON;
  
  				// Text filter (match several fields so children can pull in their parent)
  				let textVal = $('#outlookSupplierFilter').val().toLowerCase();
  				let filteredByText = dataset;
  				if(textVal.length > 0) {
  					filteredByText = dataset.filter(function(row) {
  						return (row.name &amp;&amp; row.name.toLowerCase().includes(textVal))
  							|| (row.supplierName &amp;&amp; row.supplierName.toLowerCase().includes(textVal))
  							|| (row.contractName &amp;&amp; row.contractName.toLowerCase().includes(textVal))
  							|| (row.componentLabel &amp;&amp; row.componentLabel.toLowerCase().includes(textVal));
  					});
  				}
  
  				// Date range
  				let selectedStart = $('#outlookStartPicker').val() + '-01-01';
  				let outlookCount = $('#outlookYears').val();
  				let selectedEnd = moment(selectedStart).add(outlookCount, 'years').format('YYYY-MM-DD');
  				const rangeStartTs = parseDateToMillis(selectedStart);
  				const rangeEndTs = parseDateToMillis(selectedEnd);
  
  				function getSortDateValue(row, sortKey) {
  					if (!row || !row.earliestDates) {
  						return null;
  					}
  					const dateVal = row.earliestDates[sortKey];
  					if (typeof dateVal === 'string' &amp;&amp; dateVal.length > 0) {
  						return dateVal;
  					}
  					if (sortKey !== RENEW_SORT_ORDER) {
  						const fallback = row.earliestDates[RENEW_SORT_ORDER];
  						if (typeof fallback === 'string' &amp;&amp; fallback.length > 0) {
  							return fallback;
  						}
  					}
  					return null;
  				}
  
  				function compareByDateThenName(a, b) {
  					const ad = getSortDateValue(a, outlookSortOrder);
  					const bd = getSortDateValue(b, outlookSortOrder);
  
  					if (ad &amp;&amp; bd) {
  						const cmp = ad.localeCompare(bd);
  						if (cmp !== 0) {
  							return cmp;
  						}
  					} else if (ad &amp;&amp; !bd) {
  						return -1;
  					} else if (!ad &amp;&amp; bd) {
  						return 1;
  					}
  
  					const an = (a.name || '').toLowerCase();
  					const bn = (b.name || '').toLowerCase();
  					return an.localeCompare(bn);
  				}
  
  				// If this dataset contains component rows, group under parents and ensure ordering: parent (no bars) then components
  				const isContractMode = filteredByText.some(function(r){ return typeof r.isComponent !== 'undefined'; });
  				let rowJSON = [];
  
  				if (isContractMode) {
  					// Children (components) that are within range
  					const childrenInRange = filteredByText.filter(function(r) {
  						return r.isComponent &amp;&amp; overlapsRange(r, rangeStartTs, rangeEndTs);
  					});
  
  					// Group children by parent id
  					const byParent = {};
  					childrenInRange.forEach(function(c) {
  						const pid = c.parentContractId;
  						if(!byParent[pid]) { byParent[pid] = []; }
  						byParent[pid].push(c);
  					});
  
  					// Build groups with a sort key (min child date) and sort children according to current order
  					const groups = Object.keys(byParent).map(function(pid) {
  						const parent = dataset.find(function(row){ return !row.isComponent &amp;&amp; row.id === pid; });
  						const kids = byParent[pid];
  
  						if (outlookSortOrder === NAME_SORT_ORDER) {
  							kids.sort(function(a,b){ return (a.name || '').toLowerCase().localeCompare((b.name || '').toLowerCase()); });
  						} else {
  							kids.sort(compareByDateThenName);
  						}
  
  						const key = kids.reduce(function(min, c){
  							const candidate = getSortDateValue(c, outlookSortOrder) || getSortDateValue(c, RENEW_SORT_ORDER);
  							if (!min) {
  								return candidate;
  							}
  							if (candidate &amp;&amp; candidate &lt; min) {
  								return candidate;
  							}
  							return min;
  						}, null);
  
  						return { parent: parent, children: kids, sortKey: key };
  					});
  
  					// Sort parent groups
  					if (outlookSortOrder === NAME_SORT_ORDER) {
  						groups.sort(function(g1, g2) {
  							const n1 = (g1.parent &amp;&amp; g1.parent.name || '').toLowerCase();
  							const n2 = (g2.parent &amp;&amp; g2.parent.name || '').toLowerCase();
  							return n1.localeCompare(n2);
  						});
  					} else {
  						groups.sort(function(g1, g2) {
  							if (!g1.sortKey &amp;&amp; !g2.sortKey) return 0;
  							if (!g1.sortKey) return 1;
  							if (!g2.sortKey) return -1;
  							return g1.sortKey.localeCompare(g2.sortKey);
  						});
  					}
  
  					// Flatten: parent first (no timeline), then its components
  					groups.forEach(function(g){
  						if (g.parent) { rowJSON.push(g.parent); }
  						Array.prototype.push.apply(rowJSON, g.children);
  					});
  
  				} else {
  					// Original behaviour for solution-based outlook
  					rowJSON = filteredByText.filter(function(aRow) {
  						return overlapsRange(aRow, rangeStartTs, rangeEndTs);
  					});
  				}
  
  			    var showList = [];
  			    let rowPos = 1;
  			    startyear= new Date(new Date(outlookStartDate).getFullYear(), 0, 1).getTime(); 

		    	let productJSON = rowJSON;
			    
			    for (i = 0; i &lt; productJSON.length; i++) {
			
					let productRowPos = rowPos;
					let productRowId = 'prod' + productRowPos;
					let thisProd = productJSON[i];
			        var lifeVal = [];
			        // Build bars only when lifecycle data exists (parents have none)
			        var lifeArr = (thisProd.lifecycle || []).slice();
			        var lifeLength = lifeArr.length;
			        var startingPosition = 0;
			        var startYearPos = 0;

			        if (lifeLength &gt; 0) {
			            // sort descending by date so the last item is the renewal/end date
			            lifeArr.sort(function(a, b) { return b.dateOf.localeCompare(a.dateOf); });
			            var endDate = lifeArr[lifeArr.length - 1];
			            
			            var startYearPos = new Date(endDate.dateOf).getTime();
			            var startingPosition = ((startYearPos - startyear) / 86400000) * dayMultipler;

			            for (j = 0; j &lt; lifeLength; j++) {
			                var width, previousDay;
			                var life = lifeColourJSON.filter(function (d) {
			                    return d.id == lifeArr[j].id;
			                });

			                var thisLabel = lifeArr[j].label;
			                var thisDateStr = lifeArr[j].dateOf;
			                var displayDate = moment(thisDateStr).format('Do MMM YYYY');
			                var originalDate = new Date(thisDateStr).getTime();
			                var thisDate = originalDate;
			                var barId = productRowId + j;
			       
			                var startPosforBar = ((thisDate - startYearPos) / 86400000) * dayMultipler;
			                
			                if (lifeArr[j - 1]) {     				            	
			                    previousDay = new Date(lifeArr[j - 1].dateOf).getTime();
			                    width = ((previousDay - thisDate) / 86400000) * dayMultipler;
			                } else {
			                    width = 2;
							}
			 
			                lifeVal.push({"label": thisProd.name + ': ' + life[0].label, "barId": barId, "id": life[0].id, "life": life[0].name, "displayDate": displayDate, "width": width, "styleClass": life[0].styleClass, "colour": life[0].val, "pos": rowPos, "startPosition": startPosforBar, "exactStart": startingPosition});
			            }
			        }
			        showList.push({
						"pos": productRowPos,
						// Use the visible row name (Apps/Processes/Tech for components; contract title for parent)
						"product": thisProd.name,
						// For popover: labelled list like "Applications: … | Processes: … | Technology: …"
						"details": thisProd.componentDetails || '',
						"isComponent": !!thisProd.isComponent,
						"supplierName": thisProd.supplierName,
						"contractName": thisProd.contractName,
						"id": thisProd.id,
						"info": thisProd.info,
						"lifecycles": lifeVal
						});	
			        rowPos++;
			 } 		

			//console.log(showList)
			 
			var productlines = svg.selectAll("#box")
	        .data(showList)
	        .enter()
	        .append("g")
	        .selectAll('.timeitem')
	        .data(function(d) {
	            return d.lifecycles;
	         })
	        .enter()
	        .append("rect")
	        .attr("class", function(d) {
	            return "timeitem item timeline-bar " + d.styleClass;
	        })
	        .attr("rx", 6)
	        .attr("ry", 6)
	        .attr("y", function(d, i) {
	            ys = d.pos;
	            return (((ys + 1) * 22) - 35) 
	        })
	        .attr("x", function(d) {	            
	            return outlookStart + 5 +d.startPosition+d.exactStart;
	         })
	        .attr("height", (1))
	        .attr("width", function(d, i) {    
	            wd = d.width;
	            if (wd &lt; 1) {
	                wd = 0
	            };
	            return wd
	        })
	        .style("fill", function(d) {
	            var baseColour = d.colour || '#c4c4c4';
	            try {
	            	return d3.rgb(baseColour).brighter(0.2).toString();
	            } catch(err) {
	            	return baseColour;
	            }
	        })
	        .style("stroke", function(d) {
	            var baseColour = d.colour || '#a0a0a0';
	            try {
	            	return d3.rgb(baseColour).darker(0.6).toString();
	            } catch(err) {
	            	return baseColour;
	            }
	        })
	        .style("stroke-width", .8)
	        .style("opacity", function(d){
	        	return d.width &lt; 6 ? 0.85 : 0.95;
	        })
	        .style("filter","url(#timelineGlow)")
	        .on("mouseover", handleMouseOver)
            .on("mouseout", handleMouseOut);
			
			
			 
			 var headingBackground = svg
			 	.append("g")
			 	.append("rect")
		        .attr("y", 0)
		        .attr("x", 0)
		        .attr("height", svgHeight)
		        .attr("width", 450)
		        .style("fill", '#fff');
			 
			 
			 <!--console.log('Outlook Data:');
			 console.log(groupList);-->
			 <!--var grouptext = svg.selectAll("#box")
		        .data(groupList)
		        .enter()
		        .append("foreignObject")
				.attr("y", (function(d, i) {
		            return ((d.pos + 1) * 22) + 5
		        }))
		        .attr("x", 10)
			    .attr('width', 440)
				.attr('height', 20)
				.append('xhtml').html(function(d) {
					if(outlookSupplierMode == PRODUCT_SUPPLIER_MODE) {
						//show the solution template
						return outlookSolutionTemplate(d);
					} else {
						//show the supplier template
						return outlookSupplierTemplate(d);
					}
				 });-->
			 
			 //console.log('Printing rows: ');
			 //console.log('CONTRACT LIST');
			 //console.log(showList);
			 var producttext = svg.selectAll("#box")
	        .data(showList)
	        .enter()
	        .append("foreignObject")
				.attr("y", (function(d, i) {
		            ys = d.pos;
	            	return (((ys + 1) * 22) - 38)
		        }))
		        .attr("x", 10)
			    .attr('width', 410)
				.attr('height', 24)
				.append('xhtml').html(function(d) {
					
					var cancelDate = d.lifecycles.find((d)=>{return d.id=='cancel' || null});
					var renewDate = d.lifecycles.find((d)=>{return d.id=='review' || null});
		
					var cancelLozenge = cancelDate ? '<span class="timeline-lozenge cancel">'+ cancelDate.displayDate +'</span>' : '';
					var renewalLozenge = renewDate ? '<span class="timeline-lozenge renewal">'+ renewDate.displayDate +'</span>' : '';
					d['lifeDate']=  renewalLozenge + cancelLozenge;
					return '<div class="timeline-row-label">'+outlookContractTemplate(d)+'</div>';
					<!--if(outlookSupplierMode == PRODUCT_SUPPLIER_MODE) {
						//show the contract template
						return outlookContractTemplate(d);
					} else {
						return outlookSolutionTemplate(d);
					}-->
				 });
		        <!--.append("svg:a")
		        .attr("xlink:href", function(d) {
		            return 'report?XML=reportXML.xml&amp;PMA=' + d.id + '&amp;cl=en-gb&amp;XSL=technology/core_tl_tech_prod_summary.xsl';
		        })-->
		        <!--.append("text")
		        .attr("y", (function(d, i) {
		            return ((d.pos + 1) * 22) + 20
		        }))
		        .attr("x", 40)
		        .attr("class", "headerText item")
		        .text(function(d) {
		            var EOL = [];
		            d.lifecycles.filter(function(e) {
		                ;
		                if (e.date &gt; - 1) {
		                    EOL.push(e.date)
		                }
		            });
		            if (EOL.length === 0) {
		                return d.product
		            } else {
		                return d.product
		            };
		        })
		        .style("fill", function(d) {
		            var EOL = [];
		            d.lifecycles.filter(function(e) {
		                ;
		                if (e.date &gt; - 1) {
		                    EOL.push(e.date)
		                }
		            });
		            if (EOL.length === 0) {
		                return '#ac2323'
		            } else {
		                return '#000000'
		            };
		        });-->
			
			    for(i=0;i&lt;yearsJSON.length;i++){ 
				var yearlines = svg.selectAll("#box").data(yearsJSON)
                    .enter()
					.append("line")
					.attr("class", function(d) {
							return d;
						})
					.attr("x1",(function(d,i){var setSpace=yearSpacing*i;var calcyear= new Date(d+'-1-1').getTime()-startyear;

						return setSpace+outlookStart+3}))
					.attr("x2",(function(d,i){var setSpace=yearSpacing*i;var calcyear= new Date(d+'-1-1').getTime()-startyear;
               
                        return setSpace+outlookStart+3}))
                    .attr("y1",0)
                    .attr("y2", svgHeight)
					.style("stroke", "#898989")
					.style("stroke-width", 1)
					.style("stroke-dasharray", "4")
                    }   

				let getToday=new Date().getTime();

				startyear
				let todaystartPosforBar=(((getToday-startyear)/86400000)*dayMultipler)+outlookStart;
	
				let todayArr=[]; 
				todayArr.push({"today":todaystartPosforBar});
				yearlines = svg.selectAll("#box").data(todayArr)
                    .enter()
					.append("line")
					.attr("class", function(d) {
							return d;
						})
					.attr("x1",(function(d,i){var setSpace=yearSpacing*i;var calcyear= new Date(d).getTime();
		 
						return (d.today)+3}))
					.attr("x2",(function(d,i){var setSpace=yearSpacing*i;var calcyear= new Date(d).getTime()-startyear;		
						return (d.today)+3}))
                    .attr("y1",0)
                    .attr("y2", svgHeight)
					.style("stroke", "red")
					.style("stroke-width", 1)
					.style("stroke-dasharray", "2");
                       

			    d3.selectAll(".timeitem")
			        .transition()
			        .duration(500)
			        .attr("height", 12)
			        .attr("y", function(d) {
			        	var baseY = (((d.pos + 1) * 22) - 35);
			        	return baseY - 5;
			        });
			        
		        initOutlookPopovers();
			
			}
			
			// Initialise popovers with a single set of handlers
				function initOutlookPopovers() {
					// Clean previous instances and handlers, then bind fresh ones
					$('.view-popover').off('.outlookPopover').popover('destroy');
					$('[role="tooltip"]').remove();
					$('body').off('.outlookPopover');

					$('body').on('click.outlookPopover', function (e) {
						if ($(e.target).data('toggle') !== 'popover'
							&amp;&amp; $(e.target).parents('.popover.in').length === 0) {
							$('[data-toggle="popover"]').popover('hide');
						}
					});

					$('.view-popover')
						.off('.outlookPopover')
						.on('click.outlookPopover', function(evt) {
							$('[role="tooltip"]').remove();
							evt.stopPropagation();
						})
						.popover({
							container: 'body',
							html: true,
							trigger: 'click',
							placement: 'auto',
							content: function(){
								return $(this).siblings('.popover').first().html();
							}
						});
				}
			
			  // Create Event Handlers for mouse
	          function handleMouseOver(d, i) {  // Add interactivity			
				var coordinates= d3.mouse(this);
				var xPos = coordinates[0];
				var yPos = coordinates[1];
				//console.log('Mouse Over');
				//console.log(d.barId);
				
	            // Specify where to put label of text
	            let toolTip = svg.append("text")
	            .attr("id", function() {
	            	return "tt" + d.barId;
	            })
	            .attr("x", function() {
	            	return xPos - 200;
	            })
	            .attr("y", function() {
	            	return yPos + 15;
	            })
	            .text(function() {
	              return d.label + " before " + d.displayDate;  // Value of the text
	            });
	            //console.log(toolTip.attr('id'));
	          }
	          
	          function handleMouseOut(d, i) {
				//console.log('Mouse Out');
				//console.log(d.barId);
	            // Select text by id and then remove
	            d3.select("#tt" + d.barId).remove();  // Remove text location
	          }
    	
    		
    		var svgHeight=<xsl:value-of select="$contractRowCount * 22"/>;
            var svgWidth=1400;
    	
        	//function to update the outlook
        	function updateOutlook(productJSON) {
        		if(outlookSortOrder == null) {
        			outlookSortOrder = RENEW_SORT_ORDER;
        		}
        		// Reset mutable state between renders to avoid growth and stale handlers
        		yearsJSON.length = 0;
        		datesJSON.length = 0;
        		$('.view-popover').popover('destroy');
        		$('[role="tooltip"]').remove();
        		$('body').off('.outlookPopover');
        		sortOutlookEntries(productJSON);
        		d3.select("svg").remove();
        		
        		//console.log('Updating the Outlook: ' + outlookStartDate);
        		datesJSON = [];

        		let thisyear=new Date(outlookStartDate).getFullYear();
	
				let yc = Number(yearCount);
                for(i=0;i&lt;yc+1;i++){     
					datesJSON.push(thisyear);
					yearsJSON.push(thisyear);
                    thisyear=thisyear+1;
                }
		
                datesJSON["months"]=monthsJSON;
                //console.log(datesJSON)
                
                /* set svg height */
                //svgHeight=productJSON.length *30+30;
                
                

                <!-- calculate year gaps -->
                yearSpacing=(svgWidth-outlookStart)/(datesJSON.length-1);
                dayMultipler=yearSpacing/365.25;
                //console.log(dayMultipler+":"+yearSpacing);

    			$('#lfHeader').html('');
    			$('#box').html('');
                var headerContainer = d3.select("#lfHeader");
				let cancelText = "<xsl:value-of select="eas:i18n('Last Cancellation Date')"/>";
				let renewalText = "<xsl:value-of select="eas:i18n('Review Date')"/>";
                var legendItems = [
				{ className: 'renewal', label: renewalText },
                	{ className: 'cancel', label: cancelText }
                ];
                var legend = headerContainer.append("div")
                     .attr("class","timeline-key");
                legend.selectAll("span")
                     .data(legendItems)
                     .enter()
                     .append("span")
                     .attr("class", function(d){ return "timeline-lozenge " + d.className; })
                     .text(function(d){ return d.label; });
                svg = d3.select("#box").append("svg")
                        .attr("width",svgWidth)
                        .attr("height", svgHeight)
                        .attr("id","box");  

                var defs = svg.append("defs");
                var glowFilter = defs.append("filter")
                     .attr("id","timelineGlow")
                     .attr("x","-5%")
                     .attr("y","-20%")
                     .attr("width","115%")
                     .attr("height","180%");
                glowFilter.append("feGaussianBlur")
                     .attr("stdDeviation",1.2)
                     .attr("result","coloredBlur");
                var feMerge = glowFilter.append("feMerge");
                feMerge.append("feMergeNode").attr("in","coloredBlur");
                feMerge.append("feMergeNode").attr("in","SourceGraphic");

                     /* add years */
                     
                var headerSvg = headerContainer.append("svg")
                     .attr("width",svgWidth)
                     .attr("height", 30)
                     .attr("id","dateHeader");  
                     
                     /* add years */
					 //console.log('datesJSON');
                //console.log(datesJSON);
                for(i=0;i&lt;datesJSON.length;i++){
                headerSvg.selectAll("#lfHeader")
                    .data(datesJSON)
                    .enter()
                    .append("text")
                    .attr("x",(function(d,i){var setSpace=yearSpacing*i;var calcyear= new Date(d+'-1-1').getTime()-startyear;
                        set=((((((calcyear)/1000)/60)/60)/24));
                        return setSpace+outlookStart}))
                    .attr("y",10)
                    .attr("class", "headerText yrText")
                    .style('font-size',11)
                    .text(function(d){return d})
                    .style("fill", "#898989");;
                    }   
                    
	            for(i=0;i&lt;datesJSON.months.length;i++){
	                for(j=0;j&lt;datesJSON.months.length;j++){
	                headerSvg.selectAll("#lfHeader")
	                    .data(datesJSON.months)
	                    .enter()
	                    .append("text")
	                    .attr("x",(function(d,ind){var setSpace=((yearSpacing/12)*ind)+(yearSpacing*i);
	                        return setSpace+outlookStart}))
	                    .attr("y",20)
	                    .attr("class", "headerText")
	                    .style('font-size',11)
	                    .text(function(d){return d})
	                    .style("fill", "#898989");;
	                }    
	           }
	           
	           createMap(productJSON);
        	
        	}
        	
        	
        	const PRODUCT_SUPPLIER_MODE = 'PRODUCT';
         	const CONTRACT_SUPPLIER_MODE = 'CONTRACT';
         	var supplierMode = CONTRACT_SUPPLIER_MODE;
         	var outlookSupplierMode = CONTRACT_SUPPLIER_MODE;
	    	var outlookContractTemplate, outlookSupplierTemplate;
	    
	        $(document).ready(function() {    
	        	
			Handlebars.registerHelper('formatCurrencyAmount', function (amount, options) {
				if (amount === null || amount === undefined || amount === '') {
	    			return '';
	    		}
	    		const num = toNumber(amount, NaN);
	    		if (!Number.isFinite(num)) {
	    			return amount;
	    		}
	    		const hasFraction = Math.abs(num - Math.trunc(num)) > 0;
	    		return num.toLocaleString(undefined, {
	    			minimumFractionDigits: hasFraction ? 2 : 0,
	    			maximumFractionDigits: 2
	    		});
				
			})
	        	
	        	$('#outlookStartPicker').val(moment(outlookStartDate).format('YYYY'));
	        	$('#outlookStartPicker').yearpicker();	        	
	        	$('#outlookStartPicker').on('hide', function () {
			        let selectedYear = $(this).val();
			        let selectedDate = selectedYear + '-01-01';
			        if (outlookStartDate != selectedDate) {
			        	outlookStartDate = selectedDate;
			        	//updateOutlook(solutionOutlookData);
			        	if(outlookSupplierMode == PRODUCT_SUPPLIER_MODE) {
			           		updateOutlook(solutionOutlookData);
			            } else {
			           		updateOutlook(contractOutlookData);
			            }
			        }
			    });
			    
			    $('#outlookYears').val(yearCount);
			  //  $('#outlookYears').inputSpinner({});
			    
			    $('#outlookYears').on('change', function () {
			        let selectedYears = $(this).val();
					console.log('selectedYears',selectedYears)
					console.log('yearCount',yearCount)
			        if (yearCount != selectedYears) {
			        	yearCount = selectedYears;
			        	if(outlookSupplierMode == PRODUCT_SUPPLIER_MODE) {
			           		updateOutlook(solutionOutlookData);
			            } else {
			           		updateOutlook(contractOutlookData);
			            }
			        	//updateOutlook(solutionOutlookData);
			        }
			    });
	        	
	        
	        	initJSONData();
	        	applyRenewalSeverityFlags();
	        	
	        	//init the Suppliers tab
	        	var solutionSupplierDetailsFragment = $("#solution-provider-summary-template").html();
		        solutionSupplierDetailsTemplate = Handlebars.compile(solutionSupplierDetailsFragment);
		        
	        	var contractSupplierDetailsFragment = $("#contract-supplier-summary-template").html();
		        contractSupplierDetailsTemplate = Handlebars.compile(contractSupplierDetailsFragment);
	        	
	        	var supplierCardFragment = $("#supplier-card-template").html();
		        supplierTemplate = Handlebars.compile(supplierCardFragment);
		        $('#supplierDetailsList').html(supplierTemplate(viewData.contractSuppliers)).promise().done(function(){
	       			registerSupplierListeners();
	       		});
		        
		        $('#productSupplier').on('click', function (evt) {
					if(supplierMode != PRODUCT_SUPPLIER_MODE) {
						supplierMode = PRODUCT_SUPPLIER_MODE;
						$('#supplierSummary').empty(); 
						 
						$('#supplierDetailsList').html(supplierTemplate(viewData.solutionProviders)).promise().done(function(){
							var textVal = $('#supplierFilter').val().toLowerCase();
				            $('.supplier').each(function(i, obj) {
				                 $(this).show();
				                 if(textVal != null) {
				                     var itemName = $(this).text().toLowerCase();
				                     if(!(itemName.includes(textVal))) {
				                         $(this).hide();
				                     }
				                 }
				             });
				             registerSupplierListeners();
						});
					}
				});
				
				$('#contractSupplier').on('click', function (evt) {
					if(supplierMode != CONTRACT_SUPPLIER_MODE) {
						$('#supplierSummary').empty();
						supplierMode = CONTRACT_SUPPLIER_MODE;
						$('#supplierDetailsList').html(supplierTemplate(viewData.contractSuppliers)).promise().done(function(){
							var textVal = $('#supplierFilter').val().toLowerCase();
				            $('.supplier').each(function(i, obj) {
				                 $(this).show();
				                 if(textVal != null) {
				                     var itemName = $(this).text().toLowerCase();
				                     if(!(itemName.includes(textVal))) {
				                         $(this).hide();
				                     }
				                 }
				             });
				             registerSupplierListeners();
						});
					}
				});
	
			   //add event listener for filtering suppliers
			   $('#supplierFilter').on( 'keyup change', function () {
		            var textVal = $(this).val().toLowerCase();
		            $('.supplier').each(function(i, obj) {
		                 $(this).show();
		                 if(textVal != null) {
		                     var itemName = $(this).text().toLowerCase();
		                     if(!(itemName.includes(textVal))) {
		                         $(this).hide();
		                     }
		                 }
		             });
		       });
		       
		       $('#outlookSupplierFilter').on( 'keyup change', function () {
		            let textVal = $(this).val().toLowerCase();
		           
		           if((textVal != null) &amp;&amp; (textVal.length > 0)) {
			           if(outlookSupplierMode == PRODUCT_SUPPLIER_MODE) {
			           		let filteredSolutionData = solutionOutlookData.filter(function(solData) {
			           			let itemName = solData.info.name.toLowerCase();
			           			return itemName.includes(textVal);
			           		});
			           		updateOutlook(filteredSolutionData);
			           } else {
			           		let filteredContractData = contractOutlookData.filter(function(contractData) {
			           			let itemName = contractData.name.toLowerCase();
			           			return itemName.includes(textVal);
			           		});
			           		updateOutlook(filteredContractData);
			           }
		           } else {
			           if(outlookSupplierMode == PRODUCT_SUPPLIER_MODE) {
			           		updateOutlook(solutionOutlookData);
			           } else {
			           		updateOutlook(contractOutlookData);
			           }
		           }
		       });
		       
		       
		       $('#productOutlook').on('click', function (evt) {
					if(outlookSupplierMode != PRODUCT_SUPPLIER_MODE) {
						outlookSupplierMode = PRODUCT_SUPPLIER_MODE;
						sortOutlookEntries(solutionOutlookData);
						$('#outlookSupplierFilter').val('');
						updateOutlook(solutionOutlookData);
					}
				});
				
				$('#contractOutlook').on('click', function (evt) {
					if(outlookSupplierMode != CONTRACT_SUPPLIER_MODE) {
						outlookSupplierMode = CONTRACT_SUPPLIER_MODE;
						sortOutlookEntries(contractOutlookData);
						$('#outlookSupplierFilter').val('');
						updateOutlook(contractOutlookData);
					}
				});
		       
		       var outlookSolutionFragment = $("#outlook-solution-template").html();
		       outlookSolutionTemplate = Handlebars.compile(outlookSolutionFragment);
		       
		       var outlookContractFragment = $("#outlook-contract-template").html();
		       outlookContractTemplate = Handlebars.compile(outlookContractFragment);
		       		       
		       var outlookSupplierFragment = $("#outlook-supplier-template").html();
		       outlookSupplierTemplate = Handlebars.compile(outlookSupplierFragment);
		       
		       registerSortOrderListener();
		        
		       initOutlookData();
	           updateOutlook(contractOutlookData);
	           <!--console.log(viewData);-->	
	    
	                            $('body').on('click', '.toggle-cost-view', function(e) {
	    
	                                e.preventDefault();
	    
	                                var container = $(this).closest('.cost-toggle-container');
	                                var costViews = container.find('.cost-total, .cost-by-currency');
	                                if(costViews.length === 0) {
	                                    costViews = $(this).closest('[class^="col-"]').next().find('.cost-total, .cost-by-currency');
	                                }
	    
	                                costViews.toggle();
	    
	                                if (costViews.filter('.cost-by-currency').is(':visible')) {
										let totText = "<xsl:value-of select="eas:i18n('Show Total')"/>"
	                                    $(this).html(totText + ' <i class="fa fa-toggle-off"></i> ');
	    
	                                } else {
	    								let bdText = "<xsl:value-of select="eas:i18n('Show Breakdown')"/>"
	                                    $(this).html(bdText + ' <i class="fa fa-toggle-on"></i> ');
	    
	                                }
	    
	                            });

	                            let activeDocPopover = null;
	                            function hideDocPopover() {
	                                if(activeDocPopover) {
	                                    activeDocPopover.remove();
	                                    activeDocPopover = null;
	                                }
	                                $('.doc-popover-trigger').removeClass('active');
	                            }

	                            $('body').on('click', '.doc-popover-trigger', function(e) {
	                                e.preventDefault();
	                                let $trigger = $(this);
	                                if($trigger.hasClass('active')) {
	                                    hideDocPopover();
	                                    return;
	                                }
	                                hideDocPopover();
	                                $trigger.addClass('active');
	                                let contentHtml = $trigger.siblings('.doc-popover-list').html() || '<span class="text-muted">No documents</span>';
	                                activeDocPopover = $('<div class="doc-popover-panel"></div>').html(contentHtml);
	                                $('body').append(activeDocPopover);
	                                const offset = $trigger.offset();
	                                const triggerWidth = $trigger.outerWidth();
	                                const triggerHeight = $trigger.outerHeight();
	                                const panelWidth = activeDocPopover.outerWidth();
	                                const top = offset.top + triggerHeight + 6;
	                                const left = offset.left + (triggerWidth / 2) - (panelWidth / 2);
	                                activeDocPopover.css({ top: top, left: Math.max(12, left) });
	                            });

								$('.doc-popover-trigger')
								.attr('tabindex', '0')
								.attr('role', 'button')
								.off('keydown.docpop')
								.on('keydown.docpop', function (e) {
									if (e.key === 'Enter' || e.key === ' ') {
										e.preventDefault();
										$(this).click();
									}
								});

	                            $(document).on('click', function(e) {
	                                if(!$(e.target).closest('.doc-popover-trigger, .doc-popover-panel').length) {
	                                    hideDocPopover();
	                                }
	                            });
			});
	    <!--End of Document Ready-->
	</script> 
			
			<script id="supplier-card-template" type="text/x-handlebars-template">
				{{#each this}}
					<div><xsl:attribute name="class">supplier {{#if renewalSeverity}}supplier-{{renewalSeverity}}{{/if}}</xsl:attribute>
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
					</div>
				{{/each}}
			</script>
			
			<script id="outlook-solution-template" type="text/x-handlebars-template">
				<div>
					<i>
						<xsl:attribute name="class">fa {{info.icon}} text-primary right-5</xsl:attribute>
					</i>
					<a tab-index="0" class="view-popover" data-toggle="popover"><i class="fa fa-info-circle text-lightgrey right-5"/></a>
					<span>{{{groupTitle}}}</span>
					<!--Start Popover-->
					<div class="popover small">
						<span class="row-title">{{{groupTitle}}}</span>
						<p class="small">{{description}}</p>
						<!--<table class="table small">
							<tbody>
								<tr>
									<th width="400px"><i class="fa fa-users right-5"/>Business Fit:</th>
									<td>High</td>
								</tr>
								<tr>
									<th width="400px"><i class="fa fa-wrench right-5"/>Technical Health:</th>
									<td>Low</td>
								</tr>
								<tr>
									<th width="400px"><i class="fa fa-truck right-5"/>Delivery Model:</th>
									<td>Some Delivery Model</td>
								</tr>
								<tr>
									<th width="400px"><i class="fa fa-code right-5"/>Codebase:</th>
									<td>Some Codebase</td>
								</tr>
								<tr>
									<th width="400px"><i class="fa fa-calendar right-5"/>Lifecycle:</th>
									<td>Some Lifecycle</td>
								</tr>
							</tbody>
						</table>-->
					</div>
					<!--End Popover-->

				</div>
			</script>
			
			
			<script id="outlook-supplier-template" type="text/x-handlebars-template">
				<div>
					<span><strong>{{{groupTitle}}}</strong></span>
				</div>
			</script>
			
			
		<script id="outlook-contract-template" type="text/x-handlebars-template">
		<div>
				{{#if isComponent}}
				<a tab-index="0" class="view-popover" data-toggle="popover">
					<i class="fa fa-info-circle text-lightgrey right-5"></i>
				</a>
				<div class="popover small">
					<p class="impact">{{{product}}}</p>
					{{#if details}}
					<p class="small">{{{details}}}</p>
					{{/if}}
					<p class="text-muted small">{{supplierName}} — {{contractName}}</p>
					{{{lifeDate}}}
				</div>
				<span class="row-title">{{{product}}}</span>
				{{{lifeDate}}}
				{{else}}
				<!-- Parent contract header row -->
				<span class="row-title groupHeaderText">{{{product}}}</span><div class="popover small">
					<p class="impact">{{{product}}}</p>
					<p class="text-muted small">{{supplierName}}</p>

				</div>
				{{/if}}
			</div>
			</script>
			
			
			
			<script id="solution-provider-summary-template" type="text/x-handlebars-template">
				<div class="top-15 hidden-md hidden-lg"></div>
				<section class="supplier-modern-card {{#if renewalSeverity}}supplier-{{renewalSeverity}}{{/if}}">
					<div class="supplier-modern-header">
						<div>
							<span class="eyebrow-label"><i class="fa fa-truck right-5"></i><xsl:value-of select="eas:i18n('Supplier')"/></span>
							<div class="supplier-modern-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
							<p class="supplier-modern-desc">
								{{#if description}}{{description}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('No description available')"/></span>{{/if}}
							</p>
						</div>
						<div class="cost-toggle-container text-right">
							<span class="eyebrow-label"><i class="fa fa-money right-5"></i><xsl:value-of select="eas:i18n('Total Contract Value')"/></span>
							<div class="supplier-modern-value cost-total">
								{{#if totalCost}}{{currencyCode}}{{currency}}{{prettyTotalCost}}{{else}}<span>-</span>{{/if}}
							</div>
							<div class="cost-by-currency" style="display:none;">
								{{#if totalByCurrency}}
									{{#each totalByCurrency}}
										<div class="supplier-modern-value">{{this.currency}}{{this.symbol}}{{formatCurrencyAmount this.total}}</div>
									{{/each}}
								{{else}}
									<span>-</span>
								{{/if}}
							</div>
							<button class="btn btn-ghost btn-xs toggle-cost-view"><xsl:value-of select="eas:i18n('Show Breakdown')"/> <i class="fa fa-toggle-on"></i></button>
						</div>
					</div>

					<div class="supplier-modern-metrics">
						<div class="metric-card">
							<span class="metric-label"><xsl:value-of select="eas:i18n('Active Contracts')"/></span>
							<span class="metric-value">{{contracts.length}}</span>
						</div>
						<div class="metric-card">
							<span class="metric-label"><xsl:value-of select="eas:i18n('Business Processes')"/></span>
							<span class="metric-value">{{busProcs.length}}</span>
						</div>
						<div class="metric-card">
							<span class="metric-label"><xsl:value-of select="eas:i18n('Applications')"/></span>
							<span class="metric-value">{{apps.length}}</span>
						</div>
						<div class="metric-card">
							<span class="metric-label"><xsl:value-of select="eas:i18n('Technology Products')"/></span>
							<span class="metric-value">{{techProds.length}}</span>
						</div>
					</div>
				</section>

				<div class="modern-section-heading">
					<div>
						<h3 class="strong no-margin"><xsl:value-of select="eas:i18n('Solutions')"/></h3>
						<span class="eyebrow-label"><xsl:value-of select="eas:i18n('Products, applications and technologies in scope')"/></span>
					</div>
					<div class="modern-filter">
						<span class="impact right-10"><xsl:value-of select="eas:i18n('Filter')"/>:</span>
						<input type="text" id="solutionFilter" class="form-control input-sm" style="min-width: 220px;"/>
					</div>
				</div>

				{{#each busProcs}}
					<div class="product solution-card">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						<div class="solution-card__header">
							<div class="solution-card__title">
								<i><xsl:attribute name="class">fa {{icon}} text-primary</xsl:attribute></i>
								<div>
									<span class="solution-link strong">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
								</div>
							</div>
							{{#if contractComps.length}}
								<span class="metric-pill"><i class="fa fa-layer-group"></i>{{contractComps.length}} Components</span>
							{{/if}}
						</div>
						{{#each contractComps}}
							<div class="solution-card__contract">
								<div class="solution-card__contract-header">
									<span class="solution-card__supplier"> 
										{{#if supplier}}{{#essRenderInstanceMenuLink this.supplier}}{{/essRenderInstanceMenuLink}}{{else}}
										{{#if contract.supplier}}{{#essRenderInstanceMenuLink contract.supplier}}{{/essRenderInstanceMenuLink}}{{else}}<span class="text-muted">Supplier unavailable</span>{{/if}}{{/if}}
										- {{contract.description}} - {{renewalModel}}
									</span>
									<div>
										{{#if contract.docLinks}}
											<span class="contract-chip"><a tab-index="0" class="doc-popover-trigger" data-toggle="popover" title="Documents"><i class="fa fa-file-text-o"></i></a>
											<div class="doc-popover-list" style="display:none;">
												{{#each contract.docLinks}}
													<div><a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{url}}</xsl:attribute>{{label}}</a></div>
												{{/each}}
											</div></span>
										{{/if}}
									</div>
								</div>
								<div class="chip-row">
									{{#if startDate}}
										<span class="contract-chip"><i class="fa fa-calendar"></i>Start {{prettyStartDate}}</span>
									{{else}}
										{{#if contract.startDate}}
											<span class="contract-chip"><i class="fa fa-calendar"></i>Start {{contract.prettyStartDate}}</span>
										{{/if}}
									{{/if}}
									{{#if renewalDate}}
										<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>Renewal {{prettyRenewalDate}}</span>
									{{else}}
										{{#if contract.renewalDate}}
											<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>Renewal {{contract.prettyRenewalDate}}</span>
										{{/if}}
									{{/if}}
									{{#if cost}}
										<span class="contract-chip"><i class="fa fa-money"></i>{{currencyCode}}{{currency}}{{prettyCost}}</span>
									{{/if}}
									{{#if contractedUnits}}
										<span class="contract-chip"><i class="fa fa-users"></i>{{contractedUnits}}</span>
									{{/if}}
									{{#if licenseModel}}
										<span class="contract-chip"><i class="fa fa-copy"></i>{{licenseModel}}</span>
									{{/if}}
									{{#if renewalModel}}
										<span class="contract-chip"><i class="fa fa-refresh"></i>{{renewalModel}}</span>
									{{/if}}
								</div>
							</div>
						{{/each}}
					</div>
				{{/each}}

				{{#each apps}}
					<div class="product solution-card">
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<div class="solution-card__header">
							<div class="solution-card__title">
								<i><xsl:attribute name="class">fa {{icon}} text-primary</xsl:attribute></i>
								<div>
									<span class="solution-link strong">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
								</div>
							</div>
							{{#if contractComps.length}}
								<span class="metric-pill"><i class="fa fa-layer-group"></i>{{contractComps.length}} Components</span>
							{{/if}}
						</div>
						{{#each contractComps}}
							<div class="solution-card__contract">
								<div class="solution-card__contract-header">
									<span class="solution-card__supplier">
										{{#if supplier}}{{#essRenderInstanceMenuLink this.supplier}}{{/essRenderInstanceMenuLink}}{{else}}
										{{#if contract.supplier}}{{#essRenderInstanceMenuLink contract.supplier}}{{/essRenderInstanceMenuLink}}{{else}}<span class="text-muted">Supplier unavailable</span>{{/if}}{{/if}}

										- {{contract.description}} - {{renewalModel}}
									</span>
									<div>
										{{#if contract.docLinks}}
											<span class="contract-chip"><a tab-index="0" class="doc-popover-trigger" data-toggle="popover" title="Documents"><i class="fa fa-file-text-o"></i></a>
											<div class="doc-popover-list" style="display:none;">
												{{#each contract.docLinks}}
													<div><a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{url}}</xsl:attribute>{{label}}</a></div>
												{{/each}}
											</div></span>
										{{/if}}
									</div>
								</div>
								<div class="chip-row">
									{{#if startDate}}
										<span class="contract-chip"><i class="fa fa-calendar"></i>Start {{prettyStartDate}}</span>
									{{else}}
										{{#if contract.startDate}}
											<span class="contract-chip"><i class="fa fa-calendar"></i>Start {{contract.prettyStartDate}}</span>
										{{/if}}
									{{/if}}
									{{#if renewalDate}}
										<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>Renewal {{prettyRenewalDate}}</span>
									{{else}}
										{{#if contract.renewalDate}}
											<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>Renewal {{contract.prettyRenewalDate}}</span>
										{{/if}}
									{{/if}}
									{{#if cost}}
										<span class="contract-chip"><i class="fa fa-money"></i>{{currencyCode}} {{currency}}{{prettyCost}}</span>
									{{/if}}
									{{#if contractedUnits}}
										<span class="contract-chip"><i class="fa fa-users"></i>{{contractedUnits}}</span>
									{{/if}}
									{{#if unitCost}}
										<span class="contract-chip"><i class="fa fa-balance-scale"></i>{{currency}}{{unitCost}}</span>
									{{/if}}
									{{#if licenseModel}}
										<span class="contract-chip"><i class="fa fa-copy"></i>{{licenseModel}}</span>
									{{/if}}
								</div>
							</div>
						{{/each}}
					</div>
				{{/each}}

				{{#each techProds}}
					<div class="product solution-card">
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<div class="solution-card__header">
							<div class="solution-card__title">
								<i><xsl:attribute name="class">fa {{icon}} text-primary</xsl:attribute></i>
								<div>
									<span class="solution-link strong">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
								</div>
							</div>
							{{#if contractComps.length}}
								<span class="metric-pill"><i class="fa fa-layer-group"></i>{{contractComps.length}} Components</span>
							{{/if}}
						</div>
						{{#each contractComps}}
							<div class="solution-card__contract">
								<div class="solution-card__contract-header">
									<span class="solution-card__supplier"> 
										{{#if supplier}}{{#essRenderInstanceMenuLink this.supplier}}{{/essRenderInstanceMenuLink}}{{else}}
										{{#if contract.supplier}}{{#essRenderInstanceMenuLink contract.supplier}}{{/essRenderInstanceMenuLink}}{{else}}<span class="text-muted">Supplier unavailable</span>{{/if}}{{/if}}

										- {{../description}} - {{renewalModel}}
									</span>
									<div>
										{{#if contract.docLinks}} 
											<span class="contract-chip"><a tab-index="0" class="doc-popover-trigger" data-toggle="popover" title="Documents"><i class="fa fa-file-text-o"></i></a>
											<div class="doc-popover-list" style="display:none;">
												{{#each contract.docLinks}}
													<div><a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{url}}</xsl:attribute>{{label}}</a></div>
												{{/each}} 
											</div>
											</span>
										{{else}}
											{{#if docLinks}}
												<span class="contract-chip"><a tab-index="0" class="doc-popover-trigger" data-toggle="popover" title="Documents"><i class="fa fa-file-text-o"></i></a>
											<div class="doc-popover-list" style="display:none;">
												{{#each docLinks}}
													<div><a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{url}}</xsl:attribute>{{label}}</a></div>
												{{/each}} 
												</div>
												</span>
											{{/if}}
										{{/if}}
									</div>
								</div>
								<div class="chip-row">
									{{#if startDate}}
										<span class="contract-chip"><i class="fa fa-calendar"></i>Start {{prettyStartDate}}</span>
									{{else}}
										{{#if contract.startDate}}
											<span class="contract-chip"><i class="fa fa-calendar"></i>Start {{contract.prettyStartDate}}</span>
										{{/if}}
									{{/if}}
									{{#if renewalDate}}
										<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>Renewal {{prettyRenewalDate}}</span>
									{{else}}
										{{#if contract.renewalDate}}
											<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>Renewal {{contract.prettyRenewalDate}}</span>
										{{/if}}
									{{/if}}
									{{#if renewalNoticeDays}}
										<span class="contract-chip"><i class="fa fa-bell"></i>Notice {{renewalNoticeDays}} days</span>
									{{else}}
										{{#if contract.renewalNoticeDays}}
											<span class="contract-chip"><i class="fa fa-bell"></i>Notice {{contract.renewalNoticeDays}} days</span>
										{{/if}}
									{{/if}}
									{{#if cost}}
										<span class="contract-chip"><i class="fa fa-money"></i>{{currencyCode}} {{currency}}{{prettyCost}}</span>
									{{/if}}
									{{#if licenseModel}}
										<span class="contract-chip"><i class="fa fa-copy"></i>{{licenseModel}}</span>
									{{/if}}
									{{#if contract.type}}
										<span class="contract-chip"><i class="fa fa-file-text-o"></i>{{contract.type}}</span>
									{{/if}}
								</div>
							</div>
						{{/each}}
					</div>
				{{/each}}
			</script>

						<script id="contract-supplier-summary-template" type="text/x-handlebars-template">
				<div class="top-15 hidden-md hidden-lg"></div>
				<section><xsl:attribute name="class">supplier-modern-card contract-modern-card </xsl:attribute>
					<div class="supplier-modern-header">
						<div>
							<span class="eyebrow-label"><i class="fa fa-truck right-5"></i>Supplier</span>
							<div class="supplier-modern-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
							<p class="supplier-modern-desc">
								{{#if description}}{{description}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('No description available')"/></span>{{/if}}
							</p>
							<div class="chip-row">
								<span class="contract-chip">
									<i class="fa fa-users"></i>
									{{#if relStatus.name}}{{relStatus.name}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Status unknown')"/></span>{{/if}}
								</span>
								<span class="contract-chip">
									<i class="fa fa-file-text-o"></i>{{contracts.length}} <xsl:value-of select="eas:i18n('Contracts')"/>
								</span>
							</div>
						</div>
						<div class="cost-toggle-container text-right">
							<span class="eyebrow-label"><i class="fa fa-money right-5"></i><xsl:value-of select="eas:i18n('Total Contract Value')"/></span>
							<div class="supplier-modern-value cost-total">
								{{#if totalCost}}{{currencyCode}}{{currency}}{{prettyTotalCost}}{{else}}<span>-</span>{{/if}}
							</div>
							<div class="cost-by-currency" style="display:none;">
								{{#if totalByCurrency}}
									{{#each totalByCurrency}}
										<div class="supplier-modern-value">{{this.currency}}{{this.symbol}}{{formatCurrencyAmount this.total}}</div>
									{{/each}}
								{{else}}
									<span>-</span>
								{{/if}}
							</div>
							<button class="btn btn-ghost btn-xs toggle-cost-view"><xsl:value-of select="eas:i18n('Show Breakdown')"/> <i class="fa fa-toggle-on"></i></button>
						</div>
					</div>
				</section>

				<div class="modern-section-heading">
					<div>
						<h3 class="strong no-margin"><xsl:value-of select="eas:i18n('Contracts')"/></h3>
						<span class="eyebrow-label"><xsl:value-of select="eas:i18n('Commercial agreements and their coverage')"/></span>
					</div>
					<div class="modern-filter">
						<span class="impact right-10"><xsl:value-of select="eas:i18n('Filter')"/>:</span>
						<input type="text" id="contractFilter" class="form-control input-sm" style="min-width: 220px;"/>
					</div>
				</div>
				<div class="productKey small top-10 bottom-15">
					<span class="right-10 impact">Key:</span>
					<i class="fa fa-money right-5 icon-color"></i><span class="right-10"><xsl:value-of select="eas:i18n('Total Cost')"/></span>
					<i class="fa fa-users right-5 icon-color"></i><span class="right-10"><xsl:value-of select="eas:i18n('# of Licenses')"/></span>
					<i class="fa fa-file-text-o right-5 icon-color"></i><span class="right-10"><xsl:value-of select="eas:i18n('Contract Type')"/></span>
					<i class="fa fa-copy right-5 icon-color"></i><span class="right-10"><xsl:value-of select="eas:i18n('Renewal Model')"/></span>
					<i class="fa fa-calendar right-5 icon-color"></i><span class="right-10"><xsl:value-of select="eas:i18n('Renewal Date')"/></span>
				</div>

				{{#each contracts}}
					<div><xsl:attribute name="class">contract contract-card top-20 {{#if renewalSeverity}}contract-{{renewalSeverity}}{{/if}}</xsl:attribute>
						<xsl:attribute name="data-contract-name">{{description}}</xsl:attribute>
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
											<div class="contract-card__header">
						<div>
							<p class="contract-card__title">{{description}}</p>
							<div class="contract-card__meta">
								{{#if type}}<span><i class="fa fa-file-text-o right-5"></i>{{type}}</span>{{/if}}
								{{#if renewalModel}}<span><i class="fa fa-copy right-5"></i>{{renewalModel}}</span>{{/if}}
							</div>
						</div>
						<div class="contract-card__value cost-toggle-container">
							<div class="cost-total">
								{{#if totalCost}}
									<div class="contract-card__amount">{{../currencyCode}}{{../currency}}{{prettyTotalCost}}</div>
								{{/if}}
							</div>
							<div class="cost-by-currency" style="display:none;">
								{{#if byCurrencyTotal}}
									{{#each byCurrencyTotal}}
										<div class="contract-card__amount">{{this.currency}}{{this.symbol}}{{formatCurrencyAmount this.total}}</div>
									{{/each}}
								{{else}}
									<span>-</span>
								{{/if}}
							</div>
							<button class="btn btn-ghost btn-xs toggle-cost-view"><xsl:value-of select="eas:i18n('Show Breakdown')"/> <i class="fa fa-toggle-on"></i></button>
							{{#if docLinks}}
								<div class="contract-card__docs">
									<a tab-index="0" class="doc-popover-trigger" data-toggle="popover" title="Documents"><i class="fa fa-file-text-o"></i></a>
									<div class="doc-popover-list" style="display:none;">
										{{#each docLinks}}
											<div><a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">https://{{url}}</xsl:attribute>{{label}}</a></div>
										{{/each}}
									</div>
								</div>
							{{/if}}
						</div>
					</div>
					<div class="chip-row contract-card__chips">
							{{#if startDate}}<span class="contract-chip"><i class="fa fa-calendar"></i>{{prettyStartDate}}</span>{{/if}}
							{{#if renewalDate}}<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>{{prettyRenewalDate}}</span>{{/if}}
							{{#if renewalNoticeDays}}<span class="contract-chip"><i class="fa fa-bell"></i>{{renewalNoticeDays}} <xsl:value-of select="eas:i18n('days notice')"/></span>{{/if}}
							
						</div>
						<div class="contract-card__body">
							{{#each contractComps}}
								<div><xsl:attribute name="class">contract-component {{#if renewalSeverity}}contract-{{renewalSeverity}}{{/if}}</xsl:attribute>
									<div class="contract-component__summary">
										<div class="contract-component__supplier">
											 
											{{#if supplier}}{{#essRenderInstanceMenuLink this.supplier}}{{/essRenderInstanceMenuLink}}
											{{else}}{{#if contract.supplier}}
											{{#essRenderInstanceMenuLink contract.supplier}}{{/essRenderInstanceMenuLink}}
											{{{contract.supplier.link}}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Supplier unavailable')"/></span>{{/if}}{{/if}}
										</div>
										<div class="chip-row">
											{{#if cost}}<span class="contract-chip"><i class="fa fa-money"></i>{{currencyCode}}{{currency}}{{prettyCost}}</span>{{/if}}
											{{#if contractedUnits}}<span class="contract-chip"><i class="fa fa-users"></i>{{contractedUnits}}</span>{{/if}}
											{{#if licenseModel}}<span class="contract-chip"><i class="fa fa-copy"></i>{{licenseModel}}</span>{{/if}}
											{{#if renewalModel}}<span class="contract-chip"><i class="fa fa-refresh"></i>{{renewalModel}}</span>{{/if}}
											{{#if startDate}}<span class="contract-chip"><i class="fa fa-calendar"></i>{{prettyStartDate}}</span>{{else}}{{#if contract.startDate}}<span class="contract-chip"><i class="fa fa-calendar"></i>{{contract.prettyStartDate}}</span>{{/if}}{{/if}}
											{{#if renewalDate}}<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>{{prettyRenewalDate}}</span>{{else}}{{#if contract.renewalDate}}<span class="contract-chip"><i class="fa fa-calendar-check-o"></i>{{contract.prettyRenewalDate}}</span>{{/if}}{{/if}}
											{{#if contract.docLinks}}
											<span class="contract-chip"><a tab-index="0" class="doc-popover-trigger" data-toggle="popover" title="Documents"><i class="fa fa-file-text-o"></i></a>
											<div class="doc-popover-list" style="display:none;">
												{{#each contract.docLinks}}
													<div><a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{url}}</xsl:attribute>{{label}}</a></div>
												{{/each}}
											</div></span>{{/if}}
										</div>
									</div>
									<!--
									{{#if contract.docLinks}}
										<div class="contract-card__docs top-10">
											<a tab-index="0" class="doc-popover-trigger" data-toggle="popover" title="Documents"><i class="fa fa-file-text-o"></i></a>
											<div class="doc-popover-list" style="display:none;">
												{{#each contract.docLinks}}
													<div><a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{{url}}}</xsl:attribute>{{label}}</a></div>
												{{/each}}
											</div>
										</div>
									{{/if}}
								-->
									<div class="contract-component__associations">
										{{#if busProcs}}
											<div class="association-group">
												<span class="association-label"><i class="fa fa-sitemap right-5"></i><xsl:value-of select="eas:i18n('Business Processes')"/></span>
												<div class="association-pill-list">
													{{#each busProcs}}
														<span class="association-pill">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
													{{/each}}
												</div>
											</div>
										{{/if}}
										{{#if apps}}
											<div class="association-group">
												<span class="association-label"><i class="fa fa-desktop right-5"></i><xsl:value-of select="eas:i18n('Applications')"/></span>
												<div class="association-pill-list">
													{{#each apps}}
														<span class="association-pill">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
													{{/each}}
												</div>
											</div>
										{{/if}}
										{{#if techProds}}
											<div class="association-group">
												<span class="association-label"><i class="fa fa-cogs right-5"></i><xsl:value-of select="eas:i18n('Technologies')"/></span>
												<div class="association-pill-list">
													{{#each techProds}}
														<span class="association-pill">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
													{{/each}}
												</div>
											</div>
										{{/if}}
									</div>
								</div>
							{{/each}}
						</div>
					</div>
				{{/each}}
			</script>
			
			
			
			<script id="product-template" type="text/x-handlebars-template">
				{{#each this}}
					<div>
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<xsl:attribute name="class">product pc{{id}}</xsl:attribute>
						<div class="pull-left">
							<i class="fa fa-server text-primary right-5"/>
							<span class="strong">{{{productLink}}}</span>
							{{#if docLinks}}
								{{#each docLinks}}
									<a class="left-5" target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{{url}}}</xsl:attribute><i class="fa fa-file-alt text-primary"/></a>
								{{/each}}
							{{/if}}
						</div>
						<div class="pull-right">
                            {{#if licenseOnContract}}
							<div class="licenceInfo contract right-10">
								<i class="fa fa-money right-5 "/><span>{{../currencyCode}}{{../currency}}
                                {{licenseCostContract}}</span>
								<i class="fa fa-users right-5 left-10"/><span>{{licenseOnContract}}</span>
								<i class="fa fa-th right-5 left-10"/><span>{{licenseUnitPriceContract}}</span>
							</div>
                            {{/if}} 
                            {{#if LicenceType}}   
							<div class="licenceInfo type right-10">
								<i class="fa fa-file-text-o right-5 "/><span>{{LicenceType}}</span>
							</div>
                             {{/if}}
                            {{#if dateDebug}}  
							<div class="licenceInfo date right-10">
								<xsl:attribute name="style">border-left:3pt solid {{rembgColor}}</xsl:attribute>
								<i class="fa fa-calendar right-5 "/><span>{{dateDebug}}</span>
							</div>
                            {{/if}}
                            {{#unless dateDebug}}
                            	<div class="licenceInfo date right-10">Not Known</div>
                            {{/unless}}
							<div class="licenceInfo poss">
								<xsl:attribute name="style">cursor:pointer</xsl:attribute>
								<i class="fa fa-plus-circle possButton"/>
							</div>	
						</div>
					</div>
				{{/each}}
			</script>
			<script id="analysis-template" type="text/x-handlebars-template">
				<div class="row top-5">
					<div class="col-md-4">
						<div class="product">
							<xsl:attribute name="id">{{current.0.id}}</xsl:attribute>
							<div class="pull-left">
								<i class="fa fa-server text-primary right-5"/>
								<span class="strong">{{current.0.product}}</span>
							</div>
							<div class="pull-right">
								<div class="licenceInfo contract right-10">
                                   {{#if future.0.licenseCostContract}}  
									<i class="fa fa-money right-5 "/><span>{{../currencyCode}}{{../currency}}{{current.0.licenseCostContract}}</span>
									<i class="fa fa-users right-5 left-10"/><span>{{current.0.licenseOnContract}}</span>
									<i class="fa fa-th right-5 left-10"/><span>{{current.0.licenseUnitPriceContract}}</span>
                                    {{/if}}
								</div>
								<div class="licenceInfo type right-10">
									<i class="fa fa-file-text-o right-5 "/><span>{{current.0.LicenceType}}</span>
								</div>
								<div class="licenceInfo date right-10">
									<xsl:attribute name="style">border-left:3pt solid {{current.0.rembgColor}}</xsl:attribute>
									<i class="fa fa-calendar right-5 "/><span>{{current.0.dateDebug}}</span>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="product">
							<xsl:attribute name="id">{{future.0.id}}</xsl:attribute>
							<div class="pull-left">
								<i class="fa fa-server text-primary right-5"/>
								<span class="strong">{{future.0.product}}</span>
							</div>
							<div class="pull-right">
                                {{#if future.0.licenseCostContract}}  
								<div class="licenceInfo contract right-10">
									<i class="fa fa-money right-5 "/><span>{{../currencyCode}}{{../currency}}{{future.0.licenseCostContract}}</span>
									<i class="fa fa-users right-5 left-10"/><span>{{future.0.licenseOnContract}}</span>
									<i class="fa fa-th right-5 left-10"/><span>{{future.0.licenseUnitPriceContract}}</span>
								</div>
                                {{/if}}
                                {{#if future.0.LicenceType}}
								<div class="licenceInfo type right-10">
									<i class="fa fa-file-text-o right-5 "/><span>{{future.0.LicenceType}}</span>
								</div>
                                {{/if}}
                                 {{#if future.0.dateDebug}}
								<div class="licenceInfo date right-10">
									<xsl:attribute name="style">border-left:3pt solid {{future.0.rembgColor}}</xsl:attribute>
									<i class="fa fa-calendar right-5 "/><span>{{future.0.dateDebug}}</span>
								</div>
                                {{/if}}
							</div>
						</div>
					</div>
					<div class="col-md-4 costcolumn">
						<strong><xsl:value-of select="eas:i18n('Potential Saving')"/>: </strong><span>{{totalPercent}}</span>
						<button class="btn btn-default licenceInfo cls pull-right">
							<i class="fa fa-times right-5"/>
							<span><xsl:value-of select="eas:i18n('Discard')"/></span>  
						</button>
                      
					</div>
				</div>
			</script>
            
            
		</html>
	</xsl:template>

	
	<xsl:template match="node()" mode="supplierOptions">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisid" select="translate(current()/name, '.', '')"/>
		<option id="pf{$thisid}">
			<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/>
		</option>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderContractSupplierJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisSupplierRelStatus" select="key('supplierRelStatii', $this/own_slot_value[slot_reference = 'supplier_relationship_status']/value)"/>
		<xsl:variable name="thisSuppRelStatusName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisSupplierRelStatus"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!--<xsl:variable name="thisContracts" select="$allContracts[own_slot_value[slot_reference = 'contract_supplier']/value = $this/name]"/>-->
		<xsl:variable name="thisContracts" select="key('allContractsKey',$this/name)"/>

		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
				}" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          
		
		{
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>", 
		"className": "Supplier"
		,"relStatusId": "<xsl:value-of select="eas:getSafeJSString($thisSupplierRelStatus/name)"/>"
		,"contractIds": [<xsl:for-each select="$thisContracts/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
<xsl:template match="node()" mode="RenderSolutionSupplierJSON">
  <xsl:variable name="this" select="current()"/>

  <!-- name/desc/link once -->
  <xsl:variable name="thisName" select="current()/own_slot_value[slot_reference='name']/value"/>
  <xsl:variable name="thisDesc" select="current()/own_slot_value[slot_reference='description']/value"/>
  <xsl:variable name="thisType" select="current()/type"/>
  
  <!-- relationship lookups (use your existing keys/vars) -->
  <xsl:variable name="relStatus"
    select="key('supplierRelStatii', $this/own_slot_value[slot_reference='supplier_relationship_status']/value)"/>

  <!-- Elements contracted via CCRs for this supplier’s contracts -->
  <xsl:variable name="contractsForSupplier"
    select="key('allContractsBySupplier', $this/name)"/>
  <xsl:variable name="ccrsForSupplier"
    select="key('ccrfromContract_Key', $contractsForSupplier/name)"/>

  <xsl:variable name="thisBusProcs"
    select="$contractedBusProcs[name = $ccrsForSupplier/own_slot_value[slot_reference='contract_component_to_element']/value]"/>
  <xsl:variable name="thisApps"
    select="$contractedApps[name = $ccrsForSupplier/own_slot_value[slot_reference='contract_component_to_element']/value]"/>
  <xsl:variable name="thisTechProds"
    select="$contractedTechProds[name = $ccrsForSupplier/own_slot_value[slot_reference='contract_component_to_element']/value]"/>

  <!-- arrays -->
  <xsl:variable name="busProcIds" as="array(*)"
    select="array{ for $n in $thisBusProcs/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="appIds" as="array(*)"
    select="array{ for $n in $thisApps/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="techProdIds" as="array(*)"
    select="array{ for $n in $thisTechProds/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="contractIds" as="array(*)"
    select="array{ for $n in $contractsForSupplier/name return string(eas:getSafeJSString($n)) }"/>

  <!-- object -->
  <xsl:variable name="obj" as="map(*)" select="
    map{
      'id'          : string(eas:getSafeJSString($this/name)),
      'name'        : string($thisName), 
	  'className'   : string($thisType),
      'description' : string($thisDesc),
      'relStatusId' : if ($relStatus) then string(eas:getSafeJSString($relStatus/name)) else (),
      'busProcIds'  : $busProcIds,
      'appIds'      : $appIds,
      'techProdIds' : $techProdIds,
      'contractIds' : $contractIds
    }"/>

  <xsl:value-of select="serialize($obj, map{'method':'json'})"/>
  <xsl:if test="not(position() = last())">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="RenderContractJSON">
  <xsl:variable name="this" select="current()"/>

  <!-- description -->
  <xsl:variable name="thisDesc">
    <xsl:call-template name="RenderMultiLangInstanceDescription">
      <xsl:with-param name="theSubjectInstance" select="$this"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- lookups (same as your working version) -->
  <xsl:variable name="thisDocLinks"     select="key('allExternalLink_key', $this/name)"/>
  <xsl:variable name="thisSupplier"     select="key('allSuppliers', $this/own_slot_value[slot_reference='contract_supplier']/value)"/>
  <xsl:variable name="thisContractRels" select="key('ccrfromContract_Key', $this/name)"/>
  <xsl:variable name="currentRenewalModel"
                select="key('allRenewalModels', ($this, $thisContractRels)/own_slot_value[slot_reference=('contract_renewal_model','ccr_renewal_model')]/value)"/>
  <xsl:variable name="contractSigDate"
                select="$this/own_slot_value[slot_reference='contract_signature_date_ISO8601']/value"/>
  <xsl:variable name="contractRenewalDate"
                select="$this/own_slot_value[slot_reference='contract_end_date_ISO8601']/value"/>
  <xsl:variable name="contractCost"
                select="$this/own_slot_value[slot_reference='contract_total_annual_cost']/value"/>
  <xsl:variable name="contractType"
                select="key('allContractTypes', $this/own_slot_value[slot_reference='contract_type']/value)"/>
  <xsl:variable name="supplierRelStatus"
                select="key('supplierRelStatii', $thisSupplier[1]/own_slot_value[slot_reference='supplier_relationship_status']/value)"/>

  <!-- notice/review -->
  <xsl:variable name="renewalNoticeDays"
                select="($this/own_slot_value[slot_reference='contract_renewal_notice_days']/value, 0)[1]"/>
  <xsl:variable name="renewalReviewDays"
                select="($supplierRelStatus/own_slot_value[slot_reference='csrs_contract_review_notice_days']/value, 0)[1]"/>

  <!-- element groups -->
  <xsl:variable name="thisBusProcs"
                select="$contractedBusProcs[name = $thisContractRels/own_slot_value[slot_reference='contract_component_to_element']/value]"/>
  <xsl:variable name="thisApps"
                select="$contractedApps[name = $thisContractRels/own_slot_value[slot_reference='contract_component_to_element']/value]"/>
  <xsl:variable name="thisTechProds"
                select="$contractedTechProds[name = $thisContractRels/own_slot_value[slot_reference='contract_component_to_element']/value]"/>

  <!-- arrays -->
  <xsl:variable name="docLinks" as="array(*)"
    select="if (exists($thisDocLinks))
            then array{
              for $l in $thisDocLinks
              return map{
                'label': string($l/own_slot_value[slot_reference='name']/value),
                (: If you must keep the ML slot rendering for URLs, swap this to a function or build the array in xsl:for-each :)
                'url'  : string($l/own_slot_value[slot_reference='external_reference_url']/value)
              }
            }
            else array{}"/>

  <xsl:variable name="contractCompIds" as="array(*)"
    select="array{ for $n in $thisContractRels/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="busProcIds" as="array(*)"
    select="array{ for $n in $thisBusProcs/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="appIds" as="array(*)"
    select="array{ for $n in $thisApps/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="techProdIds" as="array(*)"
    select="array{ for $n in $thisTechProds/name return string(eas:getSafeJSString($n)) }"/>

  <!-- object -->
  <!-- Build your base map -->
<!-- 1) Base object -->
<xsl:variable name="obj" as="map(*)" select="
  map{
    'id'               : string(eas:getSafeJSString($this/name)),
    'description'      : string($thisDesc),
    'supplierId'       : if ($thisSupplier) then string(eas:getSafeJSString($thisSupplier[1]/name)) else '',
    'relStatusId'      : if ($supplierRelStatus) then string(eas:getSafeJSString($supplierRelStatus/name)) else '',
    'startDate'        : if (string-length($contractSigDate)     gt 0) then string($contractSigDate)     else (),
    'renewalDate'      : if (string-length($contractRenewalDate) gt 0) then string($contractRenewalDate) else (),
    'renewalNoticeDays': number($renewalNoticeDays),
    'renewalReviewDays': number($renewalReviewDays),
    'renewalModel'     : if (exists($currentRenewalModel))
                          then string($currentRenewalModel[1]/own_slot_value[slot_reference='enumeration_value']/value)
                          else (),
    'type'             : if ($contractType)
                          then string($contractType/own_slot_value[slot_reference='enumeration_value']/value)
                          else (),
    'cost'             : if (string-length($contractCost) gt 0) then number($contractCost) else (),
    'docLinks'         : $docLinks,
    'contractCompIds'  : $contractCompIds,
    'busProcIds'       : $busProcIds,
    'appIds'           : $appIds,
    'techProdIds'      : $techProdIds
  }
"/>

<!-- 1) Capture the template output as a result tree (no type!) -->
<xsl:variable name="sec-json-raw">
  <xsl:call-template name="RenderSecurityClassificationsJSONForInstance">
    <xsl:with-param name="theInstance" select="."/>
  </xsl:call-template>
</xsl:variable>

<!-- 2) Collapse to a single string -->
<xsl:variable name="sec-json-text" as="xs:string"
              select="normalize-space(string($sec-json-raw))"/>

<!-- 3) Parse defensively into an array(*) -->
<xsl:variable name="sec" as="array(*)">
  <xsl:try>
    <xsl:variable name="s" select="replace($sec-json-text, '^\uFEFF', '')"/>
    <xsl:sequence select="
      if (starts-with($s, '[')) then
        parse-json($s)
      else if (starts-with($s, '{')) then
        (parse-json($s)?securityClassifications, array{})[1]
      else if (contains($s, 'securityClassifications')) then
        (parse-json(concat('{', $s, '}'))?securityClassifications, array{})[1]
      else
        array{}"/>
    <xsl:catch>
      <xsl:message terminate='no'
        select="concat('WARN: security JSON parse failed: ',
                       $err:description, ' | snippet=“',
                       substring($sec-json-text,1,160), '…”')"/>
      <xsl:sequence select="array{}"/>
    </xsl:catch>
  </xsl:try>
</xsl:variable>

<!-- 5) Merge and serialise once -->
<xsl:variable name="out" as="map(*)"
              select="map:put($obj, 'securityClassifications', $sec)"/>

<xsl:value-of select="serialize($out, map{'method':'json'})"/>

  <xsl:if test="not(position() = last())">,</xsl:if>
</xsl:template>

	
<xsl:template match="node()" mode="RenderContractCompJSON">
  <xsl:variable name="this" select="current()"/>

  <!-- Reuse your keyed lookups (same as current template) -->
  <xsl:variable name="currentContract"        select="key('allContractsforKey', $this/name)"/>
  <xsl:variable name="currentContractLinks"   select="key('allExternalLink_key', $this/name)"/>
  <xsl:variable name="currentContractSupplier" select="key('allSuppliers', $currentContract/own_slot_value[slot_reference = 'contract_supplier']/value)"/>
  <xsl:variable name="supplierRelStatus"      select="key('supplierRelStatii', $currentContractSupplier/own_slot_value[slot_reference = 'supplier_relationship_status']/value)"/>

  <xsl:variable name="currentLicense"         select="key('licenceKey', $this/own_slot_value[slot_reference = 'ccr_license']/value)"/>
  <xsl:variable name="currentLicenseType"     select="key('licenseTypekey', $currentLicense/own_slot_value[slot_reference = 'license_type']/value)"/>

  <xsl:variable name="currentRenewalModel"    select="key('allRenewalModels', ($this, $currentContract)/own_slot_value[slot_reference = ('ccr_renewal_model','contract_renewal_model')]/value)"/>
  <xsl:variable name="currentCurrencyInst"    select="key('allCurrencies', $this/own_slot_value[slot_reference = 'ccr_currency']/value)"/>
  <xsl:variable name="currentCurrencyCode"    select="$currentCurrencyInst/own_slot_value[slot_reference = 'currency_code']/value"/>
  <xsl:variable name="currentCurrencySymbol"  select="$currentCurrencyInst/own_slot_value[slot_reference = 'currency_symbol']/value"/>
  <xsl:variable name="currentCurrencyExchangeRate" select="$currentCurrencyInst/own_slot_value[slot_reference = 'currency_exchange_rate']/value"/>

  <!-- Dates & notices (preserve your existing precedence/defaults) -->
  <xsl:variable name="startDate" select="
    if ($this/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value)
    then $this/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value
    else $currentContract/own_slot_value[slot_reference = 'contract_signature_date_ISO8601']/value
  "/>
  <xsl:variable name="renewalDate" select="
    if ($this/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value)
    then $this/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value
    else $this/own_slot_value[slot_reference = 'contract_end_date_ISO8601']/value
  "/>
  <xsl:variable name="renewalNoticeDays" select="
    if ($this/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value)
    then $this/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value
    else (if ($currentContract/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value)
          then $currentContract/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value
          else 0)
  "/>
  <xsl:variable name="renewalReviewDays" select="
    if ($supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value)
    then $supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value
    else 0
  "/>

  <!-- Units, cost (keep your defaults: null/0) -->
  <xsl:variable name="currentContractedUnitsRaw" select="$this/own_slot_value[slot_reference = 'ccr_contracted_units']/value"/>
  <xsl:variable name="currentContractTotalRaw"   select="$this/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value"/>

  <!-- Element groupings (as in existing template) -->
  <xsl:variable name="thisBusProcs"  select="$contractedBusProcs[name = $this/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
  <xsl:variable name="thisApps"      select="$contractedApps[name = $this/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
  <xsl:variable name="thisTechProds" select="$contractedTechProds[name = $this/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>

  <!-- Build arrays up-front -->
  <xsl:variable name="busProcIds" as="array(*)"
    select="array{ for $n in $thisBusProcs/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="appIds" as="array(*)"
    select="array{ for $n in $thisApps/name return string(eas:getSafeJSString($n)) }"/>
  <xsl:variable name="techProdIds" as="array(*)"
    select="array{ for $n in $thisTechProds/name return string(eas:getSafeJSString($n)) }"/>

  <xsl:variable name="docLinks" as="array(*)"
    select="if (count($currentContractLinks) gt 0)
            then array{
              for $l in $currentContractLinks
              return map{
                'label': string($l/own_slot_value[slot_reference='name']/value),
                'url'  : string($l/own_slot_value[slot_reference='external_reference_url']/value)
              }
            }
            else array{}"/>

  <!-- Final JSON object (empty sequence () => null in JSON where wanted) -->
  <xsl:variable name="obj" as="map(*)" select="
    map{
      'id'                    : string(eas:getSafeJSString($this/name)),
      'contractId'            : string(eas:getSafeJSString($currentContract/name)),
      'docLinks'              : $docLinks,
      'supplierId'            : string(eas:getSafeJSString($currentContractSupplier/name)),

      'startDate'             : if (string-length($startDate)  gt 0) then string($startDate)  else (),
      'renewalDate'           : if (string-length($renewalDate) gt 0) then string($renewalDate) else (),
      'renewalNoticeDays'     : number($renewalNoticeDays),
      'renewalReviewDays'     : number($renewalReviewDays),
      'renewalModel'          : if (exists($currentRenewalModel))
                                then string($currentRenewalModel[1]/own_slot_value[slot_reference='enumeration_value']/value)
                                else (),

      'licenseModel'          : if (exists($currentLicenseType))
                                then string($currentLicenseType/own_slot_value[slot_reference='enumeration_value']/value)
                                else (),
      'contractedUnits'       : if (string-length($currentContractedUnitsRaw) gt 0)
                                then number($currentContractedUnitsRaw) else (),

      'cost'                  : if (string-length($currentContractTotalRaw) gt 0)
                                then number($currentContractTotalRaw) else 0,

      'currencyId'            : if ($currentCurrencyInst)
                                then string(eas:getSafeJSString($currentCurrencyInst/name))
                                else ( if ($baseCurrency) then string(eas:getSafeJSString($baseCurrency/name)) else '' ),

      'currencyCode'          : if (string-length($currentCurrencyCode)       gt 0) then string($currentCurrencyCode)       else string($baseCurrencyCode),
      'currencyExchangeRate'  : if (string-length($currentCurrencyExchangeRate) gt 0) then number($currentCurrencyExchangeRate) else number($baseCurrencyExchangeRate),
      'currency'              : if (string-length($currentCurrencySymbol)     gt 0) then string($currentCurrencySymbol)     else string($baseCurrencySymbol),

      'busProcIds'            : $busProcIds,
      'appIds'                : $appIds,
      'techProdIds'           : $techProdIds,
	  'supplier' :map{
                               'id'        : string(eas:getSafeJSString(($currentContractSupplier/name)[1])),
                               'name'      : string(eas:getSafeJSString(($currentContractSupplier/own_slot_value[slot_reference='name']/value)[1])),
                               'className' : 'Supplier'
                             }
		}
  "/>

<xsl:variable name="sec-json-raw">
  <xsl:call-template name="RenderSecurityClassificationsJSONForInstance">
    <xsl:with-param name="theInstance" select="."/>
  </xsl:call-template>
</xsl:variable>

<!-- 2) Collapse to a single string -->
<xsl:variable name="sec-json-text" as="xs:string"
              select="normalize-space(string($sec-json-raw))"/>

<!-- 3) Parse defensively into an array(*) -->
<xsl:variable name="sec" as="array(*)">
  <xsl:try>
    <xsl:variable name="s" select="replace($sec-json-text, '^\uFEFF', '')"/>
    <xsl:sequence select="
      if (starts-with($s, '[')) then
        parse-json($s)
      else if (starts-with($s, '{')) then
        (parse-json($s)?securityClassifications, array{})[1]
      else if (contains($s, 'securityClassifications')) then
        (parse-json(concat('{', $s, '}'))?securityClassifications, array{})[1]
      else
        array{}"/>
    <xsl:catch>
      <xsl:message terminate='no'
        select="concat('WARN: security JSON parse failed: ',
                       $err:description, ' | snippet=“',
                       substring($sec-json-text,1,160), '…”')"/>
      <xsl:sequence select="array{}"/>
    </xsl:catch>
  </xsl:try>
</xsl:variable>

<!-- 5) Merge and serialise once -->
<xsl:variable name="out" as="map(*)"
              select="map:put($obj, 'securityClassifications', $sec)"/>

<xsl:value-of select="serialize($out, map{'method':'json'})"/>
  <xsl:if test="not(position() = last())">,</xsl:if>
</xsl:template>

	
	<xsl:template match="node()" mode="RenderContractSolutionJSON">
		<xsl:param name="supplierSlot"/>
		<xsl:param name="icon"/>
		
		<xsl:variable name="this" select="current()"/>
		
 
	<xsl:variable name="thisSupplier" select="key('allSuppliers', $this/own_slot_value[slot_reference = $supplierSlot]/value)"/>
	<!--	<xsl:variable name="thisContractComps" select="$allContractToElementRels[own_slot_value[slot_reference = 'contract_component_to_element']/value = $this/name]"/> -->
	<xsl:variable name="thisContractComps" select="key('ccr_Key', $this/name)"/>
		
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		<xsl:variable name="infoTemp" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'description':string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
		}"></xsl:variable>
		"className":"<xsl:value-of select="current()/type"/>",
		<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of> 
		,"icon": "<xsl:value-of select="$icon"/>"
		,"supplierId": "<xsl:value-of select="eas:getSafeJSString($thisSupplier/name)"/>"
		<xsl:if test="$thisSupplier/name">
		,'supplier' : {
                               'id':  "<xsl:value-of select="$thisSupplier/name[1]"/>",
                               'name': "<xsl:value-of select="$thisSupplier/own_slot_value[slot_reference='name']/value[1]"/>",
                               'className' : 'Supplier'
                    }
					</xsl:if>
		,"contractCompIds": [<xsl:for-each select="$thisContractComps/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	

	<xsl:template match="node()" mode="RenderCurrencyJSON">
		<xsl:variable name="this" select="current()"/>
		 
		<xsl:variable name="exchangeRate" select="$this/own_slot_value[slot_reference = 'currency_exchange_rate']/value"/>
		<xsl:variable name="isDefaultRaw" select="lower-case($this/own_slot_value[slot_reference = 'currency_is_default']/value)"/>
		<xsl:variable name="isDefault" select="if ($isDefaultRaw = ('true', '1', 'yes')) then 'true' else 'false'"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		<xsl:variable name="infoTemp" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'description':string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
		}"></xsl:variable>
		<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of> 
		,"code": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'currency_code']/value"/>"
		,"symbol": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'currency_symbol']/value"/>"
		,"exchangeRate": <xsl:choose><xsl:when test="string-length($exchangeRate) > 0"><xsl:value-of select="$exchangeRate"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose>
		,"isDefault": <xsl:value-of select="$isDefault"/>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	

	<xsl:template match="node()" mode="RenderEnumJSON">
		<xsl:variable name="this" select="current()"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		<xsl:variable name="infoTemp" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'description':string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
		}"></xsl:variable>
		<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of>,
		
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>
