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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Composite_Application_Provider', 'Application_Provider', 'Technology_Product', 'Business_Process')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="archivedStatus" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'SYS_CONTENT_ARCHIVED']"/>

	<xsl:variable name="organisationITUsers" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference = 'name']/value = ('Application Organisation User','Application User') or own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User']"/>
	<xsl:variable name="allActorNames" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allTechnologyProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $allActorNames/name]"/>
	<xsl:variable name="actorPlayingRole" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_to_role']/value = $organisationITUsers/name]"/>
	
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="technologyProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="tprsForTechnologyProducts" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
	<xsl:variable name="technologyComponents" select="/node()/simple_instance[type = 'Technology_Component'][own_slot_value[slot_reference = 'realised_by_technology_products']/value = $tprsForTechnologyProducts/name]"/>
	<xsl:variable name="applications" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
    <xsl:variable name="aprs" select="/node()/simple_instance[type = 'Application_Provider_Role'][own_slot_value[slot_reference = 'role_for_application_provider']/value = $applications/name]"/>
    <xsl:variable name="services" select="/node()/simple_instance[type = ('Application_Service','Composite_Application_Service')][own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $aprs/name]"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[(type = 'Supplier') and not(own_slot_value[slot_reference = 'system_content_lifecycle_status']/value = $archivedStatus/name)]"/>
	<xsl:variable name="supplier" select="$allSuppliers[$applications/own_slot_value[slot_reference = 'ap_supplier']/value = name or $technologyProducts/own_slot_value[slot_reference = 'supplier_technology_product']/value = name]"/>
	<xsl:variable name="supplierRelStatii" select="/node()/simple_instance[name = $allSuppliers/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
<!--	<xsl:variable name="supplierContracts" select="/node()/simple_instance[type = 'OBLIGATION_COMPONENT_RELATION']"/>[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $technologyProducts/name or own_slot_value[slot_reference = 'obligation_component_to_element']/value = $applications/name]-->
	
	<xsl:variable name="allContracts" select="/node()/simple_instance[(type='Contract')  and not(own_slot_value[slot_reference = 'system_content_lifecycle_status']/value = $archivedStatus/name)]"/>
	<xsl:variable name="allContractSuppliers" select="$allSuppliers[name = $allContracts/own_slot_value[slot_reference = 'contract_supplier']/value]"/>
	<xsl:variable name="allContractLinks" select="/node()/simple_instance[name = $allContracts/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
	<xsl:variable name="allContractToElementRels" select="/node()/simple_instance[name = $allContracts/own_slot_value[slot_reference = 'contract_for']/value]"/>
	<xsl:variable name="allContractElements" select="/node()/simple_instance[name = $allContractToElementRels/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
	<xsl:variable name="allLicenses" select="/node()/simple_instance[name = $allContractToElementRels/own_slot_value[slot_reference = 'ccr_license']/value]"/>
	<xsl:variable name="allRenewalModels" select="/node()/simple_instance[type='Contract_Renewal_Model']"/>
	<xsl:variable name="allContractTypes" select="/node()/simple_instance[type='Contract_Type']"/>
	<xsl:variable name="currencyRC" select="/node()/simple_instance[type='Report_Constant'][own_slot_value[slot_reference='name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[type='Currency'][name=$currencyRC/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>
	<xsl:variable name="contractedBusProcs" select="$allBusProcs"/>
	<xsl:variable name="contractedApps" select="$applications"/>
	<xsl:variable name="contractedTechProds" select="$technologyProducts"/>
	
	<xsl:variable name="allSolutionProviders" select="$allSuppliers[name = ($allBusProcs, $applications, $technologyProducts)/own_slot_value[slot_reference = ('business_process_supplier', 'ap_supplier', 'supplier_technology_product')]/value]"></xsl:variable>
	
	<!--<xsl:variable name="alllicenses" select="/node()/simple_instance[type = 'License']"/>
	<xsl:variable name="contracts" select="/node()/simple_instance[type = 'Compliance_Obligation'][own_slot_value[slot_reference = 'compliance_obligation_licenses']/value = $alllicenses/name]"/>
    
	<xsl:variable name="licenses" select="/node()/simple_instance[type = 'License'][name = $contracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
	<xsl:variable name="actualContracts" select="/node()/simple_instance[type = 'Contract'][own_slot_value[slot_reference = 'contract_uses_license']/value = $licenses/name]"/>-->
	<xsl:variable name="licenseType" select="/node()/simple_instance[type = 'License_Type']"/>
	
	
	
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
				<script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
				<!-- Searchable Select Box Libraries and Styles -->
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<!-- Date formatting library -->
				<script type="text/javascript" src="js/moment/moment.js"/>
				<!-- Bootstrap integer spinner -->
				<script type="text/javascript" src="user/js/bootstrap-input-spinner.js"/>

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
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 class="text-primary"><xsl:value-of select="eas:i18n('Supplier Contract Management')"/></h1>
							<hr/>
						</div>
						<div class="col-xs-12">
							<ul class="nav nav-tabs">
								<li class="active">
									<a data-toggle="tab" href="#supplierTab"><xsl:value-of select="eas:i18n('Suppliers')"/></a>
								</li>
                                <li>
                                	<a data-toggle="tab" href="#outlookTab"><xsl:value-of select="eas:i18n('Contract Renewal Outlook')"/></a>
								</li>
							</ul>
							<div class="tab-content">
								<div id="supplierTab" class="tab-pane fade in active">
									<!--<h3 class="strong"><xsl:value-of select="eas:i18n('Suppliers')"/></h3>		-->							
									<div class="row">										
										<div class="col-md-4">
											<div class="bottom-10">
												<label class="radio-inline"><input type="radio" name="supplierType" id="contractSupplier" class="contractSupplier" value="contract" checked="checked"/>Contract Suppliers/Resellers</label>	
												<label class="radio-inline"><input type="radio" name="supplierType" id="productSupplier" class="productSupplier" value="product"/>Product/Service Suppliers</label>																						
											</div>
											<div>
												<strong class="right-10"><xsl:value-of select="eas:i18n('Filter Suppliers')"/>:</strong>
												<input type="text" id="supplierFilter" style="min-width: 300px;"/>
											</div>
											<div id="supplierDetailsList" class="top-15" style="overflow-y:scroll;max-height:400px"/>
										</div>
										<div class="col-md-8">
											<div id="supplierSummary"/>
										</div>
									</div>
								</div>
								<div id="outlookTab" class="tab-pane fade">
									<!--<h3 class="strong"><xsl:value-of select="eas:i18n('Contract Renewal')"/> - <xsl:value-of select="eas:i18n('12 Month Outlook')"/></h3>-->
									<div class="row">
										<div class="col-xs-3">
											<!--<div class="bottom-10">
												<label class="radio-inline"><input type="radio" name="outlookListType" id="contractOutlook" value="contractOutlook" checked="checked"/><xsl:value-of select="eas:i18n('Contract Suppliers')"/></label>
												<label class="radio-inline"><input type="radio" name="outlookListType" id="productOutlook"  value="productOutlook"/><xsl:value-of select="eas:i18n('Products/Services')"/></label>																							
											</div>-->
											<div class="row">
												<div class="top-5 col-xs-12">
													<strong class="right-10"><xsl:value-of select="eas:i18n('Filter Contracts')"/>:</strong>
													<input type="text" id="outlookSupplierFilter" style="min-width: 270px;"/>	
												</div>
											</div>
										</div>
										<div class="col-xs-9">
											<div class="row">
												<div class="col-xs-8">
													<div class="pull-left right-30">
														<label class="fontBold">From Year:</label>
														<input class="date-picker form-control" style="display: inline-block; width: 100px;" data-provide="datepicker" id="outlookStartPicker"/>
													</div>
													<div class="pull-left" style="display: inline-block;">
														<span class="fontBold right-10" style="position: relative; top: 7px;">Outlook (years):</span>
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
														<span class="right-10"><strong><xsl:value-of select="eas:i18n('Sort By')"/>:</strong></span>
														<label class="radio-inline"><input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByName" value="name"/><xsl:value-of select="eas:i18n('Name')"/></label>
														<label class="radio-inline"><input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByReview" value="review"/><xsl:value-of select="eas:i18n('Review Date')"/></label>
														<label class="radio-inline"><input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByNotice" value="cancel"/><xsl:value-of select="eas:i18n('Cancellation Deadline')"/></label>
														<label class="radio-inline"><input type="radio" class="outlook-sort-radio" name="outlookSort" id="outlookByRenewal" value="end" checked="checked"/><xsl:value-of select="eas:i18n('Renewal Date')"/></label>
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
												<div id="lfHeader" style="margin-left: -10px;"/>
												<div class="lifecycle-vert-scroller">
													<!-- OUTLOOK SVG CONTAINER -->
													<div id="box" style="margin-left: -10px;"/>
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
			
			var viewData = {
				"supplierRelTypes": [<xsl:apply-templates select="$supplierRelStatii" mode="RenderEnumJSON"/>],
			"contractTypes": [<xsl:apply-templates select="$allContractTypes" mode="RenderEnumJSON"/>],
				"solutionProviders": [<xsl:apply-templates select="$allSolutionProviders" mode="RenderSolutionSupplierJSON"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
				"contractSuppliers": [<xsl:apply-templates select="$allContractSuppliers" mode="RenderContractSupplierJSON"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
				"contracts": [<xsl:apply-templates select="$allContracts" mode="RenderContractJSON"/>],
				"contractComps": [<xsl:apply-templates select="$allContractToElementRels" mode="RenderContractCompJSON"/>],
				"busProcesses": [<xsl:apply-templates select="$allBusProcs" mode="RenderContractSolutionJSON"><xsl:with-param name="supplierSlot">business_process_supplier</xsl:with-param><xsl:with-param name="icon" select="$busProcIcon"/><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
				"applications": [<xsl:apply-templates select="$applications" mode="RenderContractSolutionJSON"><xsl:with-param name="supplierSlot">ap_supplier</xsl:with-param><xsl:with-param name="icon" select="$appIcon"/><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
				"techProducts": [<xsl:apply-templates select="$technologyProducts" mode="RenderContractSolutionJSON"><xsl:with-param name="supplierSlot">supplier_technology_product</xsl:with-param><xsl:with-param name="icon" select="$techProdIcon"/><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
				"currency":"<xsl:value-of select="$currency/own_slot_value[slot_reference='currency_symbol']/value"/>"
			}
			
			var viewIcons = {
				"busProc": "fa-people",
				"app": "fa-monitor",
				"techProd": "fa-cog",
			}
	    
	    	var supplierTemplate, contractSupplierDetailsTemplate, solutionSupplierDetailsTemplate;
	    
	    	function formatCurrencyAmount(amount) {
			    if (parseInt(amount) >= 1000) {
			        return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			    } else {
			        return amount;
			    }
			}
	    
	    	function initJSONData() {
	    		//init contracts
	    		viewData.contracts.forEach(function(aContract) {
	    			aContract.supplier = viewData.contractSuppliers.find(function(aSupp) {
    					return aSupp.id == aContract.supplierId;
    				});
	    		
	    			aContract.contractComps = viewData.contractComps.filter(function(aCC) {
    					return aContract.contractCompIds.includes(aCC.id);
    				});
    				
    				aContract.busProcs = viewData.busProcesses.filter(function(solution) {
    					return aContract.busProcIds.includes(solution.id);
    				});
    				
    				aContract.apps = viewData.applications.filter(function(solution) {
    					return aContract.appIds.includes(solution.id);
    				});
    				
    				aContract.techProds = viewData.techProducts.filter(function(solution) {
    					return aContract.techProdIds.includes(solution.id);
    				});
    				
    				let contractTotal = 0;
    				aContract.contractComps.forEach(function(aCC) {
    					contractTotal = contractTotal + aCC.cost;
    				});
    				
    				if(aContract.startDate != null) {
    					aContract['prettyStartDate'] = moment(aContract.startDate).format('DD MMM YYYY');
    				}
    				
    				if(aContract.renewalDate != null) {
    					aContract['prettyRenewalDate'] = moment(aContract.renewalDate).format('DD MMM YYYY');
    				}
    				
    				aContract.totalCost = contractTotal;
    				
    				aContract.prettyTotalCost = formatCurrencyAmount(aContract.totalCost);
	    		
	    		});
	    		
	    	
	    		//init solution providers
	    		viewData.solutionProviders.forEach(function(aSupp) {
	    			aSupp.relStatus = viewData.supplierRelTypes.find(function(aStatus) {
    					return aStatus.id == aSupp.relStatusId;
    				});
	    		
	    			aSupp.busProcs = viewData.busProcesses.filter(function(solution) {
    					return aSupp.busProcIds.includes(solution.id);
    				});
	    			
	    			aSupp.apps =  viewData.applications.filter(function(solution) {
    					return aSupp.appIds.includes(solution.id);
    				});
	    			
	    			aSupp.techProds = viewData.techProducts.filter(function(solution) {
	    				return aSupp.techProdIds.includes(solution.id);
	    			});
	    			
	    			aSupp.contracts = viewData.contracts.filter(function(aContract) {
    					return aSupp.contractIds.includes(aContract.id);
    				});
    				
    				
    				let contractsTotal = 0;
    				aSupp.contracts.forEach(function(aContract) {
    					contractsTotal = contractsTotal + aContract.totalCost;
    				});
    				aSupp.totalCost = contractsTotal;
    				
    				aSupp.prettyTotalCost = formatCurrencyAmount(aSupp.totalCost);
	    		
	    		});
	    		
	    		
	    		//init contract suppliers
	    		viewData.contractSuppliers.forEach(function(aSupp) {
	    			aSupp.relStatus = viewData.supplierRelTypes.find(function(aStatus) {
    					return aStatus.id == aSupp.relStatusId;
    				});
	    		
	    			aSupp.contracts = viewData.contracts.filter(function(aContract) {
    					return aSupp.contractIds.includes(aContract.id);
    				});
    				
    				let contractsTotal = 0;
    				aSupp.contracts.forEach(function(aContract) {
    					contractsTotal = contractsTotal + aContract.totalCost;
    				});
    				aSupp.totalCost = contractsTotal;
    				
    				aSupp.prettyTotalCost = formatCurrencyAmount(aSupp.totalCost);
	    		
	    		});
	    		
	    		
	    		
	    		
	    		
	    		//init contract components
	    		viewData.contractComps.forEach(function(aCC) {
	    			aCC.contract = viewData.contracts.find(function(aContract) {
    					return aContract.id == aCC.contractId;
    				});
	    			
	    			aCC.supplier = viewData.contractSuppliers.find(function(aSupp) {
    					return aSupp.id == aCC.supplierId;
    				});
	    		
	    			aCC.busProcs = viewData.busProcesses.filter(function(solution) {
    					return aCC.busProcIds.includes(solution.id);
    				});
    				
    				aCC.apps = viewData.applications.filter(function(solution) {
    					return aCC.appIds.includes(solution.id);
    				});
    				
    				aCC.techProds = viewData.techProducts.filter(function(solution) {
    					return aCC.techProdIds.includes(solution.id);
    				});
    				
    				if(aCC.startDate != null) {
    					aCC['prettyStartDate'] = moment(aCC.startDate).format('DD MMM YYYY');
    				}
    				
    				if(aCC.renewalDate != null) {
    					aCC['prettyRenewalDate'] = moment(aCC.renewalDate).format('DD MMM YYYY');
    				}
    				
    				aCC.prettyCost = formatCurrencyAmount(aCC.cost);
	    		
	    		});
	    		
	    		
	    		//init business processes
	    		viewData.busProcesses.forEach(function(solution) {
	    			solution.supplier = viewData.solutionProviders.find(function(aSupp) {
    					return aSupp.id == solution.supplierId;
    				});
	    		
	    			solution.contractComps = viewData.contractComps.filter(function(aCC) {
    					return solution.contractCompIds.includes(aCC.id);
    				});
	    		
	    		});
	    		
	    		//init applications
	    		viewData.applications.forEach(function(solution) {
	    			solution.supplier = viewData.solutionProviders.find(function(aSupp) {
    					return aSupp.id == solution.supplierId;
    				});
	    		
	    			solution.contractComps = viewData.contractComps.filter(function(aCC) {
    					return solution.contractCompIds.includes(aCC.id);
    				});
	    		
	    		});
	    		
	    		
	    		//init tech products
	    		viewData.techProducts.forEach(function(solution) {
	    			solution.supplier = viewData.solutionProviders.find(function(aSupp) {
    					return aSupp.id == solution.supplierId;
    				});
	    		
	    			solution.contractComps = viewData.contractComps.filter(function(aCC) {
    					return solution.contractCompIds.includes(aCC.id);
    				});
	    		
	    		});
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
	        	$('.supplier').click(function(){
	        		if(supplierMode == PRODUCT_SUPPLIER_MODE) {
	        			let suppId = $(this).attr('eas-id');
	        			let thisSupp = viewData.solutionProviders.find(function(aSupp) {
	        				return aSupp.id == suppId;
						});

						thisSupp['currency']=viewData.currency;
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
						thisSupp['currency']=viewData.currency;
	        			if(thisSupp != null) {
	        				$('#supplierSummary').html(contractSupplierDetailsTemplate(thisSupp)).promise().done(function(){
				       			//add event listener for filtering solutions
				       			
							   $('#contractFilter').on( 'keyup change', function () {
						            var textVal = $(this).val().toLowerCase();
						            $('.contract').each(function(i, obj) {
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
	        		}	
	        	});
        	}
        	
        	//variables for outlook
        	var lifeColourJSON=[
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
  				
  				if(outlookSortOrder == NAME_SORT_ORDER) {
  					entries.sort(function(a, b){
			    		if (a.name.toLowerCase() &lt; b.name.toLowerCase()) {return -1;}
					  	if (b.name.toLowerCase() > a.name.toLowerCase()) {return 1;}
					  	return 0;
			    	});
  				} else {
  					entries.sort(function(a, b){
			    		if (a.earliestDates[outlookSortOrder] &lt; b.earliestDates[outlookSortOrder]) {return -1;}
					  	if (b.earliestDates[outlookSortOrder] > a.earliestDates[outlookSortOrder]) {return 1;}
					  	return 0;
			    	});				
  				}
  			}
  			
  			
  			
  			function setContractEarliestLifecycleDates(aContract) {
  				let earliestDates = {
  					"review": null,
  					"cancel": null,
  					"end": null
  				}
  				
  				aContract.lifecycle.forEach(function(aLfc) {
  					Object.keys(earliestDates).forEach(function(aStatus) {
  						if((aLfc.id == aStatus) &amp;&amp; (aLfc.dateOf != null)) {
  							if(earliestDates[aStatus] == null) {
  								earliestDates[aStatus] = aLfc.dateOf;
  							} else if(aLfc.dateOf &lt; earliestDates[aStatus]) {
  								earliestDates[aStatus] = aLfc.dateOf;
  							}
  						}
  					});
  				}); 				
  				aContract['earliestDates'] = earliestDates;
  			}
  			
  			
  			function getSupplierEarliestLifecycleDates (contractList) {
  				let earliestDates = {
  					"review": null,
  					"cancel": null,
  					"end": null
  				}
  				
  				contractList.forEach(function(aContract) {
  					aContract.lifecycle.forEach(function(aLfc) {
  						Object.keys(earliestDates).forEach(function(aStatus) {
	  						if((aLfc.id == aStatus) &amp;&amp; (aLfc.dateOf != null)) {
	  							if(earliestDates[aStatus] == null) {
	  								earliestDates[aStatus] = aLfc.dateOf;
	  							} else if(aLfc.dateOf &lt; earliestDates[aStatus]) {
	  								earliestDates[aStatus] = aLfc.dateOf;
	  							}
	  						}
  						});
  					});
  				});
  				
  				return earliestDates;
  			}
  			
  			
  			function getEarliestLifecycleDates (contractCompList) {
  				let earliestDates = {
  					"review": null,
  					"cancel": null,
  					"end": null
  				}
  				
  				contractCompList.forEach(function(aCC) {
  					aCC.lifecycle.forEach(function(aLfc) {
  						Object.keys(earliestDates).forEach(function(aStatus) {
	  						if((aLfc.id == aStatus) &amp;&amp; (aLfc.dateOf != null)) {
	  							if(earliestDates[aStatus] == null) {
	  								earliestDates[aStatus] = aLfc.dateOf;
	  							} else if(aLfc.dateOf &lt; earliestDates[aStatus]) {
	  								earliestDates[aStatus] = aLfc.dateOf;
	  							}
	  						}
  						});
  					});
  				});
  				
  				return earliestDates;
  			}
  			
  			
  			function getContractOutlookDates(aContract) {
  				let outlookDates = [];
  				let renewalDateStr = aContract.renewalDate;

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
	  						ccData.link = aCC.supplier.link + ' - '  + aCC.contract.description;
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
  					<!--let supplierData = {
  						"id": aSupp.id,
  						"name": aSupp.name,
  						"link": aSupp.link,
  						"lifecycles": [],
  						"info": aSupp
  					}-->
  					aSupp.contracts.filter(function(aContract) {
	  					return aContract.renewalDate != null;
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
	  						"info": aContract
	  					}
	  					contractData.lifecycle = getContractOutlookDates(aContract);
	  					setContractEarliestLifecycleDates(contractData);
	  					dataSet.push(contractData);
		  				<!--supplierData.lifecycles.push(contractData);-->
	  				});
	  				<!--supplierData.earliestDates = getSupplierEarliestLifecycleDates(supplierData.lifecycles);
	  				dataSet.push(supplierData);-->
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
  				<!--setContractOutlookData(viewData.contracts, contractOutlookData);-->
  				
  				<!--console.log('Solution Outlook Data');
  				console.log(solutionOutlookData);
  				
  				console.log('Contract Outlook Data');
  				console.log(contractOutlookData);-->
  			}
  			
  			
  			
  			
  			//function to refresh the outlook map
  			function createMap(allRowJSON) {
  			
	  			let rowJSON = allRowJSON;
	  			let filterVal = $('#outlookSupplierFilter').val().toLowerCase();
	  			if(filterVal.length > 0) {
	  				rowJSON = allRowJSON.filter(function(aRow) {
	  				let itemName = aRow.name.toLowerCase();
	  					return itemName.includes(filterVal);
	  				});
	  			}
	  			
  				let selectedStart = $('#outlookStartPicker').val() + '-01-01';
  				let outlookCount = $('#outlookYears').val();
  				let selectedEnd = moment(selectedStart).add(outlookCount, 'years').format('YYYY-MM-DD');
  				rowJSON = rowJSON.filter(function(aRow) {
	  				let renewDate = aRow.earliestDates.end;
	  				return renewDate >= selectedStart &amp;&amp; renewDate &lt;= selectedEnd;
	  			});
  								
				//console.log('Filtered Rows: ');
  				//console.log(rowJSON);
				
			    <!--var groupList = [];-->			
			    var showList = [];
			    let rowPos = 1;
			    startyear= new Date(new Date(outlookStartDate).getFullYear(), 0, 1).getTime(); 

		    	let productJSON = rowJSON;
			    
			    for (i = 0; i &lt; productJSON.length; i++) {
			
					let productRowPos = rowPos;
					let productRowId = 'prod' + productRowPos;
					let thisProd = productJSON[i];
			        var lifeVal = [];
			        productJSON[i].lifecycle.sort(function(a, b) {
			            return b.dateOf.localeCompare(a.dateOf);
			        });
			
			        var linestartDate= productJSON[i].lifecycle;
			        //console.log('Line Start Date');
			        //console.log(thisProd);
			        //console.log(linestartDate);
			        var numberOfElements= linestartDate.length-1;
			        var endDate=linestartDate[numberOfElements];
			        
			        var startYearPos= new Date(endDate.dateOf).getTime(); 			       
			        var startingPosition=((startYearPos-startyear)/86400000)*dayMultipler;

			        lifeLength=productJSON[i].lifecycle.length;
			        for(j=0;j&lt;lifeLength;j++){
			            var width,previousDay,previousdayFromStart;
			            life=lifeColourJSON.filter(function (d){
			                   return d.id == productJSON[i].lifecycle[j].id;
			                  });
			
						let thisLabel = productJSON[i].lifecycle[j].label;
						let thisDateStr = productJSON[i].lifecycle[j].dateOf;
						let displayDate = moment(thisDateStr).format('Do MMM YYYY');
						let originalDate = new Date(thisDateStr).getTime();
			            var thisDate = originalDate;
			            var barId = productRowId + j;
			       
			            startPosforBar=((thisDate-startYearPos)/86400000)*dayMultipler;
			            
			            if(productJSON[i].lifecycle[j-1]){     				            	
			                previousDay =new Date(productJSON[i].lifecycle[j-1].dateOf).getTime();
			                width=((previousDay-thisDate)/86400000)*dayMultipler;
			            } else {
			                width= 2;
						}
						 
			
			        //console.log(productJSON[i].lifecycle[j].dateOf+":"+thisDate+":"+width+":"+startPosforBar);  
			        lifeVal.push({"label": thisProd.name + ': ' + life[0].label, "barId": barId, "id":life[0].id,"life": life[0].name ,"displayDate": displayDate, "width": width ,"styleClass": life[0].styleClass, "colour": life[0].val , "pos": rowPos,"startPosition":startPosforBar,"exactStart":startingPosition});
			        
			       }
			        showList.push({
			        	"pos": productRowPos,
			        	"product": thisProd.link,
			        	"supplierName": thisProd.supplierName,
			        	"contractName": thisProd.contractName,
			        	"id":thisProd.id,
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
	            return "timeitem item " + d.styleClass;
	        })
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
	            colr = j - 1;
	            if (colr &lt; 0) {
	                colr = 0
	            };
	            return d.colour
	        })
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
				.attr('height', 20)
				.append('xhtml').html(function(d) {
					return outlookContractTemplate(d);
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
			        .attr("height", (15));
			        
		        // Popover Init
		        $('.view-popover').click(function(evt) {
				    $('[role="tooltip"]').remove();
				    evt.stopPropagation();
				});
				
				
				$('body').on('click', function (e) {
				if ($(e.target).data('toggle') !== 'popover'
				&amp;&amp; $(e.target).parents('.popover.in').length === 0) {
				$('[data-toggle="popover"]').popover('hide');
				}
				});
				$('.view-popover').popover({
				    container: 'body',
				    html: true,
				    trigger: 'click',
				    placement: 'auto',
				    content: function(){
				        return $(this).next().next().next().html();
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
        		sortOutlookEntries(productJSON);
        		d3.select("svg").remove();
        		
        		//console.log('Updating the Outlook: ' + outlookStartDate);
        		datesJSON = [];
        		let thisyear=new Date(outlookStartDate).getFullYear();
                for(i=0;i&lt;yearCount;i++){        
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
    
    			$('#box').html('');
                svg = d3.select("#box").append("svg")
                        .attr("width",svgWidth)
                        .attr("height", svgHeight)
                        .attr("id","box");  

                     /* add years */
                     
                var headerSvg = d3.select("#lfHeader").append("svg")
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
	    
			});
	    <!--End of Document Ready-->
	</script> 
			
			<script id="supplier-card-template" type="text/x-handlebars-template">
				{{#each this}}
					<div><xsl:attribute name="class">supplier</xsl:attribute><xsl:attribute name="eas-id">{{id}}</xsl:attribute>{{{link}}}</div>
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
						<p class="impact">{{{groupTitle}}}</p>
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
					<a tab-index="0" class="view-popover" data-toggle="popover"><i class="fa fa-info-circle text-lightgrey right-5"/></a><span class="strong">{{supplierName}}</span><span>: {{contractName}}</span>
					<!--Start Popover-->
					
					<div class="popover small">
						<p class="small">{{{info.supplier.link}}} - {{{product}}}</p>
						<table class="table small">
							<tbody>
								<tr>
									<th width="400px"><i class="fa fa-calendar right-5"/>Renewal/End Date:</th>
									<td>{{info.prettyRenewalDate}}</td>
								</tr>
								{{#if info.busProcs}}
									<tr>
										<th width="400px"><i class="fa fa-sitemap right-5"/>Business Processes:</th>
										<td>
											<ul>
												{{#each info.busProcs}}
													<li>{{{link}}}</li>
												{{/each}}
											</ul>
										</td>
									</tr>
								{{/if}}
								{{#if info.apps}}
									<tr>
										<th width="400px"><i class="fa fa-desktop right-5"/>Applications:</th>
										<td>
											<ul>
												{{#each info.apps}}
													<li>{{{link}}}</li>
												{{/each}}
											</ul>
										</td>
									</tr>
								{{/if}}
								{{#if info.techProds}}
									<tr>
										<th width="400px"><i class="fa fa-cogs right-5"/>Technology Products:</th>
										<td>
											<ul>
												{{#each info.techProds}}
													<li>{{{link}}}</li>
												{{/each}}
											</ul>
										</td>
									</tr>
								{{/if}}
								{{#if info.docLinks}}
									{{#each info.docLinks}}
										<tr>
											<th width="400px"><i class="fa fa-file right-5"/>Document:</th>
											<td>
												<a class="left-5" target="_blank"><xsl:attribute name="href">{{{url}}}</xsl:attribute>{{label}}</a>
											</td>
										</tr>
									{{/each}}
								{{/if}}
								<!--{{#if info.busProcs}}
									<tr>
										<th width="400px"><i class="fa fa-users right-5"/>Business Processes:</th>
										<td>Bus Procs</td>
									</tr>
								{{/if}}
								{{#if info.apps}}
									<tr>
										<th width="400px"><i class="fa fa-desktop right-5"/>Applications:</th>
										<td>Apps</td>
									</tr>
								{{/if}}
								{{#if info.techProds}}
									<tr>
										<th width="400px"><i class="fa fa-cogs right-5"/>Technology Products:</th>
										<td>Tech Prods</td>
									</tr>
								{{/if}}
								{{#if docLink}}
									<tr>
										<th width="400px"><i class="fa fa-doc right-5"/>Document:</th>
										<td>Doc Link</td>
									</tr>
								{/if}}-->
							</tbody>
						</table>
					</div>
					<!--End Popover-->
				</div>
			</script>
			
			
			<script id="solution-provider-summary-template" type="text/x-handlebars-template">
				<div class="top-15 hidden-md hidden-lg"></div>
				<div class="bg-offblack text-white medPadding large">
					<div class="row">
						<div class="col-sm-12 col-md-3 impact"><i class="fa fa-truck right-5"/>Supplier:</div>
						<div class="col-sm-12 col-md-3">{{{link}}}</div>
						<div class="col-sm-12 col-md-3 impact"><i class="fa fa-money right-5"/>Total Contract Value:</div>
						<div class="col-sm-12 col-md-3">{{#if totalCost}}{{currency}}{{prettyTotalCost}}{{else}}<span>-</span>{{/if}}</div>
						<!--<div class="col-sm-12 col-md-3 impact"><i class="fa fa-users right-5"/>Relationship Status:</div>
						<div class="col-sm-12 col-md-3">{{#if relStatus.name}}{{relStatus.name}}{{else}}<span>-</span>{{/if}}</div>-->
					</div>
					<div class="row">
						<div class="col-sm-12 col-md-3 impact"><i class="fa fa-list right-5"/>Description:</div>
						<div class="col-sm-12 col-md-3">{{#if description}}{{description}}{{else}}<span>-</span>{{/if}}</div>
						
					</div>
				</div>
				<h3 class="strong top-15">Solutions</h3>
				<div class="bottom-10">
					<div class="productKey small pull-left">
						<span class="right-10 impact">Key:</span>
						<i class="fa fa-money right-5 icon-color"/><span class="right-10">Total Cost</span>
						<i class="fa fa-users right-5 icon-color"/><span class="right-10"># of Licenses</span>
						<!--<i class="fa fa-th right-5 icon-color"/><span class="right-10">Cost per License</span>-->
						<i class="fa fa-file-text-o right-5 icon-color"/><span class="right-10">Contract Type</span>
						<i class="fa fa-copy right-5 icon-color"/><span class="right-10">Renewal Model</span>
						<i class="fa fa-calendar right-5 icon-color"/><span class="right-10">Renewal Date</span>
					</div>
					<div class="pull-right small bottom-10">
						<span class="impact right-10"><xsl:value-of select="eas:i18n('Filter')"/>:</span>
						<input type="text" id="solutionFilter" style="margin-top: -5px; min-width: 200px;"/>
					</div>
				</div>
				
				{{#each busProcs}}
					<div class="product">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						<div class="row">
							<div class="col-xs-12">
								<i>
									<xsl:attribute name="class">fa {{icon}} text-primary right-5</xsl:attribute>
								</i>
								<span class="solution-link strong">{{{link}}}</span>
								<!--{{#if ContractLink}}
									<a class="left-5" target="_blank"><xsl:attribute name="href">{{{ContractLink}}}</xsl:attribute><i class="fa fa-file text-midgrey"/></a>
								{{/if}}-->
							</div>
							{{#each contractComps}}
								<div class="col-xs-12">
									<div class="pull-left">
										<span class="strong">{{{supplier.link}}}</span>
										{{#if contract.docLinks}}\
											{{#each contract.docLinks}}
												<a class="left-5" target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{{url}}}</xsl:attribute><i class="fa fa-file text-midgrey"/></a>
											{{/each}}
										{{/if}}
									</div>
									<div class="pull-right">
										{{#if startDate}}
											<div class="licenceInfo type right-10">
												<span class="strong right-5">Start Date:</span>
												<span>{{prettyStartDate}}</span>
											</div>
										{{else}}
											{{#if contract.startDate}}
												<div class="licenceInfo type right-10">
													<span class="strong right-5">Start Date:</span>
													<span>{{contract.prettyStartDate}}</span>
												</div>
											{{/if}}
			                            {{/if}}
			                            {{#if renewalDate}}
											<span class="strong right-5">Renewal Date:</span>
											<span class="right-10">{{prettyRenewalDate}}</span>
										{{else}}
											{{#if contract.renewalDate}}
												<span class="strong right-5">Renewal Date:</span>
												<span class="right-10">{{contract.prettyRenewalDate}}</span>
											{{/if}}
			                            {{/if}}
			                            {{#if cost}}
											<i class="fa fa-money right-5 left-10"/><span>{{../currency}}{{prettyCost}}</span>
			                            {{/if}}
			                            {{#if contractedUnits}}
											<i class="fa fa-users right-5 left-10"/><span>{{contractedUnits}}</span>
			                            {{/if}}
			                            <!--{{#if unitCost}}
											<i class="fa fa-th right-5 left-10"/><span>{{unitCost}}</span>
			                            {{/if}}-->
			                            {{#if licenseModel}}
											<i class="fa fa-file-text-o"/><span>{{licenseModel}}</span>											
			                            {{/if}}
									</div>								
								</div>
							{{/each}}
						</div>			
					</div>	
				{{/each}}
				
				{{#each apps}}
					<div class="product">
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<div class="row">
							<div class="col-xs-12">
								<i>
									<xsl:attribute name="class">fa {{icon}} text-primary right-5</xsl:attribute>
								</i>
								<span class="solution-link strong">{{{link}}}</span>
								<!--{{#if ContractLink}}
									<a class="left-5" target="_blank"><xsl:attribute name="href">{{{ContractLink}}}</xsl:attribute><i class="fa fa-file text-midgrey"/></a>
								{{/if}}-->
							</div>
							{{#each contractComps}}
								<div class="col-xs-12">
									<div class="pull-left">
										<span class="strong">{{{supplier.link}}}</span>
										{{#if contract.docLinks}}
											{{#each contract.docLinks}}
												<a class="left-5" target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{{url}}}</xsl:attribute><i class="fa fa-file text-midgrey"/></a>
											{{/each}}
										{{/if}}
									</div>
									<div class="pull-right">
										{{#if startDate}}
											<span class="strong right-5">Start Date:</span>
											<span class="right-10">{{prettyStartDate}}</span>
										{{else}}
											{{#if contract.startDate}}
												<span class="strong right-5">Start Date:</span>
												<span class="right-10">{{contract.prettyStartDate}}</span>
											{{/if}}
			                            {{/if}}
			                            {{#if renewalDate}}
											<span class="strong right-5">Renewal Date:</span>
											<span class="right-10">{{prettyRenewalDate}}</span>
										{{else}}
											{{#if contract.renewalDate}}
												<span class="strong right-5">Renewal Date:</span>
												<span class="right-10">{{contract.prettyRenewalDate}}</span>
											{{/if}}
			                            {{/if}}
			                            {{#if cost}}
											<i class="fa fa-money right-5 left-10"/><span>{{../../currency}}{{prettyCost}}</span>
			                            {{/if}}
			                            {{#if contractedUnits}}
											<i class="fa fa-users right-5 left-10"/><span>{{contractedUnits}}</span>
			                            {{/if}}
			                            {{#if unitCost}}
											<i class="fa fa-th right-5 left-10"/><span>{{../../currency}}{{unitCost}}</span>
			                            {{/if}}
			                            {{#if licenseModel}}
											<i class="fa fa-file-text-o"/><span>{{licenseModel}}</span>											
			                            {{/if}}
									</div>								
								</div>
							{{/each}}
						</div>			
					</div>
				{{/each}}
				
				{{#each techProds}}
					<div class="product">
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<div class="row">
							<div class="col-xs-12">
								<i>
									<xsl:attribute name="class">fa {{icon}} text-primary right-5</xsl:attribute>
								</i>
								<span class="solution-link strong">{{{link}}}</span>
								
							</div>
							{{#each contractComps}}
								<div class="col-xs-12">
									<div class="pull-left">
										<span class="strong">{{{supplier.link}}}</span>
										{{#if docLinks}}
											{{#each docLinks}}
												<a class="left-5" target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{{url}}}</xsl:attribute><i class="fa fa-file text-midgrey"/></a>
											{{/each}}
										{{/if}}
									</div>
									<div class="pull-right">
										{{#if contract.type}}
											<i class="fa fa-file-text-o right-5"/><span class="right-10">{{contract.type}}</span>
			                            {{/if}}
										{{#if startDate}}
											<span class="strong right-5">Start Date:</span>
											<span class="right-10">{{prettyStartDate}}</span>
										{{else}}
											{{#if contract.startDate}}
												<span class="strong right-5">Start Date:</span>
												<span class="right-10">{{contract.prettyStartDate}}</span>
											{{/if}}
			                            {{/if}}
			                            {{#if renewalDate}}
											<span class="strong right-5">Renewal Date:</span>
											<span class="right-10">{{prettyRenewalDate}}</span>
										{{else}}
											{{#if contract.renewalDate}}
												<span class="strong right-5">Renewal Date:</span>
												<span class="right-10">{{contract.prettyRenewalDate}}</span>
											{{/if}}
			                            {{/if}}
			                            {{#if renewalNoticeDays}}
											<span class="strong right-5">Service Notice Period:</span>
											<span class="right-10">{{renewalNoticeDays}} days</span>
										{{else}}
											{{#if contract.renewalNoticeDays}}
												<span class="strong right-5">Service Notice Period:</span>
												<span class="right-10">{{contract.renewalNoticeDays}} days</span>
											{{/if}}
			                            {{/if}}
			                            {{#if cost}}
											<i class="fa fa-money right-5 left-10"/><span>{{prettyCost}}</span>
			                            {{/if}}
			                            {{#if contractedUnits}}
											<i class="fa fa-users right-5 left-10"/><span>{{contractedUnits}}</span>
			                            {{/if}}
			                            {{#if unitCost}}
											<i class="fa fa-th right-5 left-10"/><span>{{unitCost}}</span>
			                            {{/if}}
			                            {{#if licenseModel}}
											<i class="fa fa-file-text-o"/><span>{{licenseModel}}</span>											
			                            {{/if}}
									</div>								
								</div>
							{{/each}}
						</div>			
					</div>
				{{/each}}
			</script>
			
			
			
			<script id="contract-supplier-summary-template" type="text/x-handlebars-template">
				<div class="top-15 hidden-md hidden-lg"></div>
				<div class="bg-offblack text-white medPadding large">
					<div class="row">
						<div class="col-sm-12 col-md-3 impact"><i class="fa fa-truck right-5"/>Supplier:</div>
						<div class="col-sm-12 col-md-3">{{{link}}}</div>
						<div class="col-sm-12 col-md-3 impact"><i class="fa fa-users right-5"/>Relationship Status:</div>
						<div class="col-sm-12 col-md-3">{{#if relStatus.name}}{{relStatus.name}}{{else}}<span>-</span>{{/if}}</div>
					</div>
					<div class="row">
						<div class="col-sm-12 col-md-3 impact"><i class="fa fa-list right-5"/>Description:</div>
						<div class="col-sm-12 col-md-3">{{#if description}}{{description}}{{else}}<span>-</span>{{/if}}</div>
						<div class="col-sm-12 col-md-3 impact"><i class="fa fa-money right-5"/>Total Contract Value:</div>
						<div class="col-sm-12 col-md-3">{{#if totalCost}}{{currency}}{{prettyTotalCost}}{{else}}<span>-</span>{{/if}}</div>
					</div>
				</div>
				<h3 class="strong top-10">Contracts</h3>
				<div class="bottom-10">
					<div class="productKey small pull-left">
						<span class="right-10 impact">Key:</span>
						<i class="fa fa-money right-5 icon-color"/><span class="right-10">Total Cost</span>
						<i class="fa fa-users right-5 icon-color"/><span class="right-10"># of Licenses</span>
						<!--<i class="fa fa-th right-5 icon-color"/><span class="right-10">Cost per License</span>-->
						<i class="fa fa-file-text-o right-5 icon-color"/><span class="right-10">Contract Type</span>
						<i class="fa fa-copy right-5 icon-color"/><span class="right-10">Renewal Model</span>
						<i class="fa fa-calendar right-5 icon-color"/><span class="right-10">Renewal Date</span>
					</div>
					<div class="pull-right">
						<strong class="right-10"><xsl:value-of select="eas:i18n('Filter')"/>:</strong>
						<input type="text" id="contractFilter" style="min-width: 200px;"/>
					</div>
				</div>
				{{#each contracts}}
					<div class="contract top-20">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						<div class="row">
							<div class="col-xs-12">
								<p><strong>{{description}}</strong></p>							
							</div>		
							<div class="col-xs-12">
								{{#if type}}
									<i class="fa fa-file-text-o right-5 strong"/><span class="right-5">{{type}}</span>
	                            {{/if}}
								{{#if startDate}}
									<span class="strong left-20 right-5">Start Date:</span>
									<span class="right-15">{{prettyStartDate}}</span>
			                    {{/if}}
			                    {{#if renewalDate}}
									<span class="strong right-5">Renewal Date:</span>
									<span class="right-15">{{prettyRenewalDate}}</span>
	                            {{/if}}
	                            {{#if renewalNoticeDays}}
									<span class="strong right-5">Service Notice Period:</span>
									<span class="right-15">{{renewalNoticeDays}} days</span>
	                            {{/if}}
	                            {{#if totalCost}}
									<i class="fa fa-money right-5 strong"/><span class="right-15">{{../currency}}{{prettyTotalCost}}</span>
	                            {{/if}}
	                            {{#if docLinks}}
		                            {{#each docLinks}}
										<span class="strong right-5">Document:</span>
										<a target="_blank"><xsl:attribute name="title">{{label}}</xsl:attribute><xsl:attribute name="href">{{url}}</xsl:attribute><i class="fa fa-file text-midgrey"/></a>
									{{/each}}                           	
								{{/if}}
							</div>
							{{#each contractComps}}
								<div class="col-xs-12 top-20">
									<div class="pull-left">
			                            {{#if cost}}
											<i class="fa fa-money right-5"/><span class="right-15">{{../../currency}}{{prettyCost}}</span>
			                            {{/if}}
			                            {{#if contractedUnits}}
											<i class="fa fa-users right-5"/><span class="right-15">{{contractedUnits}}</span>
			                            {{/if}}
			                            {{#if unitCost}}
											<i class="fa fa-th right-5"/><span class="right-15">{{../../currency}}{{unitCost}}</span>
			                            {{/if}}
			                            {{#if renewalModel}}
											<i class="fa fa-copy right-5"/><span class="right-15">{{renewalModel}}</span>											
			                            {{/if}}
									</div>
								</div>
								{{#each busProcs}}
									<div class="col-xs-4">
										<div class="pull-left">
											<i>
												<xsl:attribute name="class">fa {{icon}} text-primary left-10 right-5</xsl:attribute>
											</i>
											<span class="strong">{{{link}}}</span>
											<!--{{#if description}}
												<span > - {{description}}</span>
											{{/if}}-->
										</div>
										<!--<div class="pull-right">
				                            {{#if ../cost}}
												{{#if @first}}<i class="fa fa-money right-5 left-10"/><span>{{../cost}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../contractedUnits}}
												{{#if @first}}<i class="fa fa-users right-5 left-10"/><span>{{../contractedUnits}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../unitCost}}
												{{#if @first}}<i class="fa fa-th right-5 left-10"/><span>{{../unitCost}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../renewalModel}}
												{{#if @first}}<i class="fa fa-file-text-o"/><span>{{../renewalModel}}</span>{{/if}}											
				                            {{/if}}
										</div>	-->							
									</div>
								{{/each}}
								{{#each apps}}
									<div class="col-xs-4">
										<div class="pull-left">
											<i>
												<xsl:attribute name="class">fa {{icon}} text-primary right-5</xsl:attribute>
											</i>
											<span class="strong">{{{link}}}</span>
											<!--{{#if description}}
												<span > - {{description}}</span>
											{{/if}}-->
										</div>
										<!--<div class="pull-right">
				                            {{#if ../cost}}
												{{#if @first}}<i class="fa fa-money right-5 left-10"/><span>{{../cost}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../contractedUnits}}
												{{#if @first}}<i class="fa fa-users right-5 left-10"/><span>{{../contractedUnits}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../unitCost}}
												{{#if @first}}<i class="fa fa-th right-5 left-10"/><span>{{../unitCost}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../renewalModel}}
												{{#if @first}}<i class="fa fa-file-text-o"/><span>{{../renewalModel}}</span>{{/if}}											
				                            {{/if}}
										</div>	-->							
									</div>
								{{/each}}
								{{#each techProds}}
									<div class="col-xs-4">
										<div class="pull-left">
											<i>
												<xsl:attribute name="class">fa {{icon}} text-primary right-5</xsl:attribute>
											</i>
											<span class="strong">{{{link}}}</span>
											<!--{{#if description}}
												<span > - {{description}}</span>
											{{/if}}-->
										</div>
										<!--<div class="pull-right">
				                            {{#if ../cost}}
												{{#if @first}}<i class="fa fa-money right-5 left-10"/><span>{{../cost}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../contractedUnits}}
												{{#if @first}}<i class="fa fa-users right-5 left-10"/><span>{{../contractedUnits}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../unitCost}}
												{{#if @first}}<i class="fa fa-th right-5 left-10"/><span>{{../unitCost}}</span>{{/if}}
				                            {{/if}}
				                            {{#if ../renewalModel}}
												{{#if @first}}<i class="fa fa-file-text-o"/><span>{{../renewalModel}}</span>{{/if}}											
				                            {{/if}}
										</div>-->								
									</div>
								{{/each}}								
								
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
								<i class="fa fa-money right-5 "/><span>{{../currency}}
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
									<i class="fa fa-money right-5 "/><span>{{../currency}}{{current.0.licenseCostContract}}</span>
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
									<i class="fa fa-money right-5 "/><span>{{../currency}}{{future.0.licenseCostContract}}</span>
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
						<strong>Potential Saving: </strong><span>{{totalPercent}}</span>
						<button class="btn btn-default licenceInfo cls pull-right">
							<i class="fa fa-times right-5"/>
							<span>Discard</span>  
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
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisSupplierRelStatus" select="$supplierRelStatii[name = $this/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
		<xsl:variable name="thisSuppRelStatusName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisSupplierRelStatus"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisContracts" select="$allContracts[own_slot_value[slot_reference = 'contract_supplier']/value = $this/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>"
		,"name": "<xsl:value-of select="$thisName"/>"
		,"link": "<xsl:value-of select="$thisLink"/>"
		,"description": "<xsl:value-of select="$thisDesc"/>"
		,"relStatusId": "<xsl:value-of select="eas:getSafeJSString($thisSupplierRelStatus/name)"/>"
		,"contractIds": [<xsl:for-each select="$thisContracts/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderSolutionSupplierJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisBusProcs" select="$allBusProcs[own_slot_value[slot_reference = 'business_process_supplier']/value = $this/name]"/>
		<xsl:variable name="thisApps" select="$applications[own_slot_value[slot_reference = 'ap_supplier']/value = $this/name]"/>
		<xsl:variable name="thisTechProds" select="$technologyProducts[own_slot_value[slot_reference = 'supplier_technology_product']/value = $this/name]"/>
		
		<xsl:variable name="thisContractComps" select="$allContractToElementRels[own_slot_value[slot_reference = 'contract_component_to_element']/value = ($thisBusProcs, $thisApps, $thisTechProds)/name]"/>
		<xsl:variable name="thisContracts" select="$allContracts[name = $thisContractComps/own_slot_value[slot_reference = 'contract_component_from_contract']/value]"/>
		
		<xsl:variable name="thisSupplierRelStatus" select="$supplierRelStatii[name = $this/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>"
		,"name": "<xsl:value-of select="$thisName"/>"
		,"link": "<xsl:value-of select="$thisLink"/>"
		,"description": "<xsl:value-of select="$thisDesc"/>"
		,"relStatusId": "<xsl:value-of select="eas:getSafeJSString($thisSupplierRelStatus/name)"/>"
		,"busProcIds": [<xsl:for-each select="$thisBusProcs/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"appIds": [<xsl:for-each select="$thisApps/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"techProdIds": [<xsl:for-each select="$thisTechProds/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"contractIds": [<xsl:for-each select="$thisContracts/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderContractJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDocLinks" select="$allContractLinks[name = $this/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
		<xsl:variable name="thisSupplier" select="$allSuppliers[name = $this/own_slot_value[slot_reference = 'contract_supplier']/value]"/>
		<xsl:variable name="thisContractRels" select="$allContractToElementRels[own_slot_value[slot_reference = 'contract_component_from_contract']/value = $this/name]"/>
		<xsl:variable name="currentRenewalModel" select="$allRenewalModels[name = ($this, $thisContractRels)/own_slot_value[slot_reference = ('contract_renewal_model', 'ccr_renewal_model')]/value]"/>
		
		<xsl:variable name="contractSigDate" select="$this/own_slot_value[slot_reference = 'contract_signature_date_ISO8601']/value"/>
		<xsl:variable name="contractRenewalDate" select="$this/own_slot_value[slot_reference = 'contract_end_date_ISO8601']/value"/>
		<xsl:variable name="contractCost" select="$this/own_slot_value[slot_reference = 'contract_total_annual_cost']/value"/>
		<xsl:variable name="contractType" select="$allContractTypes[name = $this/own_slot_value[slot_reference = 'contract_type']/value]"></xsl:variable>
		<xsl:variable name="supplierRelStatus" select="$supplierRelStatii[name = $thisSupplier/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
		<xsl:variable name="renewalNoticeDays">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalReviewDays">
			<xsl:choose>
				<xsl:when test="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value">
					<xsl:value-of select="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="thisBusProcs" select="$contractedBusProcs[name = $thisContractRels/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
		<xsl:variable name="thisApps" select="$contractedApps[name = $thisContractRels/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
		<xsl:variable name="thisTechProds" select="$contractedTechProds[name = $thisContractRels/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>"
		,"description": "<xsl:value-of select="$thisDesc"/>"
		,"supplierId": "<xsl:value-of select="eas:getSafeJSString($thisSupplier/name)"/>"
		,"relStatusId": "<xsl:value-of select="eas:getSafeJSString($supplierRelStatus/name)"/>"
		,"startDate": <xsl:choose><xsl:when test="string-length($contractSigDate) > 0">"<xsl:value-of select="$contractSigDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalDate": <xsl:choose><xsl:when test="string-length($contractRenewalDate) > 0">"<xsl:value-of select="$contractRenewalDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalNoticeDays": <xsl:value-of select="$renewalNoticeDays"/>
		,"renewalReviewDays": <xsl:value-of select="$renewalReviewDays"/>
		,"renewalModel": <xsl:choose><xsl:when test="count($currentRenewalModel) > 0">"<xsl:value-of select="$currentRenewalModel[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		<xsl:choose><xsl:when test="$contractType">,"type": "<xsl:value-of select="$contractType/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when></xsl:choose>
		<xsl:choose><xsl:when test="$contractCost">,"cost": <xsl:value-of select="$contractCost"/></xsl:when></xsl:choose>
		<xsl:choose><xsl:when test="count($thisDocLinks) > 0">,"docLinks": [
			<xsl:for-each select="$thisDocLinks">
				<xsl:variable name="thisLink" select="current()"/>
				<xsl:variable name="thisLinkName" select="$thisLink/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="thisUrl" select="$thisLink/own_slot_value[slot_reference = 'external_reference_url']/value"/>
				{
				"label": "<xsl:value-of select="$thisLinkName"/>",
				"url": "<xsl:value-of select="$thisUrl"/>"
				}<xsl:if test="not(position() = last())">,
				</xsl:if>
			</xsl:for-each>
		]</xsl:when></xsl:choose>
		,"contractCompIds": [<xsl:for-each select="$thisContractRels/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"busProcIds": [<xsl:for-each select="$thisBusProcs/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"appIds": [<xsl:for-each select="$thisApps/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"techProdIds": [<xsl:for-each select="$thisTechProds/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderContractCompJSON">
		<xsl:variable name="this" select="current()"/>
		
		
		<xsl:variable name="currentContract" select="$allContracts[name = $this/own_slot_value[slot_reference = 'contract_component_from_contract']/value]"/>
		<xsl:variable name="currentContractLinks" select="$allContractLinks[name = $currentContract/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
		<xsl:variable name="currentContractSupplier" select="$allSuppliers[name = $currentContract/own_slot_value[slot_reference = 'contract_supplier']/value]"/>
		<xsl:variable name="supplierRelStatus" select="$supplierRelStatii[name = $currentContractSupplier/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
		
		<xsl:variable name="currentLicense" select="$allLicenses[name = $this/own_slot_value[slot_reference = 'ccr_license']/value]"/>
		<xsl:variable name="currentLicenseType" select="$licenseType[name = $currentLicense/own_slot_value[slot_reference = 'license_type']/value]"/>
		
		<xsl:variable name="currentRenewalModel" select="$allRenewalModels[name = ($this, $currentContract)/own_slot_value[slot_reference = ('ccr_renewal_model', 'contract_renewal_model')]/value]"/>
		<xsl:variable name="startDate">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currentContract/own_slot_value[slot_reference = 'contract_signature_date_ISO8601']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalDate">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'contract_end_date_ISO8601']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalNoticeDays">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value"/>
				</xsl:when>
				<xsl:when test="$currentContract/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value">
					<xsl:value-of select="$currentContract/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalReviewDays">
			<xsl:choose>
				<xsl:when test="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value">
					<xsl:value-of select="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currentContractedUnits">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_contracted_units']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_contracted_units']/value"/>
				</xsl:when>
				<xsl:otherwise>null</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currentContractTotal">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:variable name="currentCostPerUnit">
			<xsl:choose>
				<xsl:when test="$currentContractedUnits > 0 and $currentContractTotal > 0">
					<xsl:value-of select="$currentContractTotal div $currentContractedUnits"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>-->
		
		<xsl:variable name="thisBusProcs" select="$contractedBusProcs[name = $this/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
		<xsl:variable name="thisApps" select="$contractedApps[name = $this/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
		<xsl:variable name="thisTechProds" select="$contractedTechProds[name = $this/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>"
		,"contractId": "<xsl:value-of select="eas:getSafeJSString($currentContract/name)"/>"
		,"docLinks": <xsl:choose><xsl:when test="count($currentContractLinks) > 0"> [
			<xsl:for-each select="$currentContractLinks">
				<xsl:variable name="thisLink" select="current()"/>
				<xsl:variable name="thisLinkName" select="$thisLink/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="thisUrl" select="$thisLink/own_slot_value[slot_reference = 'external_reference_url']/value"/>
				{
				"label": "<xsl:value-of select="$thisLinkName"/>",
				"url": "<xsl:value-of select="$thisUrl"/>"
				}<xsl:if test="not(position() = last())">,
				</xsl:if>
			</xsl:for-each>
			]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"supplierId": "<xsl:value-of select="eas:getSafeJSString($currentContractSupplier/name)"/>"
		,"startDate": <xsl:choose><xsl:when test="string-length($startDate) > 0">"<xsl:value-of select="$startDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalDate": <xsl:choose><xsl:when test="string-length($renewalDate) > 0">"<xsl:value-of select="$renewalDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalNoticeDays": <xsl:value-of select="$renewalNoticeDays"/>
		,"renewalReviewDays": <xsl:value-of select="$renewalReviewDays"/>
		,"renewalModel": <xsl:choose><xsl:when test="count($currentRenewalModel) > 0">"<xsl:value-of select="$currentRenewalModel[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"licenseModel": <xsl:choose><xsl:when test="count($currentLicenseType) > 0">"<xsl:value-of select="$currentLicenseType/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"contractedUnits": <xsl:value-of select="$currentContractedUnits"/>
		,"cost": <xsl:choose><xsl:when test="$currentContractTotal"><xsl:value-of select="$currentContractTotal"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
		,"busProcIds": [<xsl:for-each select="$thisBusProcs/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"appIds": [<xsl:for-each select="$thisApps/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"techProdIds": [<xsl:for-each select="$thisTechProds/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderContractSolutionJSON">
		<xsl:param name="supplierSlot"/>
		<xsl:param name="icon"/>
		
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisSupplier" select="$allSuppliers[name = $this/own_slot_value[slot_reference = $supplierSlot]/value]"/>
		<xsl:variable name="thisContractComps" select="$allContractToElementRels[own_slot_value[slot_reference = 'contract_component_to_element']/value = $this/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>"
		,"name": "<xsl:value-of select="$thisName"/>"
		,"link": "<xsl:value-of select="$thisLink"/>"
		,"description": "<xsl:value-of select="$thisDesc"/>"
		,"icon": "<xsl:value-of select="$icon"/>"
		,"supplierId": "<xsl:value-of select="eas:getSafeJSString($thisSupplier/name)"/>"
		,"contractCompIds": [<xsl:for-each select="$thisContractComps/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderEnumJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName" select="$this/own_slot_value[slot_reference = 'enumeration_value']/value"/>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>"
		,"name": "<xsl:value-of select="$thisName"/>"
		,"description": "<xsl:value-of select="$thisDesc"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>
