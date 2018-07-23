<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="core_utilities.xsl"/>
	

	<xsl:template name="RenderJavascriptUtilityFunctions">
		
		<!-- START UTILITY FUNCTIONS -->
		Array.prototype.unique = function() {
			var a = this.concat();
			for(var i=0; i&lt;a.length; ++i) {
				for(var j=i+1; j&lt;a.length; ++j) {
					if(a[i] === a[j])
						a.splice(j--, 1);
				}
			}	
			return a;
		};
		
		//function to return the intersect of beteen an array of arrays
		function getArrayIntersect(arrays) {
		var result = arrays.shift().reduce(function(res, v) {
		if (res.indexOf(v) === -1 &amp;&amp; arrays.every(function(a) {
		return a.indexOf(v) !== -1;
		})) res.push(v);
		return res;
		}, []);
		return result;
		}
		
		
		//function to return a list of id for a list of objects
		function getObjectIds(objectList, idLabel) {
		var idList = [];
		//iterate through object keys
		Object.keys(objectList).forEach(function(key) {
		//get the value of idKey
		var id = objectList[key][idLabel];
		//push the id string to the idList
		idList.push(id);
		});
		//return the list of ids
		return idList;
		}
		
		
		//get a specific object from a list based on its id
		function getObjectById(objectList, idLabel, id) {
		var selectedObject = null;
		var currentObject;
		for (i = 0; objectList.length > i; i += 1) {
		currentObject = objectList[i];
		if (currentObject[idLabel] === id) {
		return currentObject;
		}
		}
		}
		
		//get a list of objects from a list ids
		function getObjectsByIds(objectList, idLabel, idList) {
		var selectedObjects = [];
		var currentObject;
		for (i = 0; objectList.length > i; i += 1) {
		currentObject = objectList[i];
		if (idList.indexOf(currentObject[idLabel]) >= 0) {
		selectedObjects.push(currentObject);
		}
		}
		return selectedObjects;
		}
		
		//get a list of unique property values from a list of objects
		function getUniqueObjectListPropertyVals(objectList, property) {
			var values = [];
			var currentVal;
			for (i = 0; objectList.length > i; i += 1) {
				currentVal = objectList[i][property];
				if ((currentVal != null) &amp;&amp; (values.indexOf(currentVal) &lt; 0)) {
					values.push(currentVal);
				}
			}
			return values;
		}
		
		//get a list of unique values from a list of arrays
		function getUniqueArrayVals(arrayList) {
			var values = [];
			var currentVal, currentArray;
			for (i = 0; arrayList.length > i; i += 1) {
				currentArray = arrayList[i];
				for (j = 0; currentArray.length > j; j += 1) {
					currentVal = currentArray[j];
					if (values.indexOf(currentVal) &lt; 0) {
						values.push(currentVal);
					}
				}
			}
			return values;
		}
		
		//get a list of property values from a list of objects
		function getObjectListPropertyVals(objectList, property) {
		var values = [];
		var currentVal;
		for (i = 0; objectList.length > i; i += 1) {
		currentVal = objectList[i][property];
		if (currentVal != null) {
		values.push(currentVal);
		}
		}
		return values;
		}
		
		
		<!--//get a list of objects matching the given property value
		function getObjectsMatchingVal(objectList, property, val) {
			var objects = [];
			var currentVal;
			for (i = 0; objectList.length > i; i += 1) {
				currentVal = objectList[i][property];
				if (currentVal == val) {
					objects.push(currentVal);
				}
			}
			//console.log("Matching Obj Count: " + objects.length);
			return objects;
		}-->
		
		
		//get a list of objects matching the given property value
		function getObjectsMatchingVal(objectList, property, val) {
			var objects = [];
			var currentObject, currentVal;
			for (i = 0; objectList.length > i; i += 1) {
				currentObject = objectList[i];
				currentVal = currentObject[property];
				if (currentVal == val) {
					objects.push(currentObject);
				}
			}
			//console.log("Matching Obj Count: " + objects.length);
			return objects;
		}

		
		
		//get a list of objects matching the given property value
		function getObjectsMatchingListVal(objectList, property, valList) {
			var objects = [];
			var currentObject, currentValList;
			for (i = 0; objectList.length > i; i += 1) {
				currentObject = objectList[i];
				currentValList = currentObject[property];
				for (var j in valList) {
					if (currentValList.includes(valList[j])) {
						objects.push(currentObject);
						//console.log('Found ' + valList[j] + ' in ' + currentValList);
						break;
					}
					//console.log('Not Found ' + valList[j] + ' in ' + currentValList);
				}
			}
			console.log("Matching Obj Count: " + objects.length);
			return objects;
		}
		
		
		//get a list of objects for which the given property is an empty array
		function getObjectsWithEmptyListVal(objectList, property) {
			var objects = [];
			var currentObject, currentValList;
			for (i = 0; objectList.length > i; i += 1) {
				currentObject = objectList[i];
				currentValList = currentObject[property];
				if (currentValList.length == 0) {
					objects.push(currentObject);
				}
			}
			return objects;
		}
		
		
		//get an average for the list of values
		function averageRating(values) {
		var sum = 0;
		for( var i = 0; i &lt; values.length; i++ ){
		sum += values[i];
		};
		
		if((sum > 0) &amp;&amp; (values.length > 0)) {
		return sum/values.length;
		} else {
		return 0;
		}
		}
		<!-- END UTILITY FUNCTIONS -->
		
	</xsl:template>
	
	
	<xsl:template name="RenderJavascriptScopingFunctions">
		<xsl:param name="setCompliance" select="true()"/>
		
		<!-- START PAGE DATA SCOPING FUNCTIONS -->
		var allBusUnitIDs = [];
		var selectedBusUnitIDs = [];
		var selectedBusUnits = [];
		var selectedAppIDs = [];
		var selectedApps = [];
		var selectedTechProdIDs = [];
		var selectedTechProds = [];
		
		
		//function to set the current list of Business Units based on a given list of Ids
		function setCurrentBusUnits(busUnitIdList) {
			selectedBusUnitIDs = busUnitIdList;
			selectedBusUnits = getObjectsByIds(businessUnits.businessUnits, "id", selectedBusUnitIDs);
			
			setCurrentApps();
			setCurrentTechProds();
		}
		
		//function to set the current list of Apps
		function setCurrentApps() {
			var appArrays = [];
			var currentBU;
			for (i = 0; selectedBusUnits.length > i; i += 1) {
			currentBU = selectedBusUnits[i];
			appArrays.push(currentBU.apps);
			}
			
			selectedAppIDs = getUniqueArrayVals(appArrays);
			selectedApps = getObjectsByIds(applications.applications, "id", selectedAppIDs);
			// console.log("Selected App Count: " + selectedApps.length);
		}
		
		
		//function to set the current list of Technology Products
		function setCurrentTechProds() {
			var techProdArrays = [];
			var currentBU;
			for (i = 0; selectedBusUnits.length > i; i += 1) {
				currentBU = selectedBusUnits[i];
				techProdArrays.push(currentBU.techProds);
			}
			
			selectedTechProdIDs = getUniqueArrayVals(techProdArrays);
			selectedTechProds = getObjectsByIds(techProducts.techProducts, "id", selectedTechProdIDs);
			// console.log("Selected Tech Prod Count: " + selectedTechProds.length);
		}
		
		
		//funtion to set the Business Capability Scope of the currently selected data objects
		function setBusCapabilityOverlay() {
			var thisBusCapBlobId, thisBusCapId, thisBusCap;
			
			var busOverlay = $('input:radio[name=busOverlay]:checked').val();
			if(busOverlay =='none') {
				//show basic overlay legend
				$("#bcmLegend").html(noOverlayBCMLegend);
			} else {
				//show rag overlay legend
				$("#bcmLegend").html(ragOverlayLegend);
			}
			
			$('.busRefModel-blob').each(function() {
				thisBusCapBlobId = $(this).attr('id');
				thisBusCapId = thisBusCapBlobId.substring(0, (thisBusCapBlobId.length - 5));
				thisBusCap = getObjectById(busCapDetails, "busCapId", thisBusCapId);
			
				refreshBCMDetailPopup(thisBusCap);
			});
		
		}
		
		
		//function to refresh the table of supporting Applications Services associated with a given business capability
		function refreshBCMDetailPopup(theBusCap) {
			var appServices = theBusCap.appServices;
			var anAppSvcDetail, appSvcAppIDList, anAppSvc, busCapBlobId, busCapStyle, thisAppCount;
			var appCount = 0;
			var appSvcDetailList = {};
			appSvcDetailList["busCapApps"] = [];
			
			var busCapBlobId = '#' + theBusCap.busCapId + '_blob';
			var infoButtonId = '#' + theBusCap.busCapId + '_info';
			
			for( var i = 0; i &lt; appServices.length; i++ ){
				anAppSvc = appServices[i];
				appSvcAppIDList = anAppSvc.apps;		
				
				var relevantAppIds = getArrayIntersect([appSvcAppIDList, selectedAppIDs]);
				var relevantApps = getObjectsByIds(selectedApps, "id", relevantAppIds);
				thisAppCount = relevantApps.length;
				
				if(thisAppCount > 0) {
					anAppSvcDetail = {};
					anAppSvcDetail["link"] = anAppSvc.link;
					anAppSvcDetail["description"] = anAppSvc.description;
					anAppSvcDetail["count"] = thisAppCount;
					appCount = appCount + thisAppCount;
					
					appSvcDetailList.busCapApps.push(anAppSvcDetail);
				} 
			}
			
			if((appSvcDetailList.busCapApps.length > 0) &amp;&amp; (appCount > 0)) {
				//set the background colour of the business capability based on the selected overlay
				var busCapStyle;
				var busOverlay = $('input:radio[name=busOverlay]:checked').val();
				if(busOverlay =='duplication') {
					//show duplication overlay
					var appDuplicationScore = Math.round(appCount / appSvcDetailList.busCapApps.length);
					busCapStyle = getDuplicationStyle(appDuplicationScore, 'busRefModel-blob');
				} else {
					//show no overlay
					busCapStyle = 'busRefModel-blob bg-darkblue-80';
				}
				
				$(busCapBlobId).attr("class", busCapStyle);
				$(infoButtonId).attr("class", "refModel-blob-info");
				
				var detailTableBodyId = '#' + theBusCap.busCapId + '_app_rows';
				$(detailTableBodyId).html(bcmDetailTemplate(appSvcDetailList));
			}
			else {
				$(busCapBlobId).attr("class", "busRefModel-blob bg-lightgrey");
				$(infoButtonId).attr("class", "refModel-blob-info hiddenDiv");
			}
			
			
		}
		
		
		//funtion to set the ARM overlay
		function setAppCapabilityOverlay() {
			var thisAppCapBlobId, thisAppCapId, thisAppCap;
			
			var appOverlay = $('input:radio[name=appOverlay]:checked').val();
			if(appOverlay =='none') {
				//show basic overlay legend
				$("#armLegend").html(noOverlayARMLegend);
			} else {
				//show rag overlay legend
				$("#armLegend").html(ragOverlayLegend);
			}
			
			$('.appRefModel-blob').each(function() {
				thisAppCapBlobId = $(this).attr('id');
				thisAppCapId = thisAppCapBlobId.substring(0, (thisAppCapBlobId.length - 5));
				thisAppCap = getObjectById(appCapDetails, "id", thisAppCapId);
				
				refreshARMDetailPopup(thisAppCap);
			});
		
		}
		
		
		//function to refresh the table of supporting Applications Services associated with a given application capability
		function refreshARMDetailPopup(theAppCap) {
			var appServices = theAppCap.appServices;
			var anAppSvcDetail, appSvcAppIDList, anAppSvc, appCapBlobId, appCapStyle, thisAppCount;
			var appCount = 0;
			var appSvcDetailList = {};
			appSvcDetailList["appCapApps"] = [];
			
			var appCapBlobId = '#' + theAppCap.id + '_blob';
			var infoButtonId = '#' + theAppCap.id + '_info';
			
			for( var i = 0; i &lt; appServices.length; i++ ){
				anAppSvc = appServices[i];
				appSvcAppIDList = anAppSvc.apps;		
				
				var relevantAppIds = getArrayIntersect([appSvcAppIDList, selectedAppIDs]);
				var relevantApps = getObjectsByIds(selectedApps, "id", relevantAppIds);
				thisAppCount = relevantApps.length;
				
				if(thisAppCount > 0) {
					anAppSvcDetail = {};
					anAppSvcDetail["link"] = anAppSvc.link;
					anAppSvcDetail["description"] = anAppSvc.description;
					anAppSvcDetail["count"] = thisAppCount;
					appCount = appCount + thisAppCount;
					
					appSvcDetailList.appCapApps.push(anAppSvcDetail);
				} 
			}
			
			if((appSvcDetailList.appCapApps.length > 0) &amp;&amp; (appCount > 0)) {
				//set the background colour of the business capability based on the selected overlay
				var appCapStyle;
				var appOverlay = $('input:radio[name=appOverlay]:checked').val();
				if(appOverlay =='duplication') {
					//show duplication overlay
					var appDuplicationScore = Math.round(appCount / appSvcDetailList.appCapApps.length);
					appCapStyle = getDuplicationStyle(appDuplicationScore, 'appRefModel-blob');
				} else {
					//show no overlay
					appCapStyle = 'appRefModel-blob bg-darkblue-80';
				}
				
				$(appCapBlobId).attr("class", appCapStyle);
				$(infoButtonId).attr("class", "refModel-blob-info");
				
				var detailTableBodyId = '#' + theAppCap.id + '_app_rows';
				$(detailTableBodyId).html(appDetailTemplate(appSvcDetailList));
			}
			else {
				$(appCapBlobId).attr("class", "appRefModel-blob bg-lightgrey");
				$(infoButtonId).attr("class", "refModel-blob-info hiddenDiv");
			}
		}
		
		
		//funtion to set the TRM Overlay
		function setTechCapabilityOverlay() {
			var thisTechCapBlobId, thisTechCapId, thisTechCap;
			
			var techOverlay = $('input:radio[name=techOverlay]:checked').val();
			if(techOverlay =='none') {
				//show the basic overlay legend
				$("#trmLegend").html(noOverlayTRMLegend);
			} else {
				//show rag overlay legend
				$("#trmLegend").html(ragOverlayLegend);
			}
			
			$('.techRefModel-blob').each(function() {
				thisTechCapBlobId = $(this).attr('id');
				thisTechCapId = thisTechCapBlobId.substring(0, (thisTechCapBlobId.length - 5));
				thisTechCap = getObjectById(techCapDetails, "id", thisTechCapId);

				refreshTRMDetailPopup(thisTechCap);
			});
		
		}
		
		//function that returns the style class for a reference moel element
		function getDuplicationStyle(count, rootClass) {
			if(count == 1) {
				return rootClass + ' bg-brightgreen-120';
			} else if((count > 1) &amp;&amp; (count &lt;= 3)) {
				return rootClass + ' bg-orange-120';
			} else {
				return rootClass + ' bg-brightred-120';
			}
		}
		
		//funtion to get the score for a given set of tech prods
		function getTechProdStatusScore(techProds) {
			var techProdCount = 0;
			var statusScore = 0;
			var statusScoreTotal = 0;
			var aTechProd;
			
			for( var i = 0; i &lt; techProds.length; i++ ){
				aTechProd = techProds[i];
				statusScore = aTechProd.statusScore;
				
				if(statusScore > 0) {
					statusScoreTotal = statusScoreTotal + statusScore;
					techProdCount++;
				}
			}
			
			if((techProdCount > 0) &amp;&amp; (statusScoreTotal > 0)) {
				return Math.round(statusScoreTotal / techProdCount);
			} else {
				return 0;
			}
			
		}
		
		//function that returns the style class for a reference model element based on its lifecycle status
		function getStatusStyle(score, rootClass) {
			if(score == 0) {
				return rootClass + ' bg-darkgrey';
			} else if(score > 8) {
				return rootClass + ' bg-brightgreen-120';
			} else if((score > 4) &amp;&amp; (score &lt;= 7)) {
				return rootClass + ' bg-orange-120';
			} else {
				return rootClass + ' bg-brightred-120';
			}
		}
		
		
		//function to refresh the table of supporting Technology Components associated with a given technology capability
		function refreshTRMDetailPopup(theTechCap) {
		var techComps = theTechCap.techComponents;
			var aTechCompDetail, techCompProdIDList, aTechComp, techCapBlobId, techCapStyle, thisTechProdCount;
			var techProdCount = 0;
			var techProdList = []
			var techCompDetailList = {};
			techCompDetailList["techCapProds"] = [];
			
			var techCapBlobId = '#' + theTechCap.id + '_blob';
			var infoButtonId = '#' + theTechCap.id + '_info';
			
			
			for( var i = 0; i &lt; techComps.length; i++ ){
				aTechComp = techComps[i];
				techCompProdIDList = aTechComp.techProds;		
				
				var relevantTechProdIds = getArrayIntersect([techCompProdIDList, selectedTechProdIDs]);
				var relevantTechProds = getObjectsByIds(selectedTechProds, "id", relevantTechProdIds);
				thisTechProdCount = relevantTechProds.length;
				
				
				if(thisTechProdCount > 0) {
					aTechCompDetail = {};
					aTechCompDetail["link"] = aTechComp.link;
					aTechCompDetail["description"] = aTechComp.description;
					aTechCompDetail["count"] = thisTechProdCount;
					techProdCount = techProdCount + thisTechProdCount;
					techProdList = techProdList.concat(relevantTechProds);
					
					techCompDetailList.techCapProds.push(aTechCompDetail);
				} 
			}
			
			var techCapBlob = $(techCapBlobId);
			var techCapInfo = $(infoButtonId);
			techCapBlob.removeClass();
			techCapInfo.removeClass();
			
			if((techCompDetailList.techCapProds.length > 0) &amp;&amp; (techProdCount > 0)) {
				//console.log('Setting blob overlay: ' + techCapInfo.attr("id"));
			
				//set the background colour of the technology capability based on the selected overlay
				var techCapStyle;
				var techOverlay = $('input:radio[name=techOverlay]:checked').val();
				if(techOverlay =='duplication') {
					//show duplication overlay
					var techProdDuplicationScore = Math.round(techProdCount / techCompDetailList.techCapProds.length);
					techCapStyle = getDuplicationStyle(techProdDuplicationScore, 'techRefModel-blob');
				} else if (techOverlay =='status') {
					//show lifecycle status overlay
					var techStatusScore = getTechProdStatusScore(techProdList);
					techCapStyle = getStatusStyle(techStatusScore, 'techRefModel-blob');
				} else {
					//show no overlay
					techCapStyle = 'techRefModel-blob bg-darkblue-80';
				}
				
				techCapBlob.addClass(techCapStyle);
				techCapInfo.attr("class", "refModel-blob-info");
				
				var detailTableBodyId = '#' + theTechCap.id + '_techprod_rows';
				$(detailTableBodyId).html(techDetailTemplate(techCompDetailList));
			}
			else {
				techCapBlob.addClass("techRefModel-blob bg-lightgrey");
				techCapInfo.attr("class", "refModel-blob-info hiddenDiv");
			}
		
		}
		
		
		
		//Low = good, high = bad
		function setRAGForAscendingLevel(level) {
			if(level == 0) {
				return '<div class="btn btn-sm btn-block bg-lightgrey impact"><i class="fa fa-warning text-white"/></div>';
			} else if(level &lt;= 1) {
				return '<div class="btn btn-sm btn-block backColourGreen impact"><i class="fa fa-check-circle text-white"/></div>';
			} else if(level > 1 &amp;&amp; level &lt;=2) {
				return '<div class="btn btn-sm btn-block backColourOrange impact"><i class="fa fa-warning text-white"/></div>';
			} else {
				return '<div class="btn btn-sm btn-block backColourRed impact"><i class="fa fa-warning text-white"/></div>';
			}
		}
		
		
		//Low = bad, high = good
		function setRAGForDescendingLevel(level) {
			if(level == 0) {
				return '<div class="btn btn-sm btn-block bg-lightgrey impact"><i class="fa fa-warning text-white"/></div>';
			} else if(level &lt;= 1) {
				return '<div class="btn btn-sm btn-block backColourRed impact"><i class="fa fa-warning text-white"/></div>';
			} else if(level > 1 &amp;&amp; level &lt;=2) {
				return '<div class="btn btn-sm btn-block backColourOrange impact"><i class="fa fa-warning text-white"/></div>';
			} else {
				return '<div class="btn btn-sm btn-block backColourGreen impact"><i class="fa fa-check-circle text-white"/></div>';
			}
		}
		
		
		
		<!-- END PAGE DATA SCOPING FUNCTIONS -->	
		
	</xsl:template>
	
	
	
	
	<xsl:template name="RenderDashboardBusUnitFilter">
		<script id="bus-unit-select-template" type="text/x-handlebars-template">
			{{#businessUnits}}
		  		<option>
		  			<xsl:attribute name="value"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
		  			{{name}}
		  		</option>
			{{/businessUnits}}
		</script>
		<div class="col-xs-6">
			<div class="dashboardPanel bg-offwhite match1">
				<h2 class="text-secondary">Business Unit Scope</h2>
				<div class="row">
					<div class="col-xs-12">
						<label>
							<span>Business Unit Selection</span>
						</label>
						<select id="busUnitList" class="form-control" multiple="multiple" style="width:100%"/>					
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	
	
	<xsl:template name="RenderInitDataScopeMap">
		<!--See JVectorMap Website for More Documentation http://jvectormap.com  -->
		<script>
					$(document).ready(function(){			
						$('#mapScope').vectorMap(
							{
								map: 'world_mill',
                                zoomOnScroll: false,
								backgroundColor: 'transparent',
								hoverOpacity: 0.7,
								hoverColor: false,
								regionStyle: {
								    initial: {
									    fill: '#ccc',
									    "fill-opacity": 1,
									    stroke: 'none',
									    "stroke-width": 0,
									    "stroke-opacity": 1
								    }
							    },
							    markerStyle: {
							    	initial: {
								        fill: 'yellow',
								        stroke: 'black',
							        }
							    },
							    <!--markers: [{latLng: [41.90, 12.45], name: 'My App'}],-->
							    series: {
							    regions: [{
							    	values: {},
							    	attribute: 'fill'
							    }]
							  }
							}
						);	
					});
				</script>
	</xsl:template>
	
	
	
	
	<xsl:template name="RenderGeographicMapJSFunctions">
		<!-- START GEOGRAPHIC MAP FUNCTIONS -->
		//funtion to set the Geographic Scope of the currently selected business units
		function setGeographicMap(mapObject, countryProperty, countryColour) {
			var busUnitList = selectedBusUnits.slice(0);
			var collatedCountryList = getCountries(busUnitList, countryProperty);
			var countrySet = {};
			
			for (i = 0; collatedCountryList.length > i; i += 1) {
				countrySet[collatedCountryList[i]] = countryColour;
			};

			console.log("Select Countries: " + collatedCountryList);
			mapObject.reset();
			mapObject.series.regions[0].setValues(countrySet);
		
		}
		
		//functon to create a unioned list of country ids for a given property of the given objects
		function getCollatedCountries(countryList, objectList, propertyName) {
			if (objectList.length > 0) {												
				var currentObject = objectList.pop();
				var currentObjectCountryList = currentObject[propertyName];
				$.merge( $.merge( [], countryList ), currentObjectCountryList );
				$.merge(countryList, currentObjectCountryList);
				return getCollatedCountries(countryList, objectList, propertyName);
			} else {
				return countryList;
			}
		}
		
		
		function getCountries(objectList, propertyName) {
			var countryList = [];
			var country;
			for (i = 0; objectList.length > i; i += 1) {
				country = objectList[i][propertyName];
				if(country.length > 0) {
				countryList.push(country);
				}
			};
			
			return countryList;
		
		}
		<!-- END GEOGRAPHIC MAP FUNCTIONS -->
	</xsl:template>
	
	
	<xsl:template mode="RenderElementIDListForJs" match="node()">
		"<xsl:value-of select="current()/name"/>"<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="RenderEnumerationJSONList" match="node()">
		
		<xsl:variable name="colour" select="eas:get_element_style_colour(current())"/>
		
		{
		id: "<xsl:value-of select="current()/name"/>",
		name: "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>",
		colour: "<xsl:choose><xsl:when test="string-length($colour) &gt; 0"><xsl:value-of select="$colour"/></xsl:when><xsl:otherwise>#fff</xsl:otherwise></xsl:choose>",
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<!-- Search up the stack for all parent Business Capabilities of supplied Bus Cap -->
	<xsl:function name="eas:getParentBusinessCapabilities" as="node()*">
		<xsl:param name="theBusCap"></xsl:param>
		<xsl:param name="theParentBusCaps"></xsl:param>
		<xsl:param name="theParentCapStack"></xsl:param>
		<xsl:param name="theAllBusCaps"></xsl:param>
		
		<xsl:variable name="aParentStack" select="$theBusCap union $theParentCapStack"></xsl:variable>
		
		<xsl:choose>			
			<!-- If we've got no parent Business Capabilities, terminate the recursion-->
			<xsl:when test="empty($theParentBusCaps)">
				<xsl:sequence select="$aParentStack"></xsl:sequence>
			</xsl:when>
			
			<!-- else, search up the stack -->
			<xsl:otherwise>
				<xsl:variable name="parentsOfParentCaps" select="$theAllBusCaps[name= $theParentBusCaps/own_slot_value[slot_reference='supports_business_capabilities']/value]"></xsl:variable>
				<xsl:variable name="parentCapStack" select="$aParentStack union $parentsOfParentCaps"></xsl:variable>
				<xsl:sequence select="eas:getParentBusinessCapabilities($theParentBusCaps, $parentsOfParentCaps, $parentCapStack, $theAllBusCaps)"></xsl:sequence>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<xsl:template match="node()" mode="getSimpleJSONList">
		{
		id: "<xsl:value-of select="name"/>",
		name: "<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>",
		colour: "<xsl:value-of select="eas:get_element_style_colour(current())"/>"
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	
</xsl:stylesheet>
