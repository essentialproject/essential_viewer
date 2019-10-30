<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>



	<xsl:output method="html"/>

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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- 08.04.2019 JP Updated to be roadmap enabled -->

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>

	<!-- Get all of the Application Services in the repository -->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="instanceClassName" select="('Technology_Product')"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Technology_Component')"/>
	
	
	<xsl:variable name="allInstances" select="/node()/simple_instance[supertype = $instanceClassName or type = $instanceClassName]"/>
	<xsl:variable name="allIntermediateCategories" select="/node()/simple_instance[name = $allInstances/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
	<xsl:variable name="allInstanceCategories" select="/node()/simple_instance[name = $allIntermediateCategories/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
	<xsl:variable name="orphanInstances" select="$allInstances[not(own_slot_value[slot_reference = 'implements_technology_components']/value)]"/>
	
	<xsl:variable name="catalogueTitle" select="eas:i18n('Technology Product Catalogue by Component')"/>
	<xsl:variable name="catalogueSectionTitle" select="eas:i18n('Technology Product Catalogue')"/>
	<xsl:variable name="catalogueIntro" select="eas:i18n('Please click on one of the Technology Products below to navigate to the required view')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START CATALOGUE SPECIFIC VARIABLES -->
	<xsl:variable name="techProdListByVendorCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Vendor')"/>
	<xsl:variable name="techProdListByCapCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Technology Capability')"/>
	<xsl:variable name="techProdListAsTableCatalogue" select="eas:get_report_by_name('Core: Technology Product Cataloigue as Table')"/>
	
	<!-- END CATALOGUE SPECIFIC VARIABLES -->

	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="allRoadmapInstances" select="($allInstances)"/>
	<xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeInstances" select="$allInstances[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeInstances" select="$allInstances"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="$catalogueTitle"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeInstances"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script src="js/es6-shim/0.9.2/es6-shim.js" type="text/javascript"/>
				<script type="text/javascript" src="js/jquery.columnizer.js"/>
				<xsl:call-template name="dataTablesLibrary"/>

				<!--script to support smooth scroll back to top of page-->
				<script type="text/javascript">
					$(document).ready(function() {
					    $('a.topLink').click(function(){
					        $('html, body').animate({scrollTop:0}, 'slow');
					        return false;
					    });
					});
				</script>
				
				<!-- ***REQUIRED*** ADD THE JS LIBRARIES IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
				
			</head>
			<body>
				
				
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, IF REQUIRED -->
				<xsl:call-template name="RenderInstanceLinkJavascript">
					<xsl:with-param name="instanceClassName" select="$linkClasses"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
				</xsl:call-template>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- ***REQUIRED*** ADD THE ROADMAP WIDGET FLOATING DIV -->
				<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
				<!-- ***REQUIRED*** TEMPLATE TO RENDER THE COMMON ROADMAP PANEL AND ASSOCIATED JAVASCRIPT VARIABLES AND FUNCTIONS -->
				<div id="ess-roadmap-content-container">
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
					<div class="clearfix"></div>
				</div>
				
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
										<xsl:value-of select="eas:i18n('Component')"/>
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
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByVendorCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Vendor'"/>
										</xsl:call-template>
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

							<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:</div>
							<div id="catalogue-section-nav" class="AlphabetQuickJumpLinks hidden-xs"/>
							
							<div class="clear"/>

							<diV id="catalogue-section-container"/>							

						</div>
						<div class="clear"/>

					</div>
				</div>

				<div class="clear"/>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				
				<!-- ***REQUIRED*** CALL THE ROADMAP CATALOGUE XSL TEMPLATE TO RENDER COMMON JS FUNCTIONS AND HANDLEBARS TEMPLATES -->
				<xsl:call-template name="RenderCatalogueByCategoryJS">
					<xsl:with-param name="theInstances" select="$allInstances"/>
					<xsl:with-param name="orphanInstances" select="$orphanInstances"/>
					<xsl:with-param name="orphanSubject">Component</xsl:with-param>
					<xsl:with-param name="theCategories" select="$allInstanceCategories"/>
					<xsl:with-param name="theDisplaySlots" select="('product_label')"/>
					<xsl:with-param name="theRoadmapInstances" select="$allRoadmapInstances"/>
					<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
			</body>
		</html>
	</xsl:template>
	
	
	
	<xsl:template name="RenderCatalogueByCategoryJS">
		<xsl:param name="theInstances" select="()"/>
		<xsl:param name="orphanInstances" select="()"/>
		<xsl:param name="orphanSubject"/>
		<xsl:param name="theCategories" select="()"/>
		<xsl:param name="theDisplaySlots" select="()"/>
		<xsl:param name="theRoadmapInstances" select="()"/>
		<xsl:param name="isRoadmapEnabled" select="false()"/>
		
		<script type="text/javascript">
			// the list of JSON objects representing the instances in use across the enterprise
		  	var categories = {
					categories: [<xsl:apply-templates select="$theCategories" mode="RenderCatalogueCategory">
						<xsl:with-param name="theRoadmapInstances" select="$theRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
						<xsl:with-param name="allCatInstances" select="$theInstances"/>
					</xsl:apply-templates>
		    	]
		  	};
		  	
		  	var instances = {
					instances: [<xsl:apply-templates select="$theInstances" mode="RenderCatalogueByNameInstance"><xsl:with-param name="theRoadmapInstances" select="$theRoadmapInstances"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theDisplaySlots" select="$theDisplaySlots"/></xsl:apply-templates>
		    	]
		  	};
		  	
		  	var orphanInstances = {
					instances: [<xsl:apply-templates select="$orphanInstances" mode="RenderCatalogueByNameInstance"><xsl:with-param name="theRoadmapInstances" select="$theRoadmapInstances"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theDisplaySlots" select="$theDisplaySlots"/></xsl:apply-templates>
		    	]
		  	};
		  	
		  	//the list of categories for the current scope
		  	var inScopeCategories = {
		  		categories: categories.categories
		  	};
		  	
		  	//the list of instances for the current scope
		  	var inScopeInstances = {
		  		instances: instances.instances
		  	};
		  	
		  	//the list of instances for the current scope
		  	var inScopeOrphans = {
		  		instances: orphanInstances.instances
		  	};
		  	
		  	var orphanSubject = '<xsl:value-of select="$orphanSubject"/>';
		  	
		  	var sectionLabels = [];
		  	
		  	var sectionTemplate, sectionNavTemplate;
		  	
		  	function initSectionLabels() {
		  		sectionLabels = [];
		  		categories.categories.forEach(function (aCat) {
		  			var firstLetter = aCat.name.charAt(0).toLowerCase();
		  			if(sectionLabels.indexOf(firstLetter) &lt; 0) {
		  				sectionLabels.push(firstLetter);
		  			}
		  		});
		  		orphanInstances.instances.forEach(function (anInst) {
		  			var firstLetter = anInst.name.charAt(0).toLowerCase();
		  			if(sectionLabels.indexOf(firstLetter) &lt; 0) {
		  				sectionLabels.push(firstLetter);
		  			}
		  		});
		  		sectionLabels.sort();
		  	}
		  	
		  	//function to create the list of relevant sections for the current scope
		  	function renderCatalogueSections() {
		  		var catalogueSections = {
		  			'sections': []
		  		}
		  		
		  		
		  		sectionLabels.forEach(function (sectionLetter) {
		  			var catsForSection = inScopeCategories.categories.filter(function(aCat) {return aCat.name.toLowerCase().startsWith(sectionLetter)});
		  			var orphansForSection = inScopeOrphans.instances.filter(function(anInst) {return anInst.name.toLowerCase().startsWith(sectionLetter)});
		  			console.log('orphan count for: ' + sectionLetter + ' = ' + orphansForSection.length);
		  			
		  			if((catsForSection.length > 0) || (orphansForSection.length > 0)) {
		  				var aSection = {
		  					'label': sectionLetter.toUpperCase(),
		  					'orphanSubject': orphanSubject,
		  					'orphans': orphansForSection,
		  					'categories': []
		  				}
		  				catsForSection.forEach(function (aCat) {
		  					//instancesForCat = inScopeInstances.instances.filter(function(anInst) {return aCat.instances.indexOf(anInst.id) &lt; 0});
		  					instancesForCat = getObjectsByIds(inScopeInstances.instances, 'id', aCat.instances)
		  					var aCatSection = {
			  					'label': aCat.link,
			  					'instances': instancesForCat
			  				}
			  				aSection.categories.push(aCatSection);
		  				});
		  				catalogueSections.sections.push(aSection);
		  			}			  			
		  		});
		  		
		  		$('#catalogue-section-nav').html(sectionNavTemplate(catalogueSections));
		  		
		  		$('#catalogue-section-container').html(sectionTemplate(catalogueSections)).promise().done(function(){
		  			if (document.documentElement.clientWidth &gt; 767) {
						$('.catalogItems').columnize({columns: 2});
					}	
					
					$('a.topLink').click(function(){
				        $('html, body').animate({scrollTop:0}, 'slow');
				        return false;
				    });
		  		});
		  		
		  	}
		  	
		  	<!-- ***REQUIRED*** JAVASCRIPT FUNCTION TO REDRAW THE VIEW WHEN THE ANY SCOPING ACTION IS TAKEN BY THE USER -->
		  	//function to redraw the view based on the current scope
			function redrawView() {
				//console.log('Redrawing View');
				
				<xsl:if test="$isRoadmapEnabled">
					<!-- ***REQUIRED*** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS -->
					//update the roadmap status of the catalogue instances passed as an array of arrays
					rmSetElementListRoadmapStatus([instances.instances, orphanInstances.instances]);
					
					<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
					//filter instances to those in scope for the roadmap start and end date
					inScopeInstances.instances = rmGetVisibleElements(instances.instances);
					inScopeOrphans.instances = rmGetVisibleElements(orphanInstances.instances);
				</xsl:if>			
				
				<!-- VIEW SPECIFIC JS CALLS -->
				//update the catalogue
				renderCatalogueSections();
																	
			}
		  	
		  	
		  	$(document).ready(function(){
		  		//Initialise the section labels
		  		initSectionLabels();
		  	
		  		//Set up the html template for catalogue navigation
				var sectionNavFragment = $("#catalogue-nav-template").html();
				sectionNavTemplate = Handlebars.compile(sectionNavFragment);
		  	
		  		//Set up the html template for catalogue sections
				var sectionFragment   = $("#category-section-template").html();
				sectionTemplate = Handlebars.compile(sectionFragment);
				
				redrawView();
		  	});
		  	
		</script>
		
		<!-- START HANDLEBARS TEMPLATES -->
		<!-- Handlebars template to render a section in the catalogue -->
		<script id="catalogue-nav-template" type="text/x-handlebars-template">
			{{#each sections}}
				<a class="AlphabetLinks" href="#section_A">
					<xsl:attribute name="href">#section_{{label}}</xsl:attribute>
					{{label}}
				</a>
			{{/each}}
		</script>
	
	
		<!-- Handlebars template to render the navigation section-->
		<script id="category-section-template" type="text/x-handlebars-template">
			{{#each sections}}
				<a>
					<xsl:attribute name="id">section_{{label}}</xsl:attribute>
				</a>
				<div class="alphabetSectionHeader">
					<h2 class="text-primary">{{label}}</h2>
				</div>
			
				{{#each categories}}
					{{#if instances.length}}
						<h3>{{{label}}}</h3>
						<div class="catalogItems">
							<ul>
								{{#each instances}}
									<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
								{{/each}}
							</ul>
						</div>
					{{/if}}
				{{/each}}
				
				{{#if orphans.length}}
					<h3>No {{orphanSubject}} defined</h3>
					<div class="catalogItems">
						<ul>
							{{#each orphans}}
								<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
							{{/each}}
						</ul>
					</div>
				{{/if}}

				<div class="jumpToTopLink">
					<a href="#top" class="topLink">
						<xsl:value-of select="eas:i18n('Back to Top')"/>
					</a>
				</div>
				<div class="clear"/>
				<hr/>
			{{/each}}
		</script>
		<!-- END HANDLEBARS TEMPLATES -->
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderCatalogueCategory">
		<xsl:param name="theRoadmapInstances" select="()"/>
		<xsl:param name="isRoadmapEnabled" select="false()"/>
		<xsl:param name="allCatInstances" select="()"/>
		
		<xsl:variable name="thisCategory" select="current()"/>
		<xsl:variable name="thisIntermediateCategories" select="$allIntermediateCategories[own_slot_value[slot_reference = 'implementing_technology_component']/value = $thisCategory/name]"/>
		<xsl:variable name="instForCat" select="$allCatInstances[own_slot_value[slot_reference = 'implements_technology_components']/value = $thisIntermediateCategories/name]"/>
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<xsl:call-template name="RenderRoadmapJSONProperties">
			<xsl:with-param name="theRoadmapInstance" select="$thisCategory"/>
			<xsl:with-param name="theDisplayInstance" select="$thisCategory"/>
			<xsl:with-param name="allTheRoadmapInstances" select="$theRoadmapInstances"/>
			<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
		</xsl:call-template>,
		'instances': [<xsl:apply-templates mode="RenderElementIDListForJs" select="$instForCat"/>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderCatalogueByNameInstance">
		<xsl:param name="theRoadmapInstances" select="()"/>
		<xsl:param name="isRoadmapEnabled" select="false()"/>
		<xsl:param name="theDisplaySlots"/>
		
		<xsl:variable name="thisInstance" select="current()"/>
		
		<xsl:variable name="theDisplayLabel">
			<xsl:for-each select="$theDisplaySlots">
				<xsl:if test="not(position() = 1)"><xsl:text> </xsl:text></xsl:if>
				<xsl:value-of select="$thisInstance/own_slot_value[slot_reference = current()]/value"/>
			</xsl:for-each>
		</xsl:variable>
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<xsl:call-template name="RenderRoadmapJSONProperties">
			<xsl:with-param name="theRoadmapInstance" select="$thisInstance"/>
			<xsl:with-param name="theDisplayInstance" select="$thisInstance"/>
			<xsl:with-param name="theDisplayLabel" select="translate($theDisplayLabel, '::', ' ')"/>
			<xsl:with-param name="theTargetReport" select="$targetReport"/>
			<xsl:with-param name="allTheRoadmapInstances" select="$theRoadmapInstances"/>
			<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
		</xsl:call-template>
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>
