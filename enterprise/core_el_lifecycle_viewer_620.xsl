<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<xsl:variable name="styles" select="/node()/simple_instance[type='Element_Style']"/>
 
    <xsl:variable name="lifecycles" select="/node()/simple_instance[type=('Vendor_Lifecycle_Status','Lifecycle_Status')]"/>
        
	<xsl:variable name="products" select="/node()/simple_instance[type='Technology_Product']"/>
	<xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"/>
	<xsl:variable name="allproducts" select="$products union $apps"/>
    <xsl:variable name="productLifecycles" select="/node()/simple_instance[type=('Lifecycle_Model','Vendor_Lifecycle_Model', 'Disposition_Lifecycle_Model')][own_slot_value[slot_reference='lifecycle_model_subject']/value=$allproducts/name]"/>
    <xsl:variable name="lifecycleStatusUsages" select="/node()/simple_instance[type=('Lifecycle_Status_Usage','Vendor_Lifecycle_Status_Usage', 'Disposition_Lifecycle_Status_Usage')][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$productLifecycles/name]"/>
    <xsl:variable name="allSupplier" select="/node()/simple_instance[type = 'Supplier']"/>     
    <xsl:variable name="allTechstds" select="/node()/simple_instance[type = 'Technology_Provider_Standard_Specification']"/>
    <xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type='Technology_Product_Role']"/>
	<xsl:variable name="techProdRoleswithStd" select="$allTechProdRoles[name = $allTechstds/own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value]"/>
	<xsl:variable name="techCompwithStd" select="/node()/simple_instance[type='Technology_Component'][name = $techProdRoleswithStd/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
  
    <xsl:variable name="allTechProvUsage" select="/node()/simple_instance[type = 'Technology_Provider_Usage'][own_slot_value[slot_reference='provider_as_role']/value=$allTechProdRoles/name]"/>
    <xsl:variable name="allTechBuildArch" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][own_slot_value[slot_reference='contained_architecture_components']/value=$allTechProvUsage/name]"/>
	<xsl:variable name="prodDeploymentRole" select="/node()/simple_instance[type = 'Technology_Product_Build'][own_slot_value[slot_reference='technology_provider_architecture']/value=$allTechBuildArch/name]"/>
    <xsl:variable name="appDeployment" select="/node()/simple_instance[type = 'Application_Deployment'][own_slot_value[slot_reference='application_deployment_technical_arch']/value=$prodDeploymentRole/name]"/>
    <xsl:variable name="actors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="geos" select="/node()/simple_instance[supertype = 'Geography']"/>
   
    
    <xsl:variable name="stdValue" select="/node()/simple_instance[type = 'Standard_Strength']"/>
     <!--  tech for app  -->

	<xsl:variable name="elementStyle" select="/node()/simple_instance[type = ('Element_Style')]"/>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="appCaptoServiceData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Capabilities 2 Services']"></xsl:variable>

	<xsl:variable name="appLifeData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Lifecycles']"></xsl:variable>
	<xsl:variable name="techLifeData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Lifecycles']"></xsl:variable>
	<xsl:variable name="supplierData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Suppliers']"></xsl:variable>
	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>


	<xsl:template match="knowledge_base">
		<xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiAppCapSvcs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appCaptoServiceData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiAppLifeData">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appLifeData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable> 
		<xsl:variable name="apiSupplierData">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$supplierData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiTechLife">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$techLifeData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiProcess">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$processData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
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
				<title>Lifecycle Viewer</title>
				<script src="js/d3/d3.v5.9.7.min.js?release=6.19"></script>
					
			<style>
				/*------ General Style ------*/
				.d-flex{
					display: -webkit-box;
					display: -ms-flexbox;
					display: flex;
				}
				.align-items-center{
					-webkit-box-align: center;
						-ms-flex-align: center;
							align-items: center;
				}
				.justify-content-between{
					-webkit-box-pack: justify;
						-ms-flex-pack: justify;
							justify-content: space-between;
				}
				.justify-content-end{
					-webkit-box-pack: end;
						-ms-flex-pack: end;
							justify-content: flex-end;
				}
				.vls-body > select{
					-webkit-appearance: none;
					   -moz-appearance:    none;
					   appearance:         none;
					cursor: pointer;
				}
				.vls-select-icon{
					position: relative;
				}
				.vls-select-icon > span{
					position: absolute;
					right:10px;
					font-size:10px;
					transform: translateY(-50%);
					top: 50%;
					z-index:-1;
				}
				.vls-select-icon .form-control {
					height: 30px;
					font-size:12px;
					border-radius:5px;
					box-shadow: none !important;
					background: transparent;
				}
				.select2-container--default .select2-selection--single .select2-selection__placeholder {
					color: #495057;
					font-size:12px;
					border-radius:5px;
				}
				.select2-container--default .select2-selection--single .select2-selection__rendered {
					line-height: 23px;
					color: #495057;
				}
				.vls-pr-10{
					padding-right:10px;
				}
				
				/*------ Check Box ------*/
				.vls-custom-checkbox .form-group {
					margin: 0;
					display: flex;
					align-items: center;
				}
				.vls-custom-checkbox > input {
					padding: 0;
					height: initial;
					width: initial;
					margin-bottom: 0;
					display: none;
					cursor: pointer;
				}
				.vls-custom-checkbox > label {
					position: relative;
					cursor: pointer;
					width:100%;
					display: block;
				} 
				.vls-custom-checkbox > label::before {
					content: '';
					-webkit-appearance: none;
					background:transparent;
					border: 1px solid #dc3545;
					box-shadow: 0 1px 2px rgba(0, 0, 0, 0.vls-05), inset 0px -15px 10px -12px rgba(0, 0, 0, 0.vls-05);
					padding: 7px;
					display: inline-block;
					position: relative;
					vertical-align: middle;
					cursor: pointer;
					margin-right: 7px;
					border-radius: 3px;
				}
				.vls-custom-checkbox > input:checked + label::before {
					background:#dc3545;
				}
				.vls-custom-checkbox  > input:checked + label::after {
					content: '';
					display: block;
					position: absolute;
					top:10px;
					left:6px;
					width:4px;
					height: 9px;
					border: solid #fff;
					border-width: 0 2px 2px 0;
					transform: rotate(45deg);
				}
				.vls-sm-check-box > label {
					font-size: 12px;
					line-height: 12px;
					color: #000000;
					font-weight: normal;
				}
				.vls-sm-check-box > label::before {
					border: 1px solid #dc3545;
					padding:5px;
					margin-right: 0;
					right: 0;
					position: absolute;
					background:#fff;
					border-radius:3px;
				}
				.vls-sm-check-box input:checked + label::after {
					top: 2px;
					left: auto;
					width: 4px;
					height: 7px;
					border: solid #fff;
					border-width: 0 2px 2px 0;
					right: 4px;
				}
				.vls-color-box {
					margin-right: 5px;
					height: 10px;
					width: 10px;
					border: 1px solid #ddd;
					margin-top: -5px;
				}
				/*			
				/*------ Heading ------*/
				.vls-heading > h2{
					font-weight: 600;
					font-size: 30px;
					line-height: 30px;
					margin:0 !important;
				}
				.vls-heading > h3{
					font-weight: 600;
					font-size: 24px;
					line-height: 24px;
					margin:0 !important;
				}
				.vls-heading > h4{
					font-weight: 600;
					font-size:18px;
					line-height:18px;
					margin:0 !important;
				}
				.vls-heading > h6 span {
					font-weight: 600;
					font-size: 14px;
					line-height: 18px;
					margin: 20px 0 0 0 !important;
					display: block;
				}
				.position-relative {
					margin: 30px 0 0 0;
				}
				.vls-main-content .vls-heading {
					position:relative;
					margin: 20px 0;
				}
				*/
				/* ================================= */
				/* -------- main Content CSS ------- */
				/* ================================= */
				.vls-main-content {
					margin: 0 225px;
					padding: 30px 15px;
					-webkit-transition: ease all 0.5s;
					-o-transition: ease all 0.5s;
					transition: ease all 0.5s;
					display:inline-block;
					position:fixed;
					top:0px;
					left:230px;
 
				}
				.my-main {
					margin: 0 225px;
					padding: 0px 15px;
					-webkit-transition: ease all 0.5s;
					-o-transition: ease all 0.5s;
					transition: ease all 0.5s;
					display:inline-block;
					position:absolute;
					top:0px;
					width:80%;
 
				}
				.vls-menu-open .vls-main-content {
					margin-left:0;
				}
				.vls-up-date{
					font-size: 12px;
					line-height: 12px;
					color: #737373;
					margin:15px 0;
				}
				#vls-chart text.apexcharts-text tspan{
					color:red;
				}
				/*------ Content Box ------*/
				.vls-side-bar{
					position: relative;
					width: 225px;
					top:0;
					left:0;
					z-index: 999;
					background: #fff;
					overflow:hidden;
					overflow-y: auto;
					height:100%;
					z-index: 999;
					-webkit-transition: ease all 0.vls-7s;
					-o-transition: ease all 0.vls-7s;
					-moz-transition: ease all 0.vls-7s;
					transition: ease all 0.vls-7s;
					scrollbar-width: thin;
				}
				.vls-cart-box::-webkit-scrollbar-track {
					background:#ccc;
				}
				.vls-cart-box::-webkit-scrollbar {
					width: 4px;
				} 
				.vls-cart-box::-webkit-scrollbar-thumb {
					background-color:#ccc;
					-webkit-border-radius: 4px;
					border-radius: 4px;
				}
				.vls-menu-open .vls-side-bar{
					left:-100%;
					transition: ease all 0.vls-7s;
					-webkit-transition: ease all 0.vls-7s;
					-moz-transition: ease all 0.vls-7s;
					-ms-transition: ease all 0.vls-7s;
					-o-transition: ease all 0.vls-7s;
				}
				.vls-menu-action {
					font-size: 20px;
					cursor: pointer;
					background:#dc3545;
					color:#fff;
					border: 1px solid #dc3545;
					border-radius: 3px;
					width: 35px;
					height: 32px;
					position: relative;
					line-height:29px;
					text-align: center;
					margin: 0 15px 0 0;
					font-weight:700;
				}
				.vls-menu-open .vls-menu-action{
					background:#fff;
					color: #dc3545;
				}
				.vls-menu-action i{
					position: absolute;
					transform: translate(-50%, -50%);
					top:50%;
					left:50%;
				}
				.vls-menu-action i.fa-bars{
					opacity:0;
				}
				.vls-menu-open .vls-menu-action i.fa-bars{
					opacity:1;
				}
				.vls-menu-open .vls-menu-action i.fa-times{
					opacity:0;
				}
				.vls-main-wrapp {
					border: 1px solid #CED4DA;
					box-sizing: border-box;
					border-radius: 5px;
					padding: 10px 15px;
					height:100%;
				}
				
				/****/
				.vls-range-input {
					position: relative;
					height: 40px;
				}
				.vls-range-input .rs-container {
					height: auto;
				}
				.vls-range-input .rs-tooltip {
					width: auto;
					min-width: auto;
					height: auto;
					background:transparent;
					border: none;
					border-radius: 0;
					transform: translate(-50%,-22px);
					font-size: 12px;
					padding: 0;
					top:0;
				}
				.vls-range-input .rs-container .rs-pointer {
					background-color: #dc3545;
					border: 1px solid #dc3545;
					border-radius: 50%;
					height: 20px;
					width: 20px;
					box-shadow: 0 0 10px 0 rgba(0,0,0,0.3);
				}
				.vls-range-input .rs-container .-rs-pointer:hover{
					background-color: #dc3545;
				}
				.vls-range-input .rs-container .rs-pointer::after,
				.vls-range-input .rs-container .rs-pointer::before {
					display: none;
				}
				.vls-range-input .rs-container .rs-bg{
					background-color: #dc3545;
					border: 1px solid #dc3545;
					border-radius:40px;
					height:5px;
					top:8px;
				}
				.vls-range-input .rs-container .rs-selected {
					background-color: #fff;
					border: 1px solid #dc3545;
					height:5px;
					top:8px;
				}
				.rs-container .rs-scale {
					display:none;
				}
				.rs-container .rs-pointer::after {
					right: 0;
				}
				/** Right Side **/
				.vls-cg-right-side {
					background: #f6f6f6;
					padding: 25px 15px;
					text-align: center;
					position: fixed;
					right: 0;
					width: 400px;
					top: 0;
					height: 100%;
					overflow: hidden;
					overflow-y: auto;
					z-index: 999;
					-webkit-transition: ease all 0.vls-5s;
					-o-transition: ease all 0.vls-5s;
					-moz-transition: ease all 0.vls-5s;
					transition: ease all 0.vls-5s;
					scrollbar-width: thin;
				}
				.vls-cg-right-side .closebtn{
						position: absolute;
						top: 5px;
						right: 5px;
						font-size: 14px;
						margin-left: 50px;
					}
				.vls-cg-cart-box::-webkit-scrollbar-track {
					background:#ccc;
				}
				.vls-cg-cart-box::-webkit-scrollbar {
					width: 4px;
				} 
				.vls-cg-cart-box::-webkit-scrollbar-thumb {
					background-color:#E93C42;
					-webkit-border-radius: 4px;
							border-radius: 4px;
				}
				.vls-cg-right-side h4 {
					font-size: 22px;
					text-transform: uppercase;
					font-weight: 600;
				}
				.vls-cg-right-side h6{
					margin-top:15px;
					text-transform: uppercase;
					font-weight:600;
					margin-bottom:15px;
				}
				#vls-cg-donut_single{
					height:160px;
					width:100%;
				}
				#vls-cg-donut_single .apexcharts-datalabels,
				#vls-cg-donut_single .apexcharts-legend,
				#vls-cg-top_x_div .apexcharts-toolbar{
					display: none;
				}
				#vls-cg-donut_single,
				#vls-cg-donut_single .apexcharts-canvas{
					max-width: 100%;
				}
				.vls-cg-breakdown-counter {
					display: flex;
					flex-wrap: wrap;
					margin:0 -5px;
				}
				.vls-cg-breakdown {
					flex: 0 0 50%;
					max-width: 50%;
					padding: 3px 5px 0 5px;
				}
				.vls-cg-breakdown h2{
					font-size:20px;
					font-weight:600;
					margin-bottom:10px;
				}
				.vls-cg-breakdown p {
					font-size: 10px;
					line-height: 10px;
				}
				.vls-cg-table-view{
					margin-bottom:15px;
				}
				.vls-cg-table-view .table > thead > tr > th {
					border: 1px solid #999 !important;
				}
				.vls-cg-table-view .table > tbody > tr > td, 
				.vls-cg-table-view .table > tbody > tr > th, 
				.vls-cg-table-view .table > tfoot > tr > td, 
				.vls-cg-table-view .table > tfoot > tr > th, 
				.vls-cg-table-view .table > thead > tr > td, 
				.vls-cg-table-view .table > thead > tr > th {
					border: 1px solid #999;
					vertical-align: middle;
					text-align: center;
					font-size: 10px;
					line-height: normal;
				}

				
				/** Responsive **/
				@media (min-width: 1600px){
					.vls-cg-input-icon {
						width: 20%;
					}
					.vls-cg-custom-form .form-control.vls-cg-day-input {
						max-width: 10%;
					}
				}
				@media (min-width: 992px) and (max-width: 1199px) {
					.vls-cg-custom-form {
						flex-wrap: wrap;
					}
					.vls-cg-custom-form .form-control {
						padding: 3px 5px;
						margin: 0 5px;
						font-size: 12px;
					}
					.vls-cg-custom-form label {
						font-size: 14px;
					}
					.vls-cg-heading h4 {
						font-size: 16px;
					}
					.vls-cg-heading h3 {
						font-size: 20px;
						line-height: 20px;
					}
					.vls-cg-heading h2 {
						font-size: 24px;
						line-height: 24px;
					}
					.vls-cg-policy-owner-name {
						font-size: 12px;
						line-height: 12px;
						margin: 0 0 0 15px;
					}
					.vls-cg-content-box .vls-btn {
						padding:5px 4px;
						font-size: 12px;
					}
				}
				@media (max-width: 991px) {
					.vls-cg-heading h2 {
						font-size: 20px;
						line-height: 24px;
					}
					.vls-cg-side-bar{
						margin-left:-100%;
					}
					.vls-cg-menu-open .vls-cg-side-bar{
						margin-left:0;
					}
					.vls-cg-custom-form label {
						font-size: 14px;
						font-weight: 600;
					}
					.vls-cg-main-content {
						padding:60px 245px 20px 20px;
					}
					.vls-cg-content-box.vls-un-edit-box .form-control {
						padding-left:0;
						text-align: left;
					}
				}
				.appPanel {
						overflow: scroll;
						padding: 5px;
						margin:3px;
						border: 1px solid #ccc;
						border-radius:5px;
						position: fixed;
						z-index: 100;
						width: 380px;
						color: #000;
						text-align:left;
						height:90%
					}
				 .stdRow {
					 padding:3px;
					 vertical-align:top;
					 }
				.celldiv{
					border:1pt solid #d3d3d3;
					width: 95%;
					border-radius: 4px;
					margin:3px;
					padding:3px;
					background-color: #000;
					color:#fff;
				}	 
				 .roleRow {
					 padding:3px;
					 }
				 .keyItem{
					 display:inline-block;
					 padding:3px;
					 margin: 2px;
					 border-radius:5px;
					 font-size:0.8em;
				 }
			</style>		
			</head>
			<body class="vls-body">
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Lifecycle Viewer')"/></span>
								</h1>
								<div id="key" class="pull-right right-30"></div>
							</div>
						</div> 
						<!--Setup Description Section-->
					<div class="col-xs-12">
						
					<!-- Side Bar Start -->
					<aside class="vls-side-bar">
						<div class="vls-main-wrapp">
							<div class="vls-heading">
								<h3><span class="vls-text-danger">Filters</span></h3>
							</div>
							<div class="vls-heading">
									<h6><span class="vls-text-dark">Type</span></h6>
								</div>
								<select class="vls-type form-control filter">
									<option value="Technology">Technology</option>
									<option value="Application">Applications</option>
								</select>

							<div class="vls-heading vendor">
								<h6><span class="vls-text-dark">Vendor</span></h6>
							</div>
			
							<select class="vls-vendor form-control filter vendor">
								<option value="all">All</option>
							</select>

							<div class="vls-heading caps">
									<h6><span class="vls-text-dark">By Capability</span></h6>
								</div>
				
								<select class="vls-caps form-control filter caps">
									<option value="all">All</option>
								</select>
			
							<div class="vls-heading">
								<h6><span class="vls-text-dark">Lifecycle Type</span></h6>
							</div>
							
							<select class="vls-lifecycle form-control filter" id="lifecycleOptions">
						
							</select>
			
			
							<div class="vls-heading">
								<h6><span class="vls-text-dark">Years</span></h6>
							</div>
						 
								<div class="form-group">
									From: 
									<input class="filter form-control" type="text" id="fromYear" size="4"/>
								 
									To: 
									<input class="filter form-control" type="text" id="toYear" size="4"/>
								</div> 
							 
			
						</div>
					</aside>
					<!-- Side Bar Ends -->
				
					<!-- Main content Start -->
					<div class="vls-main-content my-main">
						<div class="vls-main-wrapp my-main-wrapp height-100">
								<svg id ="time-chart" height="400" width="100%">
									 
									  </svg> 
						</div>
					</div>
					<!-- Main content End -->
			
					<!-- Right Side Start -->
					<div class="vls-cg-right-side" id="slideInNav">
							<a href="javascript:void(0)" class="closebtn text-default">
									<i class="fa fa-times"></i>
								</a>
					 
						<div id="techInfo">
						</div>

	 
					</div> 
					<!-- Right Side End -->
			 
				</div>
				</div>
				</div>
		 
				<script id="life-list-template" type="text/x-handlebars-template">
					{{#each this}}
						<option><xsl:attribute name="value">{{this.id}}</xsl:attribute>{{this.name}}</option><br/>
					{{/each}}
				</script>
				<script id="info-template" type="text/x-handlebars-template">
					<h4>{{this.name}} Overview</h4>
					<div class="appPanel">
					{{#if this.applications}}
					<b>Applications Impacted</b><br/>
					{{#each this.applications}}
						<div class="celldiv"> {{this.name}}</div>
					{{/each}}
					<hr/>
					{{/if}}
					
					{{#if this.standards}}
				
					<b>Standards</b><br/>
						<table>
							<tr><th>Strength</th><th>Organisations</th><th>Geographies</th></tr>
							{{#each this.standards}}
							<tr><td colspan="3" class="roleRow"><xsl:attribute name="style">background-color:#000000;color:#fff;</xsl:attribute>{{this.componentName}}</td></tr>
								 
								<tr> {{{getStandardColour this.standardStrength}}} 
									<td class="stdRow">{{#each this.orgScope}}<i class="fa fa-caret-right"></i> {{this.name}}<br/>{{/each}}</td>
									<td class="stdRow">{{#each this.geoScope}}<i class="fa fa-caret-right"></i> {{this.name}}<br/>{{/each}}</td>
								</tr>
							{{/each}}
						 
						</table>

					{{/if}}
					{{#if this.processes}}
					<b>Processes Impacted</b><br/>
					<table>
						<tr><th>Process</th><th>Organisation</th></tr>
						{{#each this.processes}}
						<tr>  
							 <td class="stdRow">{{this.key}}</td>
							<td class="stdRow">{{#each this.values}}<div class="celldiv"><i class="fa fa-caret-right"></i> {{this.org}}</div>{{/each}}</td>
						</tr>
						{{/each}}
					 
					</table>
					{{/if}}
					</div>
				</script>
				<script id="standard-template" type="text/x-handlebars-template">
					<td class="stdRow"><xsl:attribute name="style">background-color:{{this.backgroundColour}};color:{{this.colour}};vertical-align: top;</xsl:attribute>{{this.name}}</td>
				</script>
				<script id="key-template" type="text/x-handlebars-template">
					<b>Key:</b>{{#each this.values}}
						<div class="keyItem"><xsl:attribute name="style">background-color:{{this.backgroundColour}};color:{{this.colour}}</xsl:attribute>{{this.name}}</div>
					{{/each}}
				</script>
				<script id="product-template" type="text/x-handlebars-template">
					{{#each this.years}}
						<text y="10" fill="black"><xsl:attribute name="x">{{this.pos}}</xsl:attribute>{{this.yr}}</text>
 
					{{/each}}
					{{#each this.products}} 
						{{#each this.showDates}}
							<rect height="16">
								<xsl:attribute name="style">fill:{{getColour this}}</xsl:attribute>
								<xsl:attribute name="y">{{yPos @../index 20}}</xsl:attribute>
								<xsl:attribute name="x">{{this.startPos}}</xsl:attribute>
								<xsl:attribute name="width">{{getWidth this.startPos this.endPos this}}px</xsl:attribute>
							</rect>
						{{/each}}
						<foreignObject x="2" fill="black" width="240" height="20"><xsl:attribute name="y">{{yPosText @index 20}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i> {{this.name}}</foreignObject>
					{{/each}}
					{{#each this.years}} 
						<line style="stroke:rgb(194, 194, 194);stroke-width:1;stroke-dasharray:4 4"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="y1">0</xsl:attribute>
							<xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">{{yearLines}}</xsl:attribute>
						</line> 
					{{/each}}
				</script>
				<script>		
				$('document').ready(function(){	

				});
				</script>
			</body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction"> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathAppCapSvcs" select="$apiAppCapSvcs"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathTechLife" select="$apiTechLife"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathAppLife" select="$apiAppLifeData"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathSupplier" select="$apiSupplierData"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathProcess" select="$apiProcess"></xsl:with-param>
					
					   
				</xsl:call-template>  
			</script>			
		</html>
	</xsl:template>
 
<xsl:template name="RenderViewerAPIJSFunction"> 
		<xsl:param name="viewerAPIPathApps"></xsl:param> 
		<xsl:param name="viewerAPIPathAppCapSvcs"></xsl:param> 
		<xsl:param name="viewerAPIPathTechLife"></xsl:param> 
		<xsl:param name="viewerAPIPathAppLife"></xsl:param> 
		<xsl:param name="viewerAPIPathSupplier"></xsl:param> 
		<xsl:param name="viewerAPIPathProcess"></xsl:param> 

		
		
		//a global variable that holds the data returned by an Viewer API Report 
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>'; 
		var viewAPIDataAppCapSvcs = '<xsl:value-of select="$viewerAPIPathAppCapSvcs"/>'; 
		var viewAPIDataTechLife = '<xsl:value-of select="$viewerAPIPathTechLife"/>'; 
		var viewAPIDataAppLife = '<xsl:value-of select="$viewerAPIPathAppLife"/>'; 
		var viewAPIDataSupplier = '<xsl:value-of select="$viewerAPIPathSupplier"/>'; 
		var viewAPIDataProcess = '<xsl:value-of select="$viewerAPIPathProcess"/>'; 
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
		var promise_loadViewerAPIData = function (apiDataSetURL)
		{
			return new Promise(function (resolve, reject)
			{
				if (apiDataSetURL != null)
				{
					var xmlhttp = new XMLHttpRequest();
					xmlhttp.onreadystatechange = function ()
					{
						if (this.readyState == 4 &amp;&amp; this.status == 200)
						{
							
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
						}
					};
					xmlhttp.onerror = function ()
					{
						reject(false);
					};
					
					xmlhttp.open("GET", apiDataSetURL, true);
					xmlhttp.send();
				} else
				{
					reject(false);
				}
			});
		}; 

	 	function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

		function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};

		showEditorSpinner('Fetching Data...');
		$('document').ready(function () {
			productFragment = $("#product-template").html();
			productTemplate = Handlebars.compile(productFragment);
		
			standardFragment = $("#standard-template").html();
			standardTemplate = Handlebars.compile(standardFragment);
		
			infoFragment = $("#info-template").html();
			infoTemplate = Handlebars.compile(infoFragment);
		
			keyFragment = $("#key-template").html();
			keyTemplate = Handlebars.compile(keyFragment);
		
			Handlebars.registerHelper("yPos", function (row, height) {
				return (row * height) + 18;
			});
		
			Handlebars.registerHelper("getColour", function (instance) {
				let thisLife = $('#lifecycleOptions').val();
				let lifes = lifeByType.filter((d) => {
					return d.key == thisLife;
				});
		
				let thisColour = lifes[0].values.filter((d) => {
					return d.id == instance.id
				})
				return thisColour[0].backgroundColour;
			});
		
			Handlebars.registerHelper("getStandardColour", function (instanceId) {
				let thisColours = standardsJSON.filter((d) => {
					return d.id == instanceId;
				});
		
				let thisStdColour = standardTemplate(thisColours[0])
				return thisStdColour
			});
		
			Handlebars.registerHelper("yearLines", function () {
				let cheight = $('#time-chart').height();
				return cheight + 30;
			});
		
			Handlebars.registerHelper("yPosText", function (row, height) {
				return (row * height) + 15;
			});
		
			Handlebars.registerHelper("getWidth", function (st, end, ap) {
				let wresult = end - st;
				if (wresult &lt; 0) {
					return 0
				} else {
					return end - st;
				}
			});
		
			$('#fromYear').val(moment(chartStartDate).subtract(1, 'year').format('YYYY'))
			$('#toYear').val(moment(chartEndDate).add(4, 'year').format('YYYY'))
		
			let divWidth = $('.my-main-wrapp').width();
			var svgWidth = parseInt(divWidth);
			var startDatePoint = 250;  // where timeline begins
			var dateWidth = svgWidth - (startDatePoint + 30);
			var chartStartDate = moment().subtract(18, 'months')
			var chartEndDate = moment().add(2, 'years')
			var lifeByType;
			let techJSON = [];
			let appDetailJSON = [];
			let appJSON = [];
			let productJSON = techJSON;
			let suppliers = [];
			let lifecycleTypes = [{ "id": "Lifecycle_Status", "name": "Lifecycle Status" }, { "id": "Vendor_Lifecycle_Status", "name": "Vendor Lifecycle Status" }, { "id": "Disposition_Lifecycle_Status", "name": "Disposition Lifecycle Status" }]
			let lifecycleJSON = [];
			let standardsJSON = [];
			let processJSON = [];
			let appCapsJSON = [];
			let panelOpen = 0;
			Promise.all([
				promise_loadViewerAPIData(viewAPIDataApps),
				promise_loadViewerAPIData(viewAPIDataTechLife),
				promise_loadViewerAPIData(viewAPIDataSupplier),
				promise_loadViewerAPIData(viewAPIDataAppLife),
				promise_loadViewerAPIData(viewAPIDataProcess),
				promise_loadViewerAPIData(viewAPIDataAppCapSvcs)
			]).then(function (responses) {
		
				let lifeListFragment = $("#life-list-template").html();
				techJSON = responses[1].technology_lifecycles;
				appJSON = responses[3].application_lifecycles;
				appDetailJSON = responses[0].applications;
				productJSON = techJSON;
				suppliers = responses[2].suppliers;
				lifecycleTypes = [{ "id": "Lifecycle_Status", "name": "Lifecycle Status" }, { "id": "Vendor_Lifecycle_Status", "name": "Vendor LifecycleStatus" }, { "id": "Disposition_Lifecycle_Status", "name": "Disposition Lifecycle Status" }]
				lifecycleJSON = responses[1].lifecycleJSON;
				standardsJSON = responses[1].standardsJSON;
				processJSON = responses[4].process_to_apps;
				appCapsJSON = responses[5];
		
				let capToSvs = [];
				appCapsJSON.application_capabilities_services.forEach((d) => {
					d.services.forEach((e) => {
						capToSvs.push({ "capId": d.id, "capName": d.name, "svcId": e.id });
					});
				});
		
				let capOptions = [];
				capOptions.push({ "id": "unknown", "name": "Unknown" })
				appDetailJSON.forEach((d) => {
		
					let caps = [];
					d.allServices.forEach((e) => {
						let thisCap = capToSvs.filter((f) => { return f.svcId == e.serviceId });
		
						if (thisCap.length &gt; 0) {
							thisCap.forEach((c) => {
								capOptions.push({ "id": c.capId, "name": c.capName })
								caps.push({ "id": c.capId })
							})
						}
					})
					d['caps'] = caps;
				})
		
				appJSON.forEach((e) => {
					let thisA = appDetailJSON.filter((d) => {
						return d.id == e.id;
					})
					if (thisA[0]) {
						if (thisA[0].caps.length == 0) {
							e['caps'] = [{ 'id': 'unknown' }]
						} else {
							e['caps'] = thisA[0].caps;
						}
					}
					else {
						e['caps'] = [{ 'id': 'unknown' }]
					}
				})
		
				capOptions = capOptions.filter((elem, index, self) => self.findIndex((t) => { return (t.id === elem.id) }) === index)
				capOptions.sort((a, b) => (a.name > b.name) ? 1 : -1)
		
				lifeListTemplate = Handlebars.compile(lifeListFragment);
				console.log('lifecycleTypes', lifecycleTypes)
				$('#lifecycleOptions').html(lifeListTemplate(lifecycleTypes))
				$('.vls-vendor').append(lifeListTemplate(suppliers))
				console.log('capOps', capOptions)
				$('.vls-caps').append(lifeListTemplate(capOptions))
				closeNav();
				lifeByType = d3.nest()
					.key(function (d) { return d.type; })
					.entries(lifecycleJSON);
		
				setChart();
		
				$('.filter').on('change', function () {
		
					setChart();
				});
				$('.vls-type').on('change', function () {
					let viewType = $('.vls-type').val();
					if (viewType == 'Application') {
						productJSON = appJSON;
					} else {
						productJSON = techJSON;
					}
					setChart();
				});
		
				$('.closebtn').on('click', function () {
					closeNav();
				})
		
		
			}).catch(function (error) {
				//display an error somewhere on the page
			});
		
			function openNav() {
				panelOpen = 1;
				$('#slideInNav').css('marginRight', '-0px').effect('slide', { direction: "right" }, 200);
				//document.getElementById("slideInNav").style.marginRight = "0";
			}
		
			function closeNav() {
				panelOpen = 0;
				$('#slideInNav').css('marginRight', '-400px');
				//document.getElementById("slideInNav").style.marginRight = "-352px";
			}
		
			var redrawView = function () {
				essResetRMChanges();
				let appTypeInfo = {
					"className": "Application_Provider",
					"label": 'Application',
					"icon": 'fa-desktop'
				}
		
				let workingAppsList = [];
				let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
				let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
				let apps = appArray.applications;
				let scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef], appTypeInfo);
		
				let appsToShow = [];
				console.log(scopedApps)
		
			}
		
			function getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, thisDatetoShow) {
				startDate = moment(chartStartDate);
				endDate = moment(chartEndDate);
				thisDate = moment(thisDatetoShow);
				pixels = chartWidth / (endDate - startDate);
		
				let calculatedValue = ((thisDate - startDate) * pixels) + chartStartPoint;
		
				if (calculatedValue &lt; startDatePoint) { calculatedValue = 250 }
				return calculatedValue;
		
			}
		
			function setChart() {
				if (productJSON == appJSON) {
		
					$('.vendor').hide();
					$('.caps').show();
				} else {
					$('.vendor').show();
					$('.caps').hide();
				}
		
				let startYear = $('#fromYear').val();
				let endYear = $('#toYear').val();
				let supplier = $('.vls-vendor').val();
				let capability = $('.vls-caps').val();
		
				chartStartDate = moment(startYear + '-01-01');
				chartEndDate = moment(endYear + '-01-01');
		
				let workingArr = [];
		
				if (productJSON == appJSON) {
					if (capability != 'all') {
						productJSON.forEach((f) => {
		
							if (f.caps) {
		
								f.caps.forEach((g) => {
									if (g.id == capability) { workingArr.push(f) }
								});
							};
						});
					} else {
						workingArr = productJSON;
					}
		
				}
				else {
					if (supplier != 'all') {
						productJSON.forEach((f) => {
							if (f.supplierId == supplier) { workingArr.push(f) }
						});
					} else {
						workingArr = productJSON;
					}
				}
				//console.log('workingArr',workingArr)
				let yearArr = [];
				for (let i = 0; i &lt; endYear - startYear; i++) {
					let dt = String((parseInt(startYear) + i) + '-01-01')
					let dy = moment(dt).format('YYYY-MM-DD');
					yearArr.push({ "yr": parseInt(startYear) + i, "date": dy, "pos": getPosition(startDatePoint, dateWidth, chartStartDate, chartEndDate, dy) });
				}
		
				let validLifes = []
				workingArr.forEach((d) => {
		
					let thislifeByType = d3.nest()
						.key(function (d) { return d.type; })
						.entries(d.allDates);
		
					thislifeByType = thislifeByType.filter((e) => {
						return e.key != ''
					})
		
					thislifeByType.forEach((life) => {
		
						for (let i = 0; i &lt; life.values.length; i++) {
							validLifes.push(life.values[i].id)
							let sequ = lifecycleJSON.find((lf) => {
								return lf.id == life.values[i].id;
							});
							life.values[i]['seq'] = sequ.seq;
						}
		
						life.values.sort((a, b) => parseFloat(a.seq) - parseFloat(b.seq));
		
						for (let i = 0; i &lt; life.values?.length; i++) {
		
							if (typeof life.values[i + 1] != 'undefined') {
								life.values[i]['endDate'] = life.values[i + 1].dateOf;
								life.values[i]['startPos'] = getPosition(startDatePoint, dateWidth, chartStartDate, chartEndDate, life.values[i].dateOf);
								life.values[i]['endPos'] = getPosition(startDatePoint, dateWidth, chartStartDate, chartEndDate, life.values[i]['endDate'])
							}
							else {
								life.values[i]['endDate'] = life.values[i].dateOf
								life.values[i]['startPos'] = getPosition(startDatePoint, dateWidth, chartStartDate, chartEndDate, life.values[i].dateOf);
								life.values[i]['endPos'] = getPosition(startDatePoint, dateWidth, chartStartDate, chartEndDate, life.values[i]['endDate']) + 5
		
							}
		
						}
					});
		
					d['lifecycles'] = thislifeByType;
				});
		
				let thisLife = $('#lifecycleOptions').val();
		
				let lifeType = lifeByType.filter((d) => {
					return d.key == thisLife;
				});
				uniqueArray = [...new Set(validLifes)];
		
				let keys = []
				uniqueArray.forEach((e) => {
					let match = lifeType[0].values.find((f) => {
						return f.id == e
					})
		
					if (match) { keys.push(match) }
				})
		
				let keyInfo = { "values": keys }
				$('#key').html(keyTemplate(keyInfo));
		
		
				let productsToShow = [];
				workingArr.forEach((d) => {
					//console.log('dsd',d)
					let showDates = d.lifecycles.filter((d) => {
						return d.key == thisLife;
					});
					//console.log('showDates',showDates)
					if (typeof showDates != 'undefined') {
		
						if (showDates.length &gt; 0) {
							d['showDates'] = showDates[0].values;
							if (showDates.length &gt; 0) {
								productsToShow.push(d)
							}
						}
					}
				});
		
		
				let svgH = (productsToShow.length * 21) + 30;
				let viewArray = {};
				productsToShow = productsToShow.sort((a, b) => a.name.localeCompare(b.name))
				viewArray['products'] = productsToShow;
		
				viewArray['years'] = yearArr;
				$('#time-chart').attr({ 'height': svgH + 'px' });
				$('#time-chart').html(productTemplate(viewArray));
				$('.fa-info-circle').on('click', function () {
					if (panelOpen == 1) {
						closeNav();
					}
					else {
						let theId = $(this).attr('easid');
						focus = productJSON.filter((d) => {
							return d.id == theId
						});
		
						if (productJSON == appJSON) {
							let thisDetail = appDetailJSON.filter((d) => {
								return d.id == focus[0].id;
							});
							let thisAppProcesses = [];
							thisDetail[0].physP.forEach((e) => {
								let matchedProcess = processJSON.filter((f) => {
									return f.id == e;
								});
								thisAppProcesses.push({ "id": matchedProcess[0].id, "name": matchedProcess[0].processName, "org": matchedProcess[0].org })
							});
							thisAppProcesses = thisAppProcesses.filter((v, i, a) => a.findIndex(t => (t.id === v.id)) === i)
		
							let byProcess = d3.nest()
								.key(function (d) { return d.name; })
								.entries(thisAppProcesses);
							focus[0]['processes'] = byProcess
							// processJSON
						}
		
		
						$('#techInfo').html(infoTemplate(focus[0]))
						openNav();
		
					}
				});
		
		
			}
		
		
		});
		
</xsl:template>

	<xsl:template name="GetViewerAPIPath">
		<xsl:param name="apiReport"></xsl:param>

		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderAPILinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$dataSetPath"></xsl:value-of>

	</xsl:template>
</xsl:stylesheet> 
