<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:pro="http://protege.stanford.edu/xml"
	xmlns:eas="http://www.enterprise-architecture.org/essential"
	xmlns:functx="http://www.functx.com"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" office:version="1.3">
	<xsl:import href="../../enterprise/core_el_issue_functions.xsl"/>
	<xsl:import href="../../common/core_strategic_plans.xsl"/>
	<xsl:import href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_doctype.xsl"/>
	<xsl:include href="../../common/core_common_head_content.xsl"/>
	<xsl:include href="../../common/core_header.xsl"/>
	<xsl:include href="../../common/core_footer.xsl"/>
	<xsl:include href="../../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../../common/datatables_includes.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:include href="../../common/ods_spreadsheet_files/excelTemplate.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Provider_Interface', 'Application_Provider', 'Business_Process', 'Application_Strategic_Plan', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product', 'Infrastructure_Software_Instance', 'Hardware_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Technology_Node', 'Individual_Actor', 'Application_Function', 'Application_Function_Implementation', 'Enterprise_Strategic_Plan', 'Information_Representation')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="techProds" select="/node()/simple_instance[type='Technology_Product']"/>
	<xsl:variable name="supplier" select="/node()/simple_instance[type='Supplier'][name=$techProds/own_slot_value[slot_reference='supplier_technology_product']/value]"/>

	<xsl:key name="thisTechProdRoleskey" match="/node()/simple_instance[type = 'Technology_Product_Role']" use="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
	<xsl:key name="tpukey" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="own_slot_value[slot_reference = 'provider_as_role']/value"/>
	<xsl:key name="fromkey" match="/node()/simple_instance[type = ':TPU-TO-TPU-RELATION']" use="own_slot_value[slot_reference = ':FROM']/value"/>
	<xsl:key name="tokey" match="/node()/simple_instance[type = ':TPU-TO-TPU-RELATION']" use="own_slot_value[slot_reference = ':to']/value"/>

	<xsl:key name="tparchcompkey" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="own_slot_value[slot_reference = 'contained_architecture_components']/value"/>
	<xsl:key name="tparchkey" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="own_slot_value[slot_reference = 'contained_provider_architecture_relations']/value"/>
	<xsl:key name="tpbuildkey" match="/node()/simple_instance[type = 'Technology_Product_Build']" use="own_slot_value[slot_reference = 'technology_provider_architecture']/value"/>
	<xsl:key name="appdepkey" match="/node()/simple_instance[type = 'Application_Deployment']" use="own_slot_value[slot_reference = 'application_deployment_technical_arch']/value"/>

	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>


	<xsl:variable name="externalRepo" select="/node()/simple_instance[type='External_Repository'][own_slot_value[slot_reference = 'name']/value = 'NIST']"/>
	<xsl:variable name="externalId" select="/node()/simple_instance[type='External_Instance_Reference'][own_slot_value[slot_reference = 'external_repository_reference']/value=$externalRepo/name]"/>
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
		<xsl:variable name="apiBCM">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiApp">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiProcess">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$processData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="docType"></xsl:call-template>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="eas:i18n('Vulnerability Manager - Product Mapper')"/>
				</title>

				<script src="js/d3/d3.v5.9.7.min.js"></script>
				<script src="js/FileSaver.min.js"></script>
				<script src="js/jszip/jszip.min.js"></script>
				
				<style type="text/css">
				 
				.thead input {
					width: 100%;
					}
					.ess-blob{
						margin: 0 15px 15px 0;
						border: 1px solid #ccc;
						height: 40px;
						width: 140px;
						border-radius: 4px;
						display: table;
						position: relative;
						text-align: center;
						float: left;
					}
					
					.ess-blobLabel{
						display: table-cell;
						vertical-align: middle;
						line-height: 1.1em;
						font-size: 90%;
					}
					
					.infoButton > a{
						position: absolute;
						bottom: 0px;
						right: 3px;
						color: #aaa;
						font-size: 90%;
					}
					
					#summary-content label{
						margin-bottom: 5px;
						font-weight: 600;
						display: block;
					}
					
					#summary-content h3{
						font-weight: 600;
					}
					
					.ess-tag{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						font-size: 90%;
					}
					
					.map{
						width: 100%;
						height: 400px;
						min-width: 450px;
						min-height: 400px;
					}
					
					.dashboardPanel{
						padding: 10px 15px;
						border: 1px solid #ddd;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						width: 100%;
					}
					
					.parent-superflex{
						display: flex;
						flex-wrap: wrap;
						gap: 15px;
					}
					
					.superflex{
						border: 1px solid #ddd;
						padding: 10px;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						flex-grow: 1;
						flex-basis: 1;
					}
					
					.ess-list-tags{
						padding: 0;
					}
					
					.ess-string{
						background-color: #f6f6f6;
						padding: 5px;
						display: inline-block;
					}
					
					.ess-doc-link{
						padding: 3px 8px;
						border: 1px solid #6dadda;
						border-radius: 4px;
						margin-right: 10px;
						margin-bottom: 10px;
						display: inline-block;
						font-weight: 700;
						background-color: #fff;
						font-size: 85%;
					}
					
					.ess-doc-link:hover{
						opacity: 0.65;
					}
					
					.ess-list-tags li{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						background-color: #eee;
						font-size: 85%;
					}
					.ess-list-tags-paired li{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						background-color: rgb(255, 255, 255);
						font-size: 85%;
					}
					
					@media (min-width : 1220px) and (max-width : 1720px){
						.ess-column-split > div{
							width: 450px;
							float: left;
						}
					}
					
					
					.bdr-left-blue{
						border-left: 2pt solid #5b7dff !important;
					}
					
					.bdr-left-indigo{
						border-left: 2pt solid #6610f2 !important;
					}
					
					.bdr-left-purple{
						border-left: 2pt solid #6f42c1 !important;
					}
					
					.bdr-left-pink{
						border-left: 2pt solid #a180da !important;
					}
					
					.bdr-left-red{
						border-left: 2pt solid #f44455 !important;
					}
					
					.bdr-left-orange{
						border-left: 2pt solid #fd7e14 !important;
					}
					
					.bdr-left-yellow{
						border-left: 2pt solid #fcc100 !important;
					}
					
					.bdr-left-green{
						border-left: 2pt solid #5fc27e !important;
					}
					
					.bdr-left-teal{
						border-left: 2pt solid #20c997 !important;
					}
					
					.bdr-left-cyan{
						border-left: 2pt solid #47bac1 !important;
					}
					
					@media print {
						#summary-content .tab-content > .tab-pane {
						    display: block !important;
						    visibility: visible !important;
						}
						
						#summary-content .no-print {
						    display: none !important;
						    visibility: hidden !important;
						}
						
						#summary-content .tab-pane {
							page-break-after: always;
						}
					}
					
					@media screen {						
						#summary-content .print-only {
						    display: none !important;
						    visibility: hidden !important;
						}
					}
					.stat{
						border:1pt solid #d3d3d3;
						border-radius:4px;
						margin:5px;
						padding:3px;
					}
					.productBlob{
						border:1pt solid #d3d3d3;
						border-radius: 5px;
						background-color:#ebebeb;
						margin:3px;
						padding: 2px;
					}
					.selected{
						background-color:lemonchiffon;
					}
					.nistProd{
						border:1pt solid #d3d3d3;
						border-radius: 5px;
						background-color:#f2f2f2;
						margin:3px;
						padding: 2px;
						height:37px;
					}
					.resultbox{
						font-size:14pt;
						font-weight:bold;
						border:1pt solid #d3d3d3;
						border-radius: 5px;
						background-color:#5038d5;
						color:#fff;
						margin:3px;
						padding: 2px;
					}
					.product{
						width: 250px;
						display: inline-block;
						font-size: 90%;
						margin-right: 10px;
					}
					
					.panel-text{
						max-height: 60px;
						overflow-y: auto;
						min-height: 60px
					}
					
					.circle{
						width: 20px;
						height: 20px;
						border-radius: 50%;
						font-size: 12px;
						color: #fff;
						line-height: 20px;
						text-align: center;
						display: inline-block;
					}
					
					.circleAll{
						width: 10px;
						height: 10px;
						border-radius: 50%;
						font-size: 12px;
						color: #fff;
						line-height: 20px;
						text-align: center;
						display: inline-block;
					}
					
					.CRITICAL{
						background-color: #ff0000;
						color: #ffffff
					}

					.COMPLETE{
						background-color: #ff0000;
						color: #ffffff
					}
					
					.HIGH, COMPLETE{
						background-color: #cd3232;
						color: #ffffff
					}
					
					.MEDIUM{
						background-color: #f4ad3a;
						color: #000000
					}

					.PARTIAL{
						background-color: #f4ad3a;
						color: #000000
					}
					
					.LOW{
						background-color: #9adda2;
						color: #000000
					}

					
					.NONE{
						background-color: #d3d3d3;
						color: #d3d3d3
					}
					.vulnsNum{
						text-align: center;
						vertical-align: middle;
					}
					.vulnsBox{
						background-color:#374f9d;
						padding:5px;
						margin-left:20%;
						color:#ffffff;
						text-align: center;
						vertical-align: middle;
						font-size:400%;
						width:60%;
						border:1pt solid #d3d3d3;
						border-radius:9px;
						height:60%;
					}
					.actionHolder{
						display: inline-block;
						border:1pt solid #d3d3d3;
						height:30px;
						padding:5px;
						text-align: center;
						vertical-align: middle;
						margin-left: 5px;
						border-radius:4px;
						box-shadow: 2px 1px 1px #e3e3e3;
						}
						.eas-logo-spinner {​​​​​​​​
							display: flex;
							justify-content: center;
						}​​​​​​​​
						#editor-spinner {​​​​​​​​
							height: 100vh;
							width: 100vw;
							position: fixed;
							top: 0;
							left:0;
							z-index:999999;
							background-color: hsla(255,100%,100%,0.75);
							text-align: center;
						}​​​​​​​​
						#editor-spinner-text {​​​​​​​​
							width: 100vw;
							z-index:999999;
							text-align: center;
						}​​​​​​​​
						.spin-text {​​​​​​​​
							font-weight: 700;
							animation-duration: 1.5s;
							animation-iteration-count: infinite;
							animation-name: logo-spinner-text;
							color: #aaa;
							float: left;
						}​​​​​​​​
						.spin-text2 {​​​​​​​​
							font-weight: 700;
							animation-duration: 1.5s;
							animation-iteration-count: infinite;
							animation-name: logo-spinner-text2;
							color: #666;
							float: left;
						}​​​​​​​​
						.appProgress{
							position:absolute;
							bottom:5px;
							right:5px;
						}
						.warnme{
							background-color:#fa9595; 
							padding:3px;
							margin-top:10px;
							border-radius:5px
						}
				</style>

			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				
				<!--ADD THE CONTENT-->
				<span id="mainPanel"/>
				<div id="editor-spinner" class="hidden">
					<div class="eas-logo-spinner" style="margin: 100px auto 10px auto; display: inline-block;">
						<div class="spin-icon" style="width: 60px; height: 60px;">
							<div class="sq sq1"/>
							<div class="sq sq2"/>
							<div class="sq sq3"/>
							<div class="sq sq4"/>
							<div class="sq sq5"/>
							<div class="sq sq6"/>
							<div class="sq sq7"/>
							<div class="sq sq8"/>
							<div class="sq sq9"/>
						</div>
					</div>
					<div id="editor-spinner-text" class="text-center xlarge strong spin-text2"/>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
		
			<script>
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathApp" select="$apiApp"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathProcess" select="$apiProcess"></xsl:with-param>
				</xsl:call-template>
			</script>

			<script id="panel-template" type="text/x-handlebars-template">

				<div class="container-fluid" id="summary-content">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('View')"></xsl:value-of>: 
									</span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Vulnerability Manager')"/>
									</span>
								</h1>
							</div>
						</div>
					</div>
					<!--Setup Vertical Tabs-->
					<div class="row">
					<!--	<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
							 
							<ul class="nav nav-tabs tabs-left">
								<li>
									<a href="#mapper" data-toggle="tab">
										<i class="fa fa-fw fa-tag right-10"></i>Product Mapper</a>
								</li>
							</ul>
						</div>
					-->
						<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
							<!-- Tab panes -->
							<div class="tab-content">
								<div class="tab-pane active" id="mapper">
									<p><b>Products:</b>The products listed had no NIST ID assigned at the point of last publish.  For the vulnerabilities to work each product must have a NIST ID. Click the product then click 'GO' to search NIST.  
										<br/>
										Click the spreadsheet icon next to the NIST product to add it to your loader.
									<br/><small>This product uses the NVD API but is not endorsed or certified by the NVD</small>
									</p>
									<div class="col-xs-12">
										<b>Filter:</b><xsl:text> </xsl:text>
										<input id="productFilter"></input>
										<div class="pull-right">Results: <span class="resultbox" id="resultsNum">0</span>
										</div>
									</div>
									<div class="col-xs-4" id="mappingProductList" style="height:600px; overflow-y: scroll">
									  {{#each this.products}}
									  	{{#unless cpe_id}}
										<div>
											<xsl:attribute name="class">productBlob {{#cleanId this.id}}{{/cleanId}}</xsl:attribute>
											<xsl:attribute name="id">{{this.id}}</xsl:attribute>
											<xsl:attribute name="name">{{this.name}}</xsl:attribute>
											<xsl:attribute name="supplier">{{this.supplier_technology_product.name}}</xsl:attribute>
											<div class="pull-right">
												<small> {{this.supplier_technology_product.name}}</small>
											</div>
											<span>
												<xsl:attribute name="id">cpname{{this.id}}</xsl:attribute>{{this.name}} </span>
											{{#if this.technology_provider_version}}(<span>
											<xsl:attribute name="id">cpversion{{this.id}}</xsl:attribute>{{this.technology_provider_version}}</span>){{/if}}<br/>
									</div>
										{{/unless}}
									  {{/each}}
								</div>
								<div class="col-xs-8" id="matches">
									<label>Scope of Search, add or remove terms to refine search</label>
									<input id="searchCPE" style="width:400px"/>
									<xsl:text></xsl:text>
									<button class="btn btn-sm btn-primary" id="goSearch">GO</button><div class="pull-right"><button class="btn btn-sm btn-success" id="getExcel">Get Excel</button></div>
									<br/>
									<span id="spinIcon">
										<i class="fa fa-spinner fa-spin fa-fw"></i>
										<small>If no response, refine query, try another product or wait as it may be a large data set (you may check the console to see if there is a timeout)</small><br/>
									
									</span>
									<br/>
									<i class="fa fa-file-excel-o"></i> Add to Excel
									<div class="addedbox">
										<i class="fa fa-spinner fa-spin fa-fw " style="color:red"></i>Adding</div>
									<div id="results"></div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="modal fade" id="infoModal">
					<div class="modal-dialog">
						<div class="modal-content">

							<!-- Modal Header -->
							<div class="modal-header">
								<h4 class="modal-title">Impacts</h4>
							</div>

							<!-- Modal body -->
							<div class="modal-body" id="modalContent">
							</div>

							<!-- Modal footer -->
							<div class="modal-footer">
								<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
							</div>

						</div>
					</div>
				</div>
				<!--Setup Closing Tag-->
			</div>

		</script>
		<script id="cia-template" type="text/x-handlebars-template">
		{{this}}
			<label>CIA - {{this.label}}</label>
		{{#each this scores}}
			High <span class="label label-danger">{{#ifEquals this.key 'HIGH'}}{{this.value.length}}{{else}}0{{/if}}</span>
			Medium <span class="label label-warning">{{#ifEquals this.key 'MEDIUM'}}{{this.value.length}}{{else}}0{{/if}}</span>
			Low <span class="label label-info">{{#ifEquals this.key 'LOW'}}{{this.value.length}}{{else}}0{{/if}}</span> 
			None <span class="label label-info">{{#ifEquals this.key 'NONE'}}{{this.value.length}}{{else}}0{{/if}}</span> 
		{{/each}}
		</script>
		<script id="productList-template" type="text/x-handlebars-template">
	{{#each this}}
			<div>
				<xsl:attribute name="class">productBlob </xsl:attribute>
				<xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<xsl:attribute name="name">{{this.name}}</xsl:attribute>
				<xsl:attribute name="supplier">{{this.supplier_technology_product.name}}</xsl:attribute>
				<div class="pull-right">Supplier: {{this.supplier_technology_product.name}}</div>
	   Product: <span>
				<xsl:attribute name="id">cpname{{this.id}}</xsl:attribute>{{this.name}} </span>
	  {{#if this.technology_provider_version}}(version: <span>
			<xsl:attribute name="id">cpversion{{this.id}}</xsl:attribute>{{this.technology_provider_version}}</span>){{/if}}
	</div>
	{{/each}} 
</script>
<script id="product-template" type="text/x-handlebars-template">
 
		{{#each this.products}}
			{{#each this.cpe.titles}}
	<div class="nistProd">
		<xsl:attribute name="nistID">{{../this.cpe.cpeName}}</xsl:attribute>{{this.title}} 
		<div class="actionHolder pull-right">
			<i class="fa fa-file-excel-o addtoExcel"></i>
		</div>
	</div>
			{{/each}}
		{{/each}}
</script>
<script id="impacts-template" type="text/x-handlebars-template">
	<span class="label label-warning" style="font-size:120%">	{{this.name}}</span>
	<br/>
	<br/>
	<p>
		<label>Processes:</label>
	</p>
	<ul class="ess-list-tags">
				{{#each this.processes}}
		<li>{{this.processName}} <span class="label label-info">{{this.org}}</span>
		</li> 
				{{/each}}
	</ul>
	<br/>
	<p>
		<label>Applications:</label>
	</p>
	<ul class="ess-list-tags">
				{{#each this.apps}}
		<li>{{this.name}}</li>
				{{/each}}
	</ul>

</script>
<script id="tech-list-template" type="text/x-handlebars-template">
		 
	{{#if this.vulnerabilities}}
		{{#each this.vulnerabilities}}
	<div>
		<xsl:attribute name="class">product panel panel-default C{{this.CIAC}} I{{this.CIAI}} A{{this.CIAA}} S{{this.severity}} {{this.vendor}}</xsl:attribute>
		<xsl:attribute name="data-easid">{{this.prdid}}</xsl:attribute>
		<xsl:attribute name="easvulid">{{this.vendor}}</xsl:attribute>
		<div class="panel-heading">
			<span class="large impact">{{this.vendor}}</span>
		</div>
		<div class="panel-body">
			<div class="strong large">Product</div>
			<div>{{this.product}} </div>
			<div>{{#if this.version}}
				<span class="right-5">Version:</span>
				<span>{{this.version}}</span>
						{{/if}}
			</div>
			<div class="strong large top-10">Severity</div>
			<div>
				<span>
					<xsl:attribute name="class">circleAll {{this.severity}}</xsl:attribute>
				</span>
				<span class="left-5">{{this.severity}}</span>
			</div>
			<div class="strong large top-10">Description</div>
			<div class="panel-text xsmall">
						{{this.description}}
			</div>
			<div class="strong large top-10">Status</div>
			<div class="top-5">
				<div style="display:inline-block;">
					<xsl:attribute name="class">circle {{this.CIAC}}</xsl:attribute>C</div>
				<xsl:text></xsl:text>
				<small>{{this.CIAC}}</small>
				<div style="display:inline-block;">
					<xsl:attribute name="class">circle {{this.CIAI}}</xsl:attribute>I</div>
				<xsl:text></xsl:text>
				<small>{{this.CIAI}}</small>
				<div style="display:inline-block;">
					<xsl:attribute name="class">circle {{this.CIAA}}</xsl:attribute>A</div>
				<xsl:text></xsl:text>
				<small>{{this.CIAA}}</small>
				<br/>
			</div>
			<div class="strong large top-10">CVE ID</div>
			<div class="small">
						{{#if this.cve_ID}}
				<div>{{this.cve_ID}}</div>
						{{/if}}
			</div>

			<div class="strong large top-10">Affected Versions</div>
			<div class="small">
						{{#if this.versionEndEx}}
				<div>Versions prior to: {{this.versionEndEx}}</div>
						{{else if this.versionEndInc}}
				<div>Versions upto and including: {{this.versionEndInc}}</div>
						{{else}}
							No Information
						{{/if}}
			</div>
			<div class="strong large top-10">Dates</div>
			<div class="small">
						Published:<xsl:text></xsl:text>{{published}}<br/>
						Modified:<xsl:text></xsl:text>{{modified}}
		</div>

		<div class="top-5">
			<button class="btn btn-default btn-sm impactsBtn" style="width:100%">
				<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
				<i class="fa fa-sitemap right-5"/>
				<span>Show Impacts</span>
			</button>
		</div>

	</div>
</div>
		{{/each}} 
	 	{{/if}}
</script>
 <xsl:call-template name="excelHandlebars"/>
</html>
</xsl:template>

<xsl:template name="RenderViewerAPIJSFunction">
<xsl:param name="viewerAPIPath"></xsl:param>
<xsl:param name="viewerAPIPathApp"></xsl:param>
<xsl:param name="viewerAPIPathProcess"></xsl:param>
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';	
		var viewAPIDataApp = '<xsl:value-of select="$viewerAPIPathApp"/>';	
		var viewAPIDataProcess = '<xsl:value-of select="$viewerAPIPathProcess"/>';		
		var techProds=[<xsl:apply-templates select="$techProds" mode="techProds">
<xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
</xsl:apply-templates>]
	 
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
	
			var apiProds;	

			showEditorSpinner('Fetching Data...'); 
		 
			const essentialUtilityApiUriv3 = '/essential-utility/v3';
		 
			var techAPIURL=encodeURI('classes/Technology_Product/instances?slots=name^supplier_technology_product^externalIds^technology_provider_version')
			var dataToShow=[];
			var focusSupplier;
			var excelSheet=[];
			var processed;
			var productsJSON=[<xsl:apply-templates select="$techProds" mode="TechnologyProduct"/>];
		
			$('document').ready(function (){
				
				let cveProducts=[]; 
				var panelFragment = $("#panel-template").html();
					panelTemplate = Handlebars.compile(panelFragment);

					var productFragment = $("#product-template").html();
					productTemplate = Handlebars.compile(productFragment);
					
					var productListFragment = $("#productList-template").html();
					productListTemplate = Handlebars.compile(productListFragment);

					var techListFragment = $("#tech-list-template").html();
					techListTemplate = Handlebars.compile(techListFragment);

					var impactsFragment = $("#impacts-template").html();
					impactsTemplate = Handlebars.compile(impactsFragment);
					
					var ciaFragment = $("#cia-template").html();
					ciaTemplate = Handlebars.compile(ciaFragment);

					<!-- Excel set-up -->
					var excelFragment = $('#excel-template').html();
					excelTemplate = Handlebars.compile(excelFragment);
  
					<!-- end Excel Templates -->

					
					Handlebars.registerHelper('cleanId', function(arg1) {
						return arg1.replace(/\./g,'');
					});
					
					Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
					});

					Handlebars.registerHelper('getRows', function(arg1) {
			 
						return (16384 - arg1.heading.length)
					});
					
					Handlebars.registerHelper('getRowsHead', function(arg1) {
				 
						return (16384 - ((arg1.heading.length)+1))
					});

					Handlebars.registerHelper('getData', function(arg1, arg2, arg3) {
						let row='';
						let validation=''; 
						arg1.forEach((d)=>{
							row=row+'&lt;table:table-row table:style-name="ro1">&lt;table:table-cell office:value-type="string" table:style-name="ce1">&lt;text:p> &lt;/text:p>&lt;/table:table-cell>';
					
							arg2.forEach((r)=>{
						
								let cellVal=d[r.data];
								if(!cellVal){cellVal="";} 
								
								if(arg3){
								let validationMatch=arg3.find((v)=>{return v.columnNum==i}); 
								if(validationMatch){validation=validationMatch.val}	  
								}
								if(validation.length&gt;1){
										row=row+'&lt;table:table-cell office:value-type="string" table:content-validation-name="'+validation+'" table:style-name="ce1">&lt;text:p>'+cellVal+'&lt;/text:p>&lt;/table:table-cell>';
									}
									else{
										row=row+'&lt;table:table-cell office:value-type="string" table:style-name="ce1">&lt;text:p>'+cellVal+'&lt;/text:p>&lt;/table:table-cell>';
									}
									validation='';
							})
						row=row+'&lt;table:table-cell table:number-columns-repeated="'+(16384 -(arg2.length+1))+'">&lt;/table:table-cell>&lt;/table:table-row>'; 
						
					})
					
						return row
					});

					Handlebars.registerHelper('getData2', function(arg1, arg2, arg3) {
						let row='';
						let validation=''; 
						arg1.forEach((d)=>{
						row=row+'&lt;table:table-row table:style-name="ro1">&lt;table:table-cell office:value-type="string" table:style-name="ce1">&lt;text:p> &lt;/text:p>&lt;/table:table-cell>'
						Object.keys(d).forEach(function(k,i){
							if(arg3){
								let validationMatch=arg3.find((v)=>{return v.columnNum==i}); 
								if(validationMatch){validation=validationMatch.val}	  
							}
								if(k!=='row'){ 
									if(validation.length&gt;1){
										row=row+'&lt;table:table-cell office:value-type="string" table:content-validation-name="'+validation+'" table:style-name="ce1">&lt;text:p>'+d[k]+'&lt;/text:p>&lt;/table:table-cell>';
									}
									else{
										row=row+'&lt;table:table-cell office:value-type="string" table:style-name="ce1">&lt;text:p>'+d[k]+'&lt;/text:p>&lt;/table:table-cell>';
									} 
								} 
							validation='';
						})

						row=row+'&lt;table:table-cell table:number-columns-repeated="'+(16384 -arg2)+'">&lt;/table:table-cell>&lt;/table:table-row>'; 
						
					})
					
						return row
					});

					

					Handlebars.registerHelper('getNum', function(arg1) {
						return (arg1 +1);
					});

		 Promise.all([
		 		promise_loadViewerAPIData(viewAPIDataApp),
				 promise_loadViewerAPIData(viewAPIData), 
				 promise_loadViewerAPIData(viewAPIDataProcess)
				]).then(function (responses){  
					removeEditorSpinner(); 
					apiProds=techProds; 
 
					  let bcm = responses[1];
					  let apps= responses[0];
					  let processes= responses[2].process_to_apps; 
					  
					  apiProds.forEach((d)=>{ 
						  if(d.externalIds){ nistID= d.externalIds.find((e)=>{return e.sourceName=='NIST'}) 
						  if(nistID){ d['cpe_id']=nistID.id;
								}
							}
					  })
					 
				 const capmap = bcm.busCaptoAppDetails.flatMap(o =>
                        o.apps.map(e =>({"id": o.id, "name": o.name, "appid": e}) )
					);
					 
					let cveProds=techProds.filter((p)=>{ 
						if(p.externalIds){ 
						return p.externalIds[0].sourceName=='NIST';
						}
					}) 
		 
					let vendorList=[] 
					cveProds.forEach((ven)=>{ 
						if(ven.supplier_technology_product){
						vendorList.push({"id":ven.supplier_technology_product.id, "name":ven.supplier_technology_product.name})
						}
						let thisApps = productsJSON.find((ap)=>{
							return ap.id==ven.id;
						});
						if(thisApps){
							let impactedCaps=[]; 
							thisApps.appimpacts.forEach((ap)=>{
								let thiscap=capmap.find((e)=>{
									return e.appid=ap }); if(thiscap){ 
										impactedCaps.push(thiscap) 
									} 
								}) 
										impactedCaps=impactedCaps.filter((elem, index, self) => self.findIndex( (t)=>{return (t.id === elem.id)}) === index);
							
							let capDetail=impactedCaps.forEach((cp)=>{
							 
								let bc=bcm.busCaptoAppDetails.find((c)=>{
									return cp.id ==c.id;
								}); if(bc){ ven['caps']=bc;
								}
							})
							let productProcesses=[]
							let appDetail=[]; 
							thisApps.appimpacts.forEach((ap)=>{
								let thisApp=apps.applications.find((thisApp)=>{
									return thisApp.id==ap;
								})
								if(thisApp){ 
									let thisAppProcesses=[]; thisApp.physP.forEach((pr)=>{
										let thisProcesses=processes.find((e)=>{
											return e.id==pr; }) 
											if(thisProcesses){ thisAppProcesses.push(thisProcesses) 
												productProcesses.push(thisProcesses) } }) 
												thisApp['processes']=thisAppProcesses; 
												appDetail.push(thisApp) } }) 
												productProcesses=productProcesses.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index); 
												ven['processes']=productProcesses; 
												ven['apps']=appDetail; 
												ven['apps1']=thisApps.appimpacts;
						}
					 
					 if(ven.apps){
						if(ven.apps.length&gt;0){ ven['issue']='Yes'; }else{ ven['issue']='No'; } }else{ ven['issue']='No';
						}
					}); 
					vendorList=vendorList.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index); 
					vendorList=vendorList.sort((a,b) => (a.name > b.name) ? 1 : ((b.name > a.name) ? -1 : 0))
				 
					let panelSet = new Promise(function(myResolve, myReject) { 
						techProds=techProds.filter((d)=>{
						return d.cpeid==""; }) 
						dataToShow['products']=	apiProds; 
						$('#mainPanel').html(panelTemplate(dataToShow))
						
						$('.addedbox').hide();
						myResolve(); // when successful
						myReject();  // when error
						});
 
			let focusProd, focusProdJS, focusProdName;			
			panelSet.then(function(response) { 
				$('#prodTab').hide()
				
				$("#spinIcon").hide();  
				cveProds=cveProds.sort(function(o1, o2) {
				var t1 = o1.name.toLowerCase(), t2 = o2.name.toLowerCase();
				return t1 > t2 ? 1 : t1 &lt; t2 ? -1 : 0;
			  });

 
			 let cveSelectList = cveProds.filter((elem, index, self) => self.findIndex( (t) =>{return (t.supplier_technology_product.id === elem.supplier_technology_product.id)}) === index) 
			 cveSelectList=cveSelectList.sort(function(o1, o2) {
				var t1 = o1.name.toLowerCase(), t2 = o2.name.toLowerCase();
				return t1 > t2 ? 1 : t1 &lt; t2 ? -1 : 0;
			  });
		 
			  cveSelectList.forEach((cp)=>{ 
				var option = new Option(cp.supplier_technology_product.name, cp.supplier_technology_product.id.replace(/\./g,'_')); 
				$('#selectVulns').append($(option)); 
			 
				});  

			//let cveTest=  new Promise(function(myResolve, myReject) {getCVEs(cveProds, 0)})
			//console.log('cveTest cves',cveTest)	 
 
 
			$('#productFilter').on('keyup',function(){
				let filterVal=$('#productFilter').val();
				let filterList=[] 
				if(filterVal==''){ filterList=dataToShow['products']
				}
				else{ filterList=dataToShow['products'].filter((e)=>{ 
					if(!e.supplier_technology_product){
						e['supplier_technology_product']={"name":""}}
					return e.name.toLowerCase().includes(filterVal) || e.supplier_technology_product.name.toLowerCase().includes(filterVal) 
				});
				} 
				filterList=filterList.filter((d)=>{
					return !d.cpe_id;
				})
			 
				$('#mappingProductList').html(productListTemplate(filterList))
				getBlbReady();
			});

			function getBlbReady(){ 
				$('.productBlob').on('click',function(){ 
					focusSupplier=$(this).attr('supplier') 
					$('.productBlob').removeClass('selected'); 
					$(this).addClass('selected'); 
					focusProd=$(this).attr('id'); 
					focusProdJS=$(this).attr('easid'); 
					focusProdName=$(this).attr('name');
							let searchVal = $(this).attr('supplier') +' ' +$(this).attr('name');
							$('#searchCPE').val(searchVal);
						})
			}
			
			getBlbReady();

			$('#goSearch').on('click',function(){
				let searchThis=$('#searchCPE').val(); 
				//showEditorSpinner('Fetching Data...this could take some time'); 
				$('#spinIcon').show();
				/* version1 api 
				var settings2 = {
					 "url": "https://services.nvd.nist.gov/rest/json/cpes/1.0?resultsPerPage=100&amp;keyword="+searchThis,
					"method": "GET",
					"timeout": 0 
				  };
				  */
				var settings = {
					 "url": "https://services.nvd.nist.gov/rest/json/cpes/2.0?resultsPerPage=100&amp;keywordSearch="+searchThis,
					"method": "GET",
					"timeout": 0
				  };  
				 
					  $.ajax(settings).done(function (response) {
		 
					$("#spinIcon").hide();
					 let searchResults = response;
					 removeEditorSpinner();
					$('#results').html(productTemplate(searchResults))

					$('#resultsNum').text(searchResults.totalResults)

					$('.updatecpe').on('click',function(){
						$(this).parent().hide(); 
						let nistVal=$(this).parent().parent().attr('nistID') 
						$('#'+focusProd).hide(); 
						let cpeUpdateJSON= {"id":focusProd,
						"className":"Technology_Product",
						"externalId": 
								{
									"sourceName": "NIST",
									"id": nistVal
								}
						}
				 
						essPromise_updateAPIElement('/essential-utility/v3',cpeUpdateJSON,'instances','Technology_Product')
						.then(function(response){
						 
							$('#'+focusProd).hide();
						})
					});

					$('#cancelProductUpdate').on('click', function(){
						$('#updateProductModal').modal('hide')
					})

					$('.addtoExcel').off().on('click',function(){
					 
						$('#getExcel').show();
						let nistVal=$(this).parent().parent().attr('nistID') 
						focusProdID=focusProd.replace(/\./g,'');
						$('.'+focusProdID).hide();
						console.log('focusProd',focusProd) 
						excelSheet.push({"id": focusProd, "cpe":nistVal ,"name": focusProdName})
						  
						$('.addedbox').show();
						setTimeout(hideAddBox, 2000)
						$('#results').empty();
					})

					function hideAddBox(){
						$('.addedbox').hide();
					}

					$('.addProduct').off().on('click',function(){
						$(this).hide(); 
						
						let nistVal=$(this).parent().parent().attr('nistID')
						let vendorArray = nistVal.split(':');
						let vendorName = vendorArray[3];
						let vendorProduct = vendorArray[4];
						let productVersion = vendorArray[5];
						let productVersion2 = vendorArray[6]; 
						if(productVersion2!='*'){ productVersion=productVersion +' '+ productVersion2;
						}
						let sentenceArray = $(this).parent().parent().text().split(' '); 
						sentenceArray.forEach((d)=>{ vendorName=vendorName.replace(d.toLowerCase(), d); 
							vendorProduct=vendorProduct.replace(d.toLowerCase(), d); 
							vendorProduct=vendorProduct.replace('_', ' ');
						});

						$('#updateSuppName').text(vendorName);
						$('#updateProdName').val(vendorProduct.replace('_', ' '));
						$('#updateVersionName').text(productVersion);

						 $('#updateProductModal').modal('show');
						 $('#sendProductUpdate').off().on('click', function(){
							$('#updateProductModal').modal('hide')
								let finalProdName=$('#updateProdName').val();
								let prodAddJSON= {
								"className":"Technology_Product",
								"name": finalProdName.replace('_', ' '),
								"technology_provider_version":productVersion,
								"externalId": {
											"sourceName": "NIST",
											"id": nistVal
										}
									,
								"supplier_technology_product": {
									"className": "Supplier",
									"name": vendorName
									} 
								}
 
								essPromise_createAPIElement('/essential-utility/v3',prodAddJSON,'instances','Technology_Product')
								.then(function(response){
									 
								})
							})
					})

					$('.updateProduct').on('click',function(){
						$(this).hide(); 
					
						let nistVal=$(this).parent().parent().attr('nistID')
						let vendorArray = nistVal.split(':');
						let vendorName = vendorArray[3];
						let vendorProduct = vendorArray[4];
						let productVersion = vendorArray[5];
						let productVersion2 = vendorArray[6];


						let sentenceArray = $(this).parent().parent().text().split(' '); if(productVersion2!='*'){ productVersion=productVersion +' '+ productVersion2; } sentenceArray.forEach((d)=>{ vendorName=vendorName.replace(d.toLowerCase().replaceAll('_', ' '), d); vendorProduct=vendorProduct.replace(d.toLowerCase().replaceAll('_', ' '), d);
						});

						$('#updateSuppName').text(vendorName);
						$('#updateProdName').val(vendorProduct.replace('_', ' '));
						$('#updateVersionName').text(productVersion);

						 $('#updateProductModal').modal('show')
						$('#sendProductUpdate').off().on('click', function(){
							$('#'+focusProd).hide()
							$('#updateProductModal').modal('hide')
							let finalVendProd= $('#updateProdName').val();
							let prodUpdateJSON= {"id":focusProd,
							"className":"Technology_Product",
							"name":finalVendProd.replace('_', ' '),
							"technology_provider_version":productVersion,
							"externalId": 
									{
										"sourceName": "NIST",
										"id": nistVal
									}
								
							}
						 
							essPromise_updateAPIElement('/essential-utility/v3',prodUpdateJSON,'instances','Technology_Product')
							.then(function(response){ 
								$('.'+focusProdJS).hide();
							})
						})	
					})				
				})
			})
		let processCount=[];
		let appCount=[];
		function wait(ms){
			var start = new Date().getTime();
			var end = start;
			while(end &lt; start + ms) {
				end = new Date().getTime();
			}
		}
  
		}); 
		$('#getExcel').hide();
 
		$('#getExcel').on('click',function(){
 
			let excelFile;
			excelFile={"sheets":[{
				"id":1,
				"name":"NIST ID Import",
				"worksheetNameNice":"NIST ID",
				"worksheetName":"NIST_ID",
				"description":"Maps NIST IDs to products in Essential",
				"heading":[ {"col":"B", "name":"ID", "data":"id"}, {"col":"C", "name":"Product", "data":"name"}, {"col":"D", "name":"cpe", "data":"cpe"}  ],
				"data":excelSheet
					}],
					"lookups":"false"};

		
			 <xsl:call-template name="RenderOfficetUtilityFunctions"/>
			setExcel(excelFile, 'NistIdsExport')
		})
	}); 


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
<xsl:template match="node()" mode="techProds">
<xsl:variable name="thisSupplier" select="$supplier[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
<xsl:variable name="thisCPE" select="$externalId[name=current()/own_slot_value[slot_reference='external_repository_instance_reference']/value]"/>
	
	{"id":"<xsl:value-of select="current()/name"/>",
		"jsid":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
</xsl:call-template>", 
<xsl:if test="$thisCPE">
		"externalIds":[{"sourceName": "NIST", "nistID":"<xsl:value-of select="$thisCPE/own_slot_value[slot_reference='name']/value"/>","id":"<xsl:value-of select="$thisCPE/own_slot_value[slot_reference='name']/value"/>"}],		
</xsl:if>

		"cpeid":"<xsl:value-of select="$thisCPE/own_slot_value[slot_reference='name']/value"/>",
		"supplier_technology_product":{"id":"<xsl:value-of select="$thisSupplier/name"/>", "name":"<xsl:call-template name="RenderMultiLangInstanceName">
<xsl:with-param name="theSubjectInstance" select="$thisSupplier"></xsl:with-param>
<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
</xsl:call-template>"},
		"supplier":"<xsl:call-template name="RenderMultiLangInstanceName">
<xsl:with-param name="theSubjectInstance" select="$thisSupplier"></xsl:with-param>
<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
</xsl:call-template>"	
			}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="TechnologyProduct">
<xsl:variable name="thisTechProdRoles" select="key('thisTechProdRoleskey',current()/name)"/>
<xsl:variable name="thisTPUs" select="key('tpukey',$thisTechProdRoles/name)"/>
<xsl:variable name="thisTPURelsFrom" select="key('fromkey',$thisTPUs/name)"/>
<xsl:variable name="thisTPURelsTO" select="key('tokey',$thisTPUs/name)"/>
<xsl:variable name="thisTPURels" select="$thisTPURelsFrom union $thisTPURelsTO"/>
<xsl:variable name="thisTParchcomp" select="key('tparchcompkey',$thisTPUs/name)"/>
<xsl:variable name="thisTParchdirect" select="key('tparchkey',$thisTPURels/name)"/>
<xsl:variable name="thisTechProdBuildsArchs" select="$thisTParchcomp union $thisTParchdirect"/>
<xsl:variable name="thisTechProdBuilds" select="key('tpbuildkey',$thisTechProdBuildsArchs/name)"/>
<xsl:variable name="thisAppDeps" select="key('appdepkey',$thisTechProdBuilds/name)"/>
<xsl:variable name="thissupplier" select="$supplier[name = current()/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
 
		{ "id":"<xsl:value-of select="name"/>","appimpacts":[<xsl:for-each select="$thisAppDeps">"<xsl:value-of select="current()/own_slot_value[slot_reference = 'application_provider_deployed']/value"/>"<xsl:if test="position()!=last()">,</xsl:if>
</xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

</xsl:stylesheet>
