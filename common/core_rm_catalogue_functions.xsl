<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:import href="../common/core_roadmap_functions.xsl"/>

	<xsl:template name="RenderCatalogueByNameJS">
		<xsl:param name="theInstances" select="()"/>
		<xsl:param name="theTargetReport" select="()"/>
		<xsl:param name="theDisplaySlots" select="()"/>
		<xsl:param name="theRoadmapInstances" select="()"/>
		<xsl:param name="isRoadmapEnabled" select="false()"/>
		
		<script type="text/javascript">
			// the list of JSON objects representing the instances in use across the enterprise
		  	var instances = {
					instances: [<xsl:apply-templates select="$theInstances" mode="RenderCatalogueByNameInstance"><xsl:with-param name="theRoadmapInstances" select="$theRoadmapInstances"/><xsl:with-param name="theTargetReport" select="$theTargetReport"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theDisplaySlots" select="$theDisplaySlots"/></xsl:apply-templates>
		    	]
		  	};
		  	
		  	//the list of instances for the current scope
		  	var inScopeInstances = {
		  		instances: instances.instances
		  	};
		  	
		  	var sectionLabels = [];
		  	
		  	var sectionTemplate, sectionNavTemplate;
		  	
		  	function initSectionLabels() {
		  		sectionLabels = [];
		  		instances.instances.forEach(function (anInstance) {
		  			var firstLetter = anInstance.name.charAt(0).toLowerCase();
		  			if(sectionLabels.indexOf(firstLetter) &lt; 0) {
                        if(firstLetter.length &gt; 0){
		  				sectionLabels.push(firstLetter);
                        }
		  			}
		  		});
		  		sectionLabels.sort();
            console.log(sectionLabels);
		  	}
		  	
		  	//function to create the list of relevant sections for the current scope
		  	function renderCatalogueSections() {
		  		var catalogueSections = {
		  			'sections': []
		  		}
		  		
		  		sectionLabels.forEach(function (sectionLetter) {
		  			var instancesForSection = inScopeInstances.instances.filter(anInst => anInst.name.toLowerCase().startsWith(sectionLetter));
		  			//console.log('instance count for: ' + sectionLetter + ' = ' + instancesForSection.length);
		  			if(instancesForSection.length > 0) {
		  				var aSection = {
		  					'label': sectionLetter.toUpperCase(),
		  					'instances': instancesForSection
		  				}
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
					rmSetElementListRoadmapStatus([instances.instances]);
					
					<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
					//filter instances to those in scope for the roadmap start and end date
					inScopeInstances.instances = rmGetVisibleElements(instances.instances);
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
				var sectionFragment   = $("#catalogue-section-template").html();
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
		<script id="catalogue-section-template" type="text/x-handlebars-template">
			{{#each sections}}
				<a>
					<xsl:attribute name="id">section_{{label}}</xsl:attribute>
				</a>
				<div class="alphabetSectionHeader">
					<h2 class="text-primary">{{label}}</h2>
				</div>
				<div class="catalogItems">
					<ul>
						{{#each instances}}
							<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
						{{/each}}
					</ul>
				</div>
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
	
	
	
	<xsl:template name="RenderCatalogueByCategoryJS">
		<xsl:param name="theInstances" select="()"/>
		<xsl:param name="orphanInstances" select="()"/>
		<xsl:param name="theTargetReport" select="()"/>
		<xsl:param name="orphanSubject"/>
		<xsl:param name="theCategories" select="()"/>
		<xsl:param name="theCatSlot"/>
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
						<xsl:with-param name="catSlot" select="$theCatSlot"/>
					</xsl:apply-templates>
		    	]
		  	};
		  	
		  	var instances = {
					instances: [<xsl:apply-templates select="$theInstances" mode="RenderCatalogueByNameInstance"><xsl:with-param name="theTargetReport" select="$theTargetReport"/><xsl:with-param name="theRoadmapInstances" select="$theRoadmapInstances"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theDisplaySlots" select="$theDisplaySlots"/></xsl:apply-templates>
		    	]
		  	};
		  	
		  	var orphanInstances = {
					instances: [<xsl:apply-templates select="$orphanInstances" mode="RenderCatalogueByNameInstance"><xsl:with-param name="theTargetReport" select="$theTargetReport"/><xsl:with-param name="theRoadmapInstances" select="$theRoadmapInstances"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theDisplaySlots" select="$theDisplaySlots"/></xsl:apply-templates>
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
		  			var catsForSection = inScopeCategories.categories.filter(aCat => aCat.name.toLowerCase().startsWith(sectionLetter));
		  			var orphansForSection = inScopeOrphans.instances.filter(anInst => anInst.name.toLowerCase().startsWith(sectionLetter));
		  			console.log('orphan count for: ' + sectionLetter + ' = ' + orphansForSection.length);
		  			
		  			if((catsForSection.length > 0) || (orphansForSection.length > 0)) {
		  				var aSection = {
		  					'label': sectionLetter.toUpperCase(),
		  					'orphanSubject': orphanSubject,
		  					'orphans': orphansForSection,
		  					'categories': []
		  				}
		  				catsForSection.forEach(function (aCat) {
		  					//instancesForCat = inScopeInstances.instances.filter(anInst => aCat.instances.indexOf(anInst.id) &lt; 0);
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
		<script id="catalogue-section-template" type="text/x-handlebars-template">
			{{#each sections}}
				<a>
					<xsl:attribute name="id">section_{{label}}</xsl:attribute>
				</a>
				<div class="alphabetSectionHeader">
					<h2 class="text-primary">{{label}}</h2>
				</div>
			
				<div class="catalogItems">
					<ul>
						{{#each instances}}
							<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
						{{/each}}
					</ul>
				</div>

				<div class="jumpToTopLink">
					<a href="#top" class="topLink">
						<xsl:value-of select="eas:i18n('Back to Top')"/>
					</a>
				</div>
				<div class="clear"/>
				<hr/>
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
		<xsl:param name="catSlot"/>
		
		<xsl:variable name="thisCategory" select="current()"/>
		<xsl:variable name="instForCat" select="$allCatInstances[own_slot_value[slot_reference = $catSlot]/value = $thisCategory/name]"/>
		
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
		<xsl:param name="theTargetReport" select="()"/>
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
			<xsl:with-param name="theTargetReport" select="$theTargetReport"/>
			<xsl:with-param name="theDisplayLabel" select="translate($theDisplayLabel, '::', ' ')"/>
			<xsl:with-param name="allTheRoadmapInstances" select="$theRoadmapInstances"/>
			<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
		</xsl:call-template>
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
