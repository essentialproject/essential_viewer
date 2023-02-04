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
		
		
		//function to format a number
		function formatNumber(num) {
			return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
		}
		
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
			//console.log(arrayList[[0]]);
            if(arrayList[0]){
			for (i = 0; arrayList.length > i; i += 1) {
				currentArray = arrayList[i];
				for (j = 0; currentArray.length > j; j += 1) {
					currentVal = currentArray[j];
					if (values.indexOf(currentVal) &lt; 0) {
						values.push(currentVal);
					}
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
			//console.log("Matching Obj Count: " + objects.length);
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
	
	
	<xsl:template name="RenderJavascriptRESTFunctions">
		
		<!-- TODO remove. Refactor to use the same function in core_common_editor_api_functions.js. -->

		//Utility function to create a CORs request
		function createCORSRequest(method, url, csrfToken) {
			var xhr = new XMLHttpRequest();
			if ("withCredentials" in xhr) {
			
				// Check if the XMLHttpRequest object has a "withCredentials" property.
				// "withCredentials" only exists on XMLHTTPRequest2 objects.
				xhr.open(method, url, true);
				xhr.setRequestHeader('x-csrf-token', csrfToken);

				
			} else if (typeof XDomainRequest != "undefined") {
				
				// Otherwise, check if XDomainRequest.
				// XDomainRequest only exists in IE, and is IE's way of making CORS requests.
				xhr = new XDomainRequest();
				xhr.open(method, url);
				xhr.setRequestHeader('x-csrf-token', csrfToken);

			
			} else {
			
			// Otherwise, CORS is not supported by the browser.
			xhr = null;
			
			}
			return xhr;
		}

		function onXhrLoad(xhr, success, failure) {
			return function() {
				var status = xhr.status;
				if (status &gt;= 200 &amp;&amp; status &lt; 300) {
					// http success code
					success(xhr);
				} else {
					// http error code
					var response = xhr.responseText;
					try {
						//console.log('Error Response:');
						//console.log(response);
						var theResponseJson = JSON.parse(response);
						if (status === 403 &amp;&amp; theResponseJson.message &amp;&amp; theResponseJson.message.errorCode &amp;&amp; theResponseJson.message.errorCode === 10) {
							// specific error code that informs the client that the server has logged the user out and requires a page refresh to complete the logout
							window.stop();
							var modalHtml =
								'&lt;div class="modal-dialog" role="document"&gt;' +
								'  &lt;div class="modal-content"&gt;' +
								'    &lt;div class="modal-header"&gt;&lt;h4 class="strong"&gt;&lt;i class="fa fa-user right-5"&gt;&lt;/i&gt;Session Expired&lt;/h4&gt;&lt;/div&gt;' +
								'    &lt;div class="modal-body"&gt;&lt;p&gt;Your current session has expired. Please sign-in again.&lt;/p&gt;' +
								'    &lt;div class="modal-footer"&gt;&lt;div class="btn btn-success" onClick="location.reload();"&gt;Sign-In&lt;/div&gt;&lt;/div&gt;' +
								'  &lt;/div&gt;' + 
								'&lt;/div&gt;';
							$('body').append('&lt;div id="timeoutModal" class="modal fade" tabindex="-1" role="dialog" style="z-index: 9999999999999" /&gt;');	
							// insert HTML dynamically
							$("#timeoutModal").html(modalHtml);
							// display
							$("#timeoutModal").modal('show');
						}
					} catch (e) {
						// do nothing - if the API doesn't return a JSON error response, just continue
					}
					failure();
				}
			};
		}

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
		
			if(selectedBusUnits.length > 0) {
				var appArrays = [];
				var currentBU;
				for (i = 0; selectedBusUnits.length > i; i += 1) {
				currentBU = selectedBusUnits[i];
				appArrays.push(currentBU.apps);
				}
				
				selectedAppIDs = getUniqueArrayVals(appArrays);
				selectedApps = getObjectsByIds(applications.applications, "id", selectedAppIDs);
				// console.log("Selected App Count: " + selectedApps.length);
			} else {
				selectedApps = applications.applications;
				selectedAppIDs = getObjectListPropertyVals(selectedApps, "id");
				//console.log('Setting all apps: ' + selectedAppIDs.length);
			}
		}
		
		
		//function to set the current list of Technology Products
		function setCurrentTechProds() {
		
			if(selectedBusUnits.length > 0) {
				var techProdArrays = [];
				var currentBU;
				for (i = 0; selectedBusUnits.length > i; i += 1) {
					currentBU = selectedBusUnits[i];
					techProdArrays.push(currentBU.techProds);
				}
				
				selectedTechProdIDs = getUniqueArrayVals(techProdArrays);
				selectedTechProds = getObjectsByIds(techProducts.techProducts, "id", selectedTechProdIDs);
				// console.log("Selected Tech Prod Count: " + selectedTechProds.length);
			} else {
				selectedTechProds = techProducts.techProducts;
				selectedTechProdIDs = getObjectListPropertyVals(selectedTechProds, "id");
			}
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
					var appDuplicationScore = appCount / appSvcDetailList.busCapApps.length;
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
			
			if(theAppCap.id == 'Nov Update 1601_Class30004') {
				//console.log('Risk Management Details: ' + appCapBlobId);
			}
			
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
					var appDuplicationScore = appCount / appSvcDetailList.appCapApps.length;
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
			if(count &lt; 2) {
				return rootClass + ' bg-brightgreen-120';
			} else if((count >= 2) &amp;&amp; (count &lt;= 3)) {
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
					var techProdDuplicationScore = techProdCount / techCompDetailList.techCapProds.length;
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

	<!-- office related functions-->
	<xsl:template name="officeHandlebarsTemplates">
		
	</xsl:template>
	<xsl:template name="RenderOfficetUtilityFunctions">		
		<!-- ODS fucntions -->

		var getXML = function promise_getExcelXML(excelXML_URL) {
			return new Promise(
			function (resolve, reject) {
				var xmlhttp = new XMLHttpRequest();
				xmlhttp.onreadystatechange = function () {
					if (this.readyState == 4 &amp;&amp; this.status == 200) {
						////console.log(prefixString);
						resolve(this.responseText);
					}
				};
				xmlhttp.onerror = function () {
					reject(false);
				};
				xmlhttp.open("GET", excelXML_URL, true);
				xmlhttp.send();
			});
		};


		function setExcel(excelFile, filename){ 
 
			let worksheetsVar=[];
			excelFile.sheets.forEach((s)=>{
				worksheetsVar.push(s.worksheetName)
			})
			 
			let contentXML, stylesXML, metaXML, manifestXML, mimetypeXML;
  	
				getXML('common/ods_spreadsheet_files/styles.xml').then(function(response){ 
				stylesXML=response; 
			}).then(function(response){  
			
				getXML('common/ods_spreadsheet_files/meta.xml').then(function(response){ 
				metaXML=response; 
			}).then(function(response){  
			
				getXML('common/ods_spreadsheet_files/manifest.xml').then(function(response){ 
					manifestXML=response; 
			}).then(function(response){  
			
				getXML('common/ods_spreadsheet_files/mimetype').then(function(response){ 
					mimetypeXML=response; 
			}).then(function(response){  
			let meta='&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?>&lt;office:document-meta xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" office:version="1.3">&lt;office:meta>&lt;meta:generator>MicrosoftOffice/16.0 MicrosoftExcel/CalculationVersion-10911&lt;/meta:generator>&lt;dc:creator>Microsoft Office User&lt;/dc:creator>&lt;meta:creation-date>2022-09-17T13:59:29Z&lt;/meta:creation-date>&lt;dc:date>2022-09-19T09:26:31Z&lt;/dc:date>&lt;/office:meta>&lt;/office:document-meta>';
			let contentHead='&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?>&lt;office:document-content xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" office:version="1.3">&lt;office:font-face-decls>&lt;style:font-face style:name="Calibri" svg:font-family="Calibri"/>&lt;/office:font-face-decls>&lt;office:automatic-styles>&lt;style:style style:name="ce1" style:family="table-cell" style:parent-style-name="Default" style:data-style-name="N0"/>&lt;style:style style:name="ce2" style:family="table-cell" style:data-style-name="N0">&lt;style:table-cell-properties style:vertical-align="automatic" fo:background-color="transparent"/>&lt;/style:style>&lt;style:style style:name="co1" style:family="table-column">&lt;style:table-column-properties fo:break-before="auto" style:column-width="3.91583333333333cm"/>&lt;/style:style>&lt;style:style style:name="co2" style:family="table-column">&lt;style:table-column-properties fo:break-before="auto" style:column-width="4.97416666666667cm"/>&lt;/style:style>&lt;style:style style:name="co3" style:family="table-column">&lt;style:table-column-properties fo:break-before="auto" style:column-width="1.71979166666667cm"/>&lt;/style:style>&lt;style:style style:name="ro1" style:family="table-row">&lt;style:table-row-properties style:row-height="16pt" style:use-optimal-row-height="true" fo:break-before="auto"/>&lt;/style:style>&lt;style:style style:name="ta1" style:family="table" style:master-page-name="mp1">&lt;style:table-properties table:display="true" style:writing-mode="lr-tb"/>&lt;/style:style>&lt;/office:automatic-styles>&lt;office:body>&lt;office:spreadsheet>';
					  
			let contentBody=excelTemplate(excelFile);
			let contentFoot='&lt;/office:spreadsheet>&lt;/office:body>&lt;/office:document-content>';
			
			let content= contentHead+contentBody+contentFoot;
			
			let manifest='&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?>&lt;manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0">&lt;manifest:file-entry manifest:full-path="/" manifest:media-type="application/vnd.oasis.opendocument.spreadsheet"/>&lt;manifest:file-entry manifest:full-path="styles.xml" manifest:media-type="text/xml"/>&lt;manifest:file-entry manifest:full-path="content.xml" manifest:media-type="text/xml"/>&lt;manifest:file-entry manifest:full-path="meta.xml" manifest:media-type="text/xml"/>&lt;/manifest:manifest>';
			let mimetype='application/vnd.oasis.opendocument.spreadsheet';
			let styles='&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?>&lt;office:document-styles xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" &lt;xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" &lt;xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" &lt;xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" &lt;xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" &lt;xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" &lt;xmlns:xlink="http://www.w3.org/1999/xlink" &lt;xmlns:dc="http://purl.org/dc/elements/1.1/" &lt;xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" &lt;xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" &lt;xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" office:version="1.3">&lt;office:font-face-decls>&lt;style:font-face style:name="Calibri" svg:font-family="Calibri"/>&lt;/office:font-face-decls>&lt;office:styles>&lt;number:number-style style:name="N0">&lt;number:number number:min-integer-digits="1"/>&lt;/number:number-style>&lt;style:style style:name="Default" style:family="table-cell" style:data-style-name="N0">&lt;style:table-cell-properties style:vertical-align="automatic" fo:background-color="transparent"/>&lt;style:text-properties fo:color="#000000" style:font-name="Calibri" style:font-name-asian="Calibri" style:font-name-complex="Calibri" fo:font-size="12pt" style:font-size-asian="12pt" style:font-size-complex="12pt"/>&lt;/style:style>&lt;style:default-style style:family="graphic">&lt;style:graphic-properties draw:fill="solid" draw:fill-color="#4472c4" draw:opacity="100%" draw:stroke="solid" svg:stroke-width="0.01389in" svg:stroke-color="#2f528f" svg:stroke-opacity="100%" draw:stroke-linejoin="miter" svg:stroke-linecap="butt"/>&lt;/style:default-style>&lt;/office:styles>&lt;office:automatic-styles>&lt;style:page-layout style:name="pm1">&lt;style:page-layout-properties fo:margin-top="0.3in" fo:margin-bottom="0.3in" fo:margin-left="0.7in" fo:margin-right="0.7in" style:table-centering="none" style:print="objects charts drawings"/>&lt;style:header-style>&lt;style:header-footer-properties fo:min-height="0.45in" fo:margin-left="0.7in" fo:margin-right="0.7in" fo:margin-bottom="0in"/>&lt;/style:header-style>&lt;style:footer-style>&lt;style:header-footer-properties fo:min-height="0.45in" fo:margin-left="0.7in" fo:margin-right="0.7in" fo:margin-top="0in"/>&lt;/style:footer-style>&lt;/style:page-layout>&lt;/office:automatic-styles>&lt;office:master-styles>&lt;style:master-page style:name="mp1" style:page-layout-name="pm1">&lt;style:header/>&lt;style:header-left style:display="false"/>&lt;style:header-first/>&lt;style:footer/>&lt;style:footer-left style:display="false"/>&lt;style:footer-first/>&lt;/style:master-page>&lt;/office:master-styles>&lt;/office:document-styles>';
			 
			var zip = new JSZip();
			
			zip.file("content.xml", content)
			zip.folder("META-INF").file("manifest.xml", manifestXML)
			zip.file("mimetype", mimetypeXML)
			zip.file("meta.xml", metaXML)
			zip.file("styles.xml", stylesXML)
			var zipConfig = {
						type: 'blob',
						mimeType: 'application/vnd.oasis.opendocument.spreadsheet'
					};
			
			zip.generateAsync(zipConfig)
				.then(function (blob) {
				saveAs(blob, filename+".ods");
			});
		})
	})
  })
 })  
}; 

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
		<xsl:param name="geoMap">world_mill</xsl:param>
		<!--See JVectorMap Website for More Documentation http://jvectormap.com  -->
		<script>
					$(document).ready(function(){			
						$('#mapScope').vectorMap(
							{
								map: '<xsl:value-of select="$geoMap"/>',
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
			
			var collatedCountryList;
			if(selectedBusUnits.length > 0) {
				var busUnitList = selectedBusUnits.slice(0);
				collatedCountryList = getCountries(busUnitList, countryProperty);
			} else {
				collatedCountryList = getCountries(businessUnits.businessUnits, countryProperty);
			}
			
			var countrySet = {};
			
			for (i = 0; collatedCountryList.length > i; i += 1) {
				countrySet[collatedCountryList[i]] = countryColour;
			};

			//console.log("Select Countries: " + collatedCountryList);
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
					<!--countryList = countryList.concat(country);-->
					countryList = countryList.concat(country);
				}
			};
			return countryList;
		
		}
		<!-- END GEOGRAPHIC MAP FUNCTIONS -->
	</xsl:template>
	
	
	<xsl:template mode="RenderElementIDListForJs" match="node()">
		"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="RenderEnumerationJSONList" match="node()">
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="colour" select="eas:get_element_style_colour(current())"/>
		
		{
		id: "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
		name: "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		colour: "<xsl:choose><xsl:when test="string-length($colour) &gt; 0"><xsl:value-of select="$colour"/></xsl:when><xsl:otherwise>#fff</xsl:otherwise></xsl:choose>"
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
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"colour": "<xsl:value-of select="eas:get_element_style_colour(current())"/>"
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="getEnumJSONList">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"style": <xsl:call-template name="RenderElementStyleJSON"><xsl:with-param name="element" select="current()"/></xsl:call-template>
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getSimpleJSONListWithLink">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"colour": "<xsl:value-of select="eas:get_element_style_colour(current())"/>"
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getSimpleJSONListWithLink">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"colour": "<xsl:value-of select="eas:get_element_style_colour(current())"/>"
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:function name="eas:getSafeJSString">
		<xsl:param name="theString"/>
		
		<!-- Restore previous approach. Needs revising to resolve instance IDs with ' ' -->
		<xsl:value-of select="translate($theString, '. ', '__')"/>
		<!-- <xsl:value-of select="encode-for-uri($theString)"></xsl:value-of> -->
	</xsl:function>
	
	<!-- Move this to core_utilities.xsl -->
<!--	<xsl:function name="eas:validJSONString">
		<xsl:param name="theString"/>		
		<xsl:variable name="aQuote">"</xsl:variable>
		<xsl:variable name="anEscapedQuote">\\"</xsl:variable>
		<xsl:value-of select="replace(normalize-unicode($theString), $aQuote, $anEscapedQuote)"/>
	</xsl:function>
	-->
	<!-- Template to render a JSON Object representing the styling details for an EA element -->
	<xsl:function name="eas:getElementContextMenuName">
		<xsl:param name="element" as="node()"/>
		
		<xsl:variable name="elementMenu" select="$utilitiesAllMenus[(own_slot_value[slot_reference = 'report_menu_class']/value = $element/type) and (own_slot_value[slot_reference = 'report_menu_is_default']/value = 'true')]"/>
		
		<xsl:choose>
			<xsl:when test="count($elementMenu) > 0">context-menu-<xsl:value-of select="$elementMenu/own_slot_value[slot_reference = 'report_menu_short_name']/value"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Template to render a JSON Object representing the styling details for an EA element -->
	<xsl:template name="RenderElementStyleJSON">
		<xsl:param name="element" as="node()"/>		
		<xsl:variable name="elementStyle" select="eas:get_element_style_instance($element)"/>
		{
			"elementId": "<xsl:value-of select="eas:getSafeJSString($element/name)"/>",
			"styleClass": "<xsl:value-of select="$elementStyle/own_slot_value[slot_reference = 'element_style_class']/value"/>",
			"styleBgColour": "<xsl:value-of select="$elementStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>",
			"styleIcon": "<xsl:value-of select="$elementStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>",
			"styleTextColour": "<xsl:value-of select="$elementStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"
		}
	</xsl:template>
	
	
	<!-- Template to render a JSON Object representing the styling details for an EA element -->
	<xsl:template name="RenderClassStyleJSON">
		<xsl:param name="class" as="node()"/>
		
		<xsl:variable name="specificClassStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $class/name]"/>
		
		<xsl:variable name="classStyleLabel">
			<xsl:choose>
				<xsl:when test="count($specificClassStyle) > 0">
					<xsl:value-of select="eas:getMultiLangCommentarySlot($specificClassStyle, 'element_style_label')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate($class/name, '_', ' ')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		{
		'classId': '<xsl:value-of select="eas:getSafeJSString($class/name)"/>',
		'styleLabel': '<xsl:value-of select="$classStyleLabel"/>',
		<xsl:choose>
			<xsl:when test="count($specificClassStyle) > 0">
				'styleClass': '<xsl:value-of select="$specificClassStyle/own_slot_value[slot_reference = 'element_style_class']/value"/>',
				'styleBgColour': '<xsl:value-of select="$specificClassStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>',
				'styleIcon': '<xsl:value-of select="$specificClassStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>',
				'styleTextColour': '<xsl:value-of select="$specificClassStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>'
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="defaultCkassStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = 'EA_Class']"/>
				'styleClass': '<xsl:value-of select="$defaultCkassStyle/own_slot_value[slot_reference = 'element_style_class']/value"/>',
				'styleBgColour': '<xsl:value-of select="$defaultCkassStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>',
				'styleIcon': '<xsl:value-of select="$defaultCkassStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>',
				'styleTextColour': '<xsl:value-of select="$defaultCkassStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>'
			</xsl:otherwise>
		</xsl:choose>
		}
	</xsl:template>
	
	
	
</xsl:stylesheet>
