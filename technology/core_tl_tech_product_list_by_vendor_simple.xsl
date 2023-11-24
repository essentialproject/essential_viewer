<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>



	<xsl:output method="html"/>

	<!--
		* Copyright © 2008-2018 Enterprise Architecture Solutions Limited.
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
	<!-- 30.07.2018	JWC i18N version of catalogue -->


	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Supplier')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Product Catalogue by Vendor')"/>
	</xsl:variable>
	<xsl:variable name="techProdListByComponentCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Product Catalogue by Technology Component')]"/>
	<xsl:variable name="techProdListByCapCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Product Catalogue by Technology Capability')]"/>
	<xsl:variable name="techProdListAsTableCatalogue" select="eas:get_report_by_name('Core: Technology Product Cataloigue as Table')"/>
	<xsl:variable name="allTechSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>

	<xsl:variable name="catalogueTitle" select="eas:i18n('Technology Product Catalogue by Vendor')"/>
	<xsl:variable name="catalogueSectionTitle" select="eas:i18n('Technology Product Catalogue')"/>
	<xsl:variable name="catalogueIntro" select="eas:i18n('Please click on one of the Technology Products below to navigate to the required view')"/>

	<xsl:variable name="vIcon" select="$activeViewerStyle/own_slot_value[slot_reference = 'viewer_icon_colour']/value"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="BuildPage"/>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script type="text/javascript" src="js/jquery.columnizer.js?release=6.19"/>
				<!--script to turn the app providers list into columns-->
				<link href="js/select2/css/select2.min.css?release=6.19" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js?release=6.19"/>
				<style>
					.productElement{
						border: 1pt solid #ccc;
						box-shadow: 1px 1px 2px hsla(0, 0%, 0%, 0.25);
						padding: 10px;
						max-height: 36px;
						overflow: hidden;
						margin: 5px 0;
						border-radius: 4px;
						width: 100%;
						display: flex;
						align-items: center;
						border-left: 3pt solid <xsl:value-of select="$vIcon"/>;
						
					}
					
					.productElement > .supplier{
						margin-right: 5px;
						display: flex;
						align-items: center;
					}
					.productElement > .product{
						display: flex;
						align-items: center;
					}
					.catalogueList{
						max-height: 350px;
						overflow-x: hidden;
						overflow-y: auto;
					}</style>

			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-primary">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByComponentCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Component'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByCapCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Capability'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Vendor')"/>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListAsTableCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Table'"/>
										</xsl:call-template>
									</span>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="$catalogueSectionTitle"/>
							</h2>

							<p><xsl:value-of select="$catalogueIntro"/>.</p>
						</div>
						<div class="col-xs-12">
							<div class="content-section">
								<div class="row">
									<div class="col-xs-3">
										<h3>Supplier</h3>
										<select id="supplierName" class="supplierName" style="width: 100%">
											<option/>
											<xsl:apply-templates select="$allTechSuppliers" mode="options">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											</xsl:apply-templates>
										</select>
									</div>
									<div class="col-xs-9">
										<h3>Products</h3>
										<div id="supplierBlock"/>
									</div>
									<div class="clear"/>
								</div>
							</div>
						</div>
					</div>
				</div>
				<script>
	supplierJSON=[<xsl:apply-templates select="$allTechSuppliers" mode="getSuppliers"/>]     
    				
    function addFilterListener() {
    	$('#catalogue-filter').on( 'keyup change', function () {
     	   var textVal = $(this).val().toLowerCase();
	       $('.product').each(function(i, obj) {
	            $(this).show();
	            if(textVal != null) {
	                var itemName = $(this).text().toLowerCase();
	                if(!(itemName.includes(textVal))) {
	                    $(this).parent().parent().hide();
	                }
	            }
	        });
	    });			
    };
                    

    				
    $(document).ready(function() {                    
        $('select').select2({
	    	'placeholder': 'Select a Supplier',
	    	theme: "bootstrap"
	    });

        var techCardFragment   = $("#tech-card-template").html();
            techCardTemplate = Handlebars.compile(techCardFragment);
    
     	<!--$('#supplierBlock').html(techCardTemplate(supplierJSON[0])).promise().done(function(){
     		addFilterListener()
     	});-->
     	
        $('.supplierName').change(function(d){
	    	var focusId=$('#supplierName option:selected')[0].id;
	        var thisSupplier=supplierJSON.filter(function(d){
	                return d.id===focusId;
	            })      
	    	$('#supplierBlock').empty();
	    	$('#supplierBlock').html(techCardTemplate(thisSupplier[0])).promise().done(function(){
     			addFilterListener();
	     	});
     	});
    });       
    
</script>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<xsl:call-template name="techCardHandlebarsTemplate"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="techCardHandlebarsTemplate">
		<script id="tech-card-template" type="text/x-handlebars-template">
            <div class="supplier">
                <!--<b>Supplier:</b> {{this.name}}<br/>-->
            	<div class="input-group top-10 bottom-10">
					<input id="catalogue-filter" type="text" class="form-control" placeholder="Filter..."/>
					<span class="input-group-addon"><i class="fa fa-search"/></span>
				</div>
            	<div class="catalogueList">
            		<div class="row">
            			{{#each products}}
	            			<div class="col-xs-12 col-md-6">
	            				<div class="productElement"><span class="product">{{{link}}}</span></div>
	            			</div>
	                    {{/each}}  
            		</div>
                </div>	
            </div>
    </script>
	</xsl:template>



	<!-- Render the Technology Provider Name from a Technology Provider node -->
	<xsl:template match="node()" mode="getSuppliers">
		<xsl:variable name="thisTechProds" select="$allTechProds[own_slot_value[slot_reference = 'supplier_technology_product']/value = current()/name]"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:value-of select="eas:validJSONString(current()/own_slot_value[slot_reference = 'name']/value)"/>","products":[<xsl:apply-templates select="$thisTechProds" mode="getProducts"/>]}, </xsl:template>

	<xsl:template match="node()" mode="getProducts">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:value-of select="eas:validJSONString(current()/own_slot_value[slot_reference = 'name']/value)"/>","link":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
		</xsl:call-template>"}, </xsl:template>

	<xsl:template match="node()" mode="options">
		<option>
			<xsl:attribute name="id">
				<xsl:value-of select="eas:getSafeJSString(current()/name)"/>
			</xsl:attribute>
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
		</option>
	</xsl:template>

</xsl:stylesheet>
