/* script for creating sheets in launchpad */

$('document').ready(function () {
$('#busCapsWorksheetCheck').on("change", function() {
		        
				return promise_loadViewerAPIData(viewAPIDataBusCaps)
					.then(function(response1) {
                  if(switchedOn.includes('busCap')){
                     //do nothing
                  }
                  else{
						//console.log('response1',response1)
						let jsonData=buscaptableTemplate(response1.businessCapabilities)
						$('#bc').css('border-left','25px solid #0aa20a') 
						$('#busDomi').css('color','red') 
						dataRows.sheets.push(
							{  "id":"busCapsWorksheetCheck",
								"name": "Business Capabilities",
								"description": "Used to capture the business capabilities of your organisation.  Some columns are also required to set up the view layout",
								"notes": "Set your root capability to be a single capability which your level 1 capabilities are tied to.  For that ropt capability only, duplicate the name of the capability in this column",
								"headerRow": 7,
								"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}, {"name":"Parent Business Capability", "width": 40}, {"name":"Position in Parent", "width": 20}, {"name":"Sequence Number", "width": 10}, {"name":"Root Capability", "width": 30}, {"name":"Business Domain", "width": 30}, {"name":"Level", "width": 10}],
								"data": JSON.parse(jsonData), 
								"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"},
								{"column": "I", "values":"C", "start": 8, "end": 100, "worksheet": "Business Domains"},
								{"column": "F", "values":"C", "start": 8, "end": 100, "worksheet": "Position Lookup"}
								] 
							})

							let jsonDataPositionLookup =appSvctableTemplate(busCapPosition)
						dataRows.sheets.push(
						{  "id":"posLookup",
							"name": "Position Lookup",
							"description": "Reference List of Positions for Bus Capabilities Model",
							"notes":"",
							"headerRow": 7,
							"visible":false,
							"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}],
							"data": JSON.parse(jsonDataPositionLookup), 
							"lookup": [] 
						})
							//console.log('dr',dataRows)
                     switchedOn.push('busCap','posLookup')
                  
                  }
					}).catch(function(error) {
						console.error('Error:', error);
						alert('Error - ' + error.message);
					});
			})


$('#busDomWorksheetCheck').on("change", function() { 
				 
						return promise_loadViewerAPIData(viewAPIDataBusDoms)
							.then(function(response1) {
                        if(switchedOn.includes('busDom')){
                     //do nothing
                     }
                     else{
								//console.log('response1',response1)
								$('#bd').css('border-left','25px solid #0aa20a') 
								let jsonData=busdomtableTemplate(response1.businessDomains)
								//console.log('jsonData',jsonData)
								dataRows.sheets.push(
									{"id":"busDomWorksheetCheck",
										"name": "Business Domains",
										"description": "Used to capture the Business Domains in scope",
										"headerRow": 7,
										"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}, {"name":"Parent Business Domain", "width": 40}],
										"data": JSON.parse(jsonData), 
										"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Domains"}] 
									})
									//console.log('dr',dataRows)
                        switchedOn.push('busDom')
                        }
							}).catch(function(error) {
								console.error('Error:', error);
								alert('Error - ' + error.message);
							});
					})


$('#busProcsWorksheetCheck').on("change", function() { 
	$('#busDomi').show();  
			return promise_loadViewerAPIData(viewAPIDataBusProcs)
				.then(function(response1) {
               if(switchedOn.includes('busProc')){
                     //do nothing
                  }
                  else{
					//console.log('response1',response1)
					$('#bp').css('border-left','25px solid #0aa20a') 
					$('#busCapsi').css('color','red') 
					let jsonData=busprocesstableTemplate(response1.businessProcesses)
					jsonData =jsonData.replace(/,\s*\]/, ']');
					//console.log('jsonData',jsonData)
					dataRows.sheets.push(
						{  "id":"busProcsWorksheetCheck",
							"name": "Business Processes",
							"description": "Captures the Business processes and their relationship to the business capabilities. For multiple parents, duplicate the row and add each parent",
							"headerRow": 7,
							"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}, {"name":"Parent Capability", "width": 40}],
							"data": JSON.parse(jsonData), 
							"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"}] 
						})
						//console.log('dr',dataRows)
                  switchedOn.push('busProc')

               }
				}).catch(function(error) {
					console.error('Error:', error);
					alert('Error - ' + error.message);
				});
		})

$('#busProcsFamilyWorksheetCheck').on("change", function() { 
			  
					return promise_loadViewerAPIData(viewAPIDataBusProcFams)
						.then(function(response1) {
                     if(switchedOn.includes('busProcFam')){
                     //do nothing
                  }
                  else{
							//console.log('response1',response1)
							$('#bpf').css('border-left','25px solid #0aa20a') 
							$('#busProcsi').css('color','red') 
							let jsonData=busprocessfamilytableTemplate(response1.businessProcessFamilies)
							jsonData =jsonData.replace(/,\s*\]/, ']');
							//console.log('jsonData',jsonData)
							dataRows.sheets.push(
								{  "id":"busProcsFamilyWorksheetCheck",
									"name": "Business Process Families",
									"description": "Used to group Business Processes into their Family groupings, create duplicate rows for mapping multiple processes, just amend the process name",
									"headerRow": 7,
									"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Family Name", "width": 40}, {"name":"Description", "width": 60}, {"name":"Contained Business Processes", "width": 40}],
									"data": JSON.parse(jsonData), 
									"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Processes"}] 
								})
								//console.log('dr',dataRows)
                        switchedOn.push('busProcFam')
                     }
						}).catch(function(error) {
							console.error('Error:', error);
							alert('Error - ' + error.message);
						});
				})		

		 
$('#sitesCheck').on("change", function() {
	return promise_loadViewerAPIData(viewAPIDataSites)
	.then(function(response1) {
      if(switchedOn.includes('site')){
                     //do nothing
                  }
                  else{
		//console.log('response1',response1)
		$('#st').css('border-left','25px solid #0aa20a') 
		let jsonData=sitetableTemplate(response1.sites) 
		//console.log('jsonData',jsonData)
		dataRows.sheets.push(
			{ "id":"sitesCheck",
				"name": "Sites",
				"description": "Used to capture a list of Sites, including the country in which the Site exists",
				"headerRow": 7,
				"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}, {"name":"Country", "width": 40}],
				"data": JSON.parse(jsonData), 
				"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Countries"}] 
			});
		let jsonCtryData=sitetableTemplate(response1.countries) 
 
		dataRows.sheets.push(
			{ "id":"country",
				"name": "Countries",
				"description": "List of Countries for sites select list",
				"headerRow": 7,
				"visible":"false",
				"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}],
				"data": JSON.parse(jsonCtryData), 
				"lookup": [] 
			})
			//console.log('dr',dataRows)
         switchedOn.push('site')
      }
	}).catch(function(error) {
		console.error('Error:', error);
		alert('Error - ' + error.message);
	});	 
})		 
		 
$('#orgsCheck, #orgs2sitesCheck').on("change", function() {return promise_loadViewerAPIData(viewAPIDataOrgs)
	.then(function(response1) {
      if(switchedOn.includes('orgs')){
                     //do nothing
                  }
                  else{
		//console.log('response1',response1)
		$('#or').css('border-left','25px solid #0aa20a') 
      $('#ors').css('border-left','25px solid #0aa20a') 
	  $('#sitesi').css('color', 'red')
		let jsonData=orgtableTemplate(response1.organisations) 
		jsonData =jsonData.replace(/,\s*\]/, ']');
		//console.log('jsonData',jsonData)
		dataRows.sheets.push(
			{ "id":"orgsCheck",
				"name": "Organisations",
				"description": "Capture the organisations and hierarchy/structure",
				"headerRow": 7,
				"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}, {"name":"Parent Organisation", "width": 40},{"name":"external", "width": 20}],
				"data": JSON.parse(jsonData), 
				"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisations"},
				{"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "trueFalseLookup"}] 
			})

			let jsonDataTFLookup =appSvctableTemplate(trueFalse)
						dataRows.sheets.push(
						{  "id":"trueFalseLookup",
							"name": "True False Lookup",
							"description": "True, False",
							"notes":"",
							"headerRow": 7,
							"visible":false,
							"headers": [{"name":"", "width": 20},{"name":"id", "width": 20}, {"name":"Name", "width": 40}],
							"data": JSON.parse(jsonDataTFLookup), 
							"lookup": [] 
						})

		let jsonOrgSiteData=orgsitetableTemplate(response1.organisations) 
		jsonOrgSiteData =jsonOrgSiteData.replace(/,\s*\]/, ']');
	 
		dataRows.sheets.push(
			{ "id":"org2site",
				"name": "Organisation to Sites",
				"description": "Map which organisations use which sites",
				"headerRow": 7,
				"headers": [{"name":"", "width": 20},{"name":"Organisation", "width": 20}, {"name":"Site", "width": 40}],
				"data": JSON.parse(jsonOrgSiteData), 
				"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisations"},
				{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Sites"}] 
			})
			
			//console.log('dr',dataRows)
         switchedOn.push('orgs')
      }
	}).catch(function(error) {
		console.error('Error:', error);
		alert('Error - ' + error.message);
	});	 	 
})


$('#appCapsCheck').on("change", function() { 
			return promise_loadViewerAPIData(viewAPIDataAppCaps)
				.then(function(response1) {
               if(switchedOn.includes('appCap')){
                     //do nothing
                  }
                  else{
					//console.log('response1',response1)
					$('#ac').css('border-left','25px solid #0aa20a') 
					$('#busDomi').css('color','red') 
					$('#busCapsi').css('color','red') 
					busProcsi
					let jsonData=appCaptableTemplate(response1.application_capabilities)
					jsonData =jsonData.replace(/,\s*\]/, ']');
					console.log('jsonData',jsonData)
					dataRows.sheets.push(
						{ "id":"appCapsCheck",
							"name": "Application Capabilities",
							"description": "Captures the Application Capabilities required to support the business and the category to manage the structure of the view",
							"notes":"Ignore the duplicate rows, this is due to the need to extract complex relationships, the import will import normally",
							"headerRow": 7,
							"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}, {"name":"App Cap Category", "width": 40},{"name":"Business Domain", "width": 40},{"name":"Parent Cap Capability", "width": 40},{"name":"Supported Bus Capability", "width": 40},{"name":"Reference Model Layer", "width": 30}],
							"data": JSON.parse(jsonData), 
							"lookup": [{"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Domains"},
							{"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "AppCap Lookup"},
							{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"},
							{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "AppCatLookup"},
							{"column": "I", "values":"C", "start": 8, "end": 2011, "worksheet": "AppRefLookup"}
							] 
						})
				let jsonDataAppCapLookup=appSvctableTemplate(response1.application_capabilities)
				jsonDataAppCapLookup =jsonDataAppCapLookup.replace(/,\s*\]/, ']');
				dataRows.sheets.push(
						{ "id":"appcapLookup",
							"name": "AppCap Lookup",
							"description": "Reference List of Application Capabilities",
							"notes":"",
							"headerRow": 7,
							"visible":false,
							"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}],
							"data": JSON.parse(jsonDataAppCapLookup), 
							"lookup": [] 
						})
						let jsonDataAppCatLookup=appSvctableTemplate(appCategory)
						dataRows.sheets.push(
								{ "id":"appcatLookup",
									"name": "AppCatLookup",
									"description": "Reference List of Application Capability Categories",
									"notes":"",
									"headerRow": 7,
									"visible":false,
									"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}],
									"data": JSON.parse(jsonDataAppCatLookup), 
									"lookup": [] 
								})
						let jsonDataAppRefLookup=appSvctableTemplate(appRefModelLayer)
							 
								dataRows.sheets.push(
										{ "id":"apprefLookup",
											"name": "AppRefLookup",
											"description": "Reference List of Application Capability Reference model positions",
											"notes":"",
											"headerRow": 7,
											"visible":false,
											"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}],
											"data": JSON.parse(jsonDataAppRefLookup), 
											"lookup": [] 
										})				
						//console.log('dr',dataRows)
                  switchedOn.push('appCap')
                        }
				}).catch(function(error) {
					console.error('Error:', error);
					alert('Error - ' + error.message);
				});
})

$('#appSvcsCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataAppSvcs)
		.then(function(response1) {
         if(switchedOn.includes('appSvcs')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#as').css('border-left','25px solid #0aa20a') 
			let jsonData=appSvctableTemplate(response1.application_services)
			jsonData =jsonData.replace(/,\s*\]/, ']');
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"appSvcsCheck",
					"name": "Application Services",
					"description": "Capture the Application Services required to support the business",
					"headerRow": 7,
					"visible":true,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}, {"name":"Description", "width": 60}],
					"data": JSON.parse(jsonData), 
					"lookup": [] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('appSvcs')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})
$('#appCaps2SvcsCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataAppCap2Svcs)
		.then(function(response1) {
         if(switchedOn.includes('appSvs2AC')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#ac2s').css('border-left','25px solid #0aa20a') 
			$('#appCapsi').css('color','red') 
			$('#appSvcsi').css('color','red') 
			let jsonData=appCap2SvctableTemplate(response1.application_capabilities_services)
			jsonData =jsonData.replace(/,\s*\]/, ']');
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"appCaps2SvcsCheck",
					"name": "App Service 2 App Capabilities",
					"description": "Capture the mapping of the Application Services to the Application Capability they support",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Application Capability", "width": 30}, {"name":"Application Service", "width": 30}],
					"data": JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "AppCap Lookup"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Services"}] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('appSvs2AC')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})

$('#appsCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataApps)
		.then(function(response1) {
         if(switchedOn.includes('apps')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#aps').css('border-left','25px solid #0aa20a') 
			let jsonData=appstableTemplate(response1.applications);
			jsonData =jsonData.replace(/,\s*\]/, ']');;
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"appsCheck",
					"name": "Applications",
					"description": "Captures information about the Applications used within the organisation",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60},{"name":"Type", "width": 30},{"name":"Lifecycle Status", "width": 30},{"name":"Delivery Model", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "CodebaseLookup"},{"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "DeliveryLookup"},{"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "LifecycleLookup"}]
				});
			
			let jsonCodebaseData=appSvctableTemplate(allCodebase);
				dataRows.sheets.push(
					{ "id":"codebaseLookup",
						"name": "CodebaseLookup",
						"description": "List of codebases",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonCodebaseData), 
						"lookup": [] 
					})	
			let jsonDeliveryData=appSvctableTemplate(allDelivery);
			dataRows.sheets.push(
				{ "id":"delivlookup",
					"name": "DeliveryLookup",
					"description": "List of app delivery models",
					"headerRow": 7,
					"visible":false,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
					"data":  JSON.parse(jsonDeliveryData), 
					"lookup": [] 
				})	
			let jsonLifeData=appSvctableTemplate(allLifecycle);
				dataRows.sheets.push(
					{ "id":"lifelookup",
						"name": "LifecycleLookup",
						"description": "List of lifecycles",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonLifeData), 
						"lookup": [] 
					})					
				//console.log('dr',dataRows)
            switchedOn.push('apps')
            }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})

$('#apps2svcsCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataApps2Svcs)
		.then(function(response1) {
         if(switchedOn.includes('appServtApp')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#aps2sv').css('border-left','25px solid #0aa20a') 
			$('#appsi').css('color','red') 
			$('#appSvcsi').css('color','red') 
			
			let jsonData=apps2svcstableTemplate(response1.applications_to_services);
			jsonData =jsonData.replace(/,\s*\]/, ']');;
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"apps2svcsCheck",
					"name": "App Service 2 Apps",
					"description": "Maps the Applications to the Services they can provide",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Application", "width": 30},{"name":"Application Service", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Services"}],
					"concatenate": {"column": "D", "type":"=CONCATENATE", "formula": 'B, " as ", C'} 
				})
				//console.log('dr',dataRows)
            switchedOn.push('appServtApp')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})

$('#apps2orgsCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataApps2orgs)
		.then(function(response1) {
         if(switchedOn.includes('app2org')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#aps2or').css('border-left','25px solid #0aa20a') 
			$('#appsi').css('color','red') 
			$('#orgsi').css('color','red') 
			let jsonData=apps2orgtableTemplate(response1.applications_to_orgs)
			jsonData =jsonData.replace(/,\s*\]/, ']');;
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"apps2orgsCheck",
					"name": "Application to User Orgs",
					"description": "Maps the Applications to the Organisations that use them",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Application", "width": 30},{"name":"Organisation", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisations"}] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('app2org')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})
$('#busProc2SvcsCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataBPtoAppsSvc)
		.then(function(response1) {
         if(switchedOn.includes('proctoAppSv')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#bp2srvs').css('border-left','25px solid #0aa20a') 
			$('#busProcsi').css('color','red') 
			$('#appsi').css('color','red') 
			let jsonData=bp2appsvctableTemplate(response1.process_to_service);
			jsonData =jsonData.replace(/,\s*\]/, ']');;
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"busProc2SvcsCheck",
					"name": "Business Process 2 App Services",
					"description": "Maps the business processes to the application services they require",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Business Process", "width": 30},{"name":"Application Service", "width": 30},
					{"name":"Criticality of Application Service", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Processes"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Services"},{"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "CriticalityLookup"}
					] 
				})
				let jsonCriticalityData=appSvctableTemplate(allCriticality);
				dataRows.sheets.push(
					{ "id":"criticalLookup",
						"name": "CriticalityLookup",
						"description": "List of criticalities",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonCriticalityData), 
						"lookup": [] 
					})				
				//console.log('dr',dataRows)
            switchedOn.push('proctoAppSv')
                  }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})

$('#physProc2AppVsCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataPPtoAppsViaSvc)
		.then(function(response1) {
         if(switchedOn.includes('physProctoAS')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#phyp2appsv').css('border-left','25px solid #0aa20a') 
			$('#busProcsi').css('color','red') 
			$('#orgsi').css('color','red') 
			$('#apps2svcsi').css('color','red') 
			let jsonData=pp2appviasvctableTemplate(response1.process_to_apps);
			jsonData =jsonData.replace(/,\s*\]/, ']');;
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"physProc2AppVsCheck",
					"name": "Physical Proc 2 App and Service",
					"description":"Maps the Process to the organisations that perform them, the applications used and what the application is used for (service)",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Business Process", "width": 30},{"name":"Performing Organisation", "width": 30},
					{"name":"Application and Service Used", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Processes"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisations"},{"column": "D", "values":"D", "start": 8, "end": 2011, "worksheet": "App Service 2 Apps"}] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('physProctoAS')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})


$('#physProc2AppCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataPPtoAppsViaSvc)
		.then(function(response1) {
         if(switchedOn.includes('physproc2app')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#phyp2appdirect').css('border-left','25px solid #0aa20a') 
			$('#busProcsi').css('color','red') 
			$('#orgsi').css('color','red') 
			$('#appsi').css('color','red') 
			let jsonData=pp2apptableTemplate(response1.process_to_apps)
			jsonData =jsonData.replace(/,\s*\]/, ']')
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"physProc2AppCheck",
					"name": "Physical Proc 2 App",
					"description": "Maps the Process to the Organisations that perform them and the applications used.",
					"notes": "Only use this sheet if you don't know the services the apps are providing",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Business Process", "width": 30},{"name":"Performing Organisation", "width": 30},
					{"name":"Applications", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Processes"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisations"},{"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"}] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('physproc2app')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})

$('#infoExchangedCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataInfoRep)
		.then(function(response1) {
         if(switchedOn.includes('infoex')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#infex').css('border-left','25px solid #0aa20a') 
			let jsonData=infoReptableTemplate(response1.infoReps)
			jsonData =jsonData.replace(/,\s*\]/, ']')
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"infoExchangedCheck",
					"name": "Information Exchanged",
					"description": "Used to capture the Information exchanged between applications",
					"notes": "",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20},{"name":"Name", "width": 30},
					{"name":"Description", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('infoex')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})

$('#nodesCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataNodes)
		.then(function(response1) {
         if(switchedOn.includes('servers')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#nodes').css('border-left','25px solid #0aa20a') 
			$('#sitesi').css('color', 'red')
			let jsonData=serverstableTemplate(response1.nodes)
			jsonData =jsonData.replace(/,\s*\]/, ']')
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"nodesCheck",
					"name": "Servers",
					"description": "Captures the list of physical technology nodes deployed across the enterprise, and the IP address if available",
					"notes": "",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 30},{"name":"Name", "width": 30},
					{"name":"Hosted In", "width": 30},
					{"name":"IP Address", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Sites"}] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('servers')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})

$('#apps2serverCheck').on("change", function() { 
	return promise_loadViewerAPIData(viewAPIDataApptoServer)
		.then(function(response1) {
         if(switchedOn.includes('app2serv')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#ap2servs').css('border-left','25px solid #0aa20a') 
			$('#nodesi').css('color','red') 
			$('#appsi').css('color','red') 
			let jsonData=app2servertableTemplate(response1.app2server)
			jsonData =jsonData.replace(/,\s*\]/, ']')
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"apps2serverCheck",
					"name": "Application 2 Server",
					"description": "Maps the applications to the servers that they are hosted on, with the environment",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Application", "width": 30},{"name":"Server", "width": 30},
					{"name":"Environment", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Servers"},{"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "EnvironmentLookup"}] 
				})
				let jsonEnvironmentData=appSvctableTemplate(allEnvironment);
				dataRows.sheets.push(
					{
						"name": "EnvironmentLookup",
						"description": "List of codebases",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonEnvironmentData), 
						"lookup": [] 
					})		
				//console.log('dr',dataRows)
            switchedOn.push('app2serv')
            }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})
	
$('#techDomsCheck').on("change", function() {
	return promise_loadViewerAPIData(viewAPIDataTechDomains)
		.then(function(response1) {
         if(switchedOn.includes('techdoms')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#tds').css('border-left','25px solid #0aa20a') 
			let jsonData=techdomstableTemplate(response1.technology_domains)
			jsonData =jsonData.replace(/,\s*\]/, ']')
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"techDomsCheck",
					"name": "Technology Domains",
					"description": "Used to capture a list of Technology Domains",
					"notes": "The positions place the top level domains in some TRM models",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 30},{"name":"Name", "width": 30},
					{"name":"Description", "width": 30},
					{"name":"Position", "width": 20}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "TRMPosLookup"}] 
				})
				
				let jsonTRMLayerData=appSvctableTemplate(techRefModelLayer);
				dataRows.sheets.push(
					{ "id":"trmlookup",
						"name": "TRMPosLookup",
						"description": "List of positions for TRM",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonTRMLayerData), 
						"lookup": [] 
					})			
				//console.log('dr',dataRows)
            switchedOn.push('techdoms')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
})
	
$('#techCapsCheck').on("change", function() {
	return promise_loadViewerAPIData(viewAPIDataTechCap)
	.then(function(response1) {
      if(switchedOn.includes('techcap')){
                     //do nothing
                  }
                  else{
		//console.log('response1',response1)
		$('#tcaps').css('border-left','25px solid #0aa20a') 
		$('#techDomsi').css('color','red') 
		let jsonData=techcapstableTemplate(response1.technology_capabilities)
		jsonData =jsonData.replace(/,\s*\]/, ']')
		//console.log('jsonData',jsonData)
		dataRows.sheets.push(
			{ "id":"techCapsCheck",
				"name": "Technology Capabilities",
				"description": "Used to capture a list of Technology Capabilities",
				"headerRow": 7,
				"headers": [{"name":"", "width": 20},{"name":"ID", "width": 30},{"name":"Name", "width": 30},
				{"name":"Description", "width": 30},
				{"name":"Parent Technology Domain", "width": 20}],
				"data":  JSON.parse(jsonData), 
				"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Domains"}] 
			})
			//console.log('dr',dataRows)
         switchedOn.push('techcap')
      }
	}).catch(function(error) {
		console.error('Error:', error);
		alert('Error - ' + error.message);
	});
})
$('#techCompsCheck').on("change", function() {
		return promise_loadViewerAPIData(viewAPIDataTechComp)
		.then(function(response1) {
         if(switchedOn.includes('techcomp')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#tcomps').css('border-left','25px solid #0aa20a') 
			$('#techCapsi').css('color','red') 
			let jsonData=techcompstableTemplate(response1.technology_components)
			jsonData =jsonData.replace(/,\s*\]/, ']')
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"techCompsCheck",
					"name": "Technology Components",
					"description": "Used to capture a list of Technology Components",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 30},{"name":"Name", "width": 30},
					{"name":"Description", "width": 30},
					{"name":"Parent Technology Capability", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Capabilities"}] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('techcomp')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
	})

$('#techProductsCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataTechProd)
			.then(function(response1) {
            if(switchedOn.includes('techprod')){
                     //do nothing
                  }
                  else{
				//console.log('response1',response1)
				$('#tprods').css('border-left','25px solid #0aa20a') 
				$('#techSuppi').css('color','red') 
				$('#techFami').css('color','red') 
				let jsonData=techproductstableTemplate(response1.technology_products)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"techProductsCheck",
						"name": "Technology Products",
						"description": "Details the Technology Products",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 30},{"name":"Name", "width": 30},
						{"name":"Supplier", "width": 30},
						{"name":"Description", "width": 60},
						{"name":"Product Family", "width": 30},
						{"name":"Vendor Release Status", "width": 30},
						{"name":"Delivery Model", "width": 30},
						{"name":"Usage", "width": 30},
						{"name":"Usage Compliance Level", "width": 30},
						{"name":"Usage Adoption Status", "width": 30}],
						"data":  JSON.parse(jsonData), 
						"lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Suppliers"},
						{"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Product Families"},
						{"column": "I", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Components"},
						{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Suppliers"},
						{"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "VendLifeLookup"},
						{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "TechDeliveryLookup"},
						{"column": "J", "values":"C", "start": 8, "end": 2011, "worksheet": "StdLookup"},
						{"column": "K", "values":"C", "start": 8, "end": 2011, "worksheet": "LifecycleLookup2"}]
					})
					let jsonVendLifeData=appSvctableTemplate(allTechLifecycle);
					dataRows.sheets.push(
						{ "id":"vendlookup",
							"name": "VendLifeLookup",
							"description": "List of vendor lifecycles",
							"headerRow": 7,
							"visible":false,
							"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
							"data":  JSON.parse(jsonVendLifeData), 
							"lookup": [] 
						})	
						
						let jsonTechDelData=appSvctableTemplate(allTechDelivery);
						dataRows.sheets.push(
							{ "id":"techdelivLookup",
								"name": "TechDeliveryLookup",
								"description": "List of technology delivery status",
								"headerRow": 7,
								"visible":false,
								"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
								"data":  JSON.parse(jsonTechDelData), 
								"lookup": [] 
							})	
							
				let jsonStdData=appSvctableTemplate(allStandardStrengths);
				dataRows.sheets.push(
					{ "id":"stdlookup",
						"name": "StdLookup",
						"description": "List of codebases",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonStdData), 
						"lookup": [] 
					})	
			let jsonLifeData=appSvctableTemplate(allLifecycle);
			dataRows.sheets.push(
				{ "id":"lifelookup2",
					"name": "LifecycleLookup2",
					"description": "List of lifecycles",
					"headerRow": 7,
					"visible":false,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
					"data":  JSON.parse(jsonLifeData), 
					"lookup": [] 
				})										
				console.log('dr',dataRows)
               switchedOn.push('techprod')
            }
			})
		})
$('#techSuppliersCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataTechSupplier)
			.then(function(response1) {
            if(switchedOn.includes('supp')){
                     //do nothing
                  }
                  else{
				//console.log('response1',response1)
				$('#tsups').css('border-left','25px solid #0aa20a') 
				let jsonData=techsuppliertableTemplate(response1.technology_suppliers)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"techSuppliersCheck",
						"name": "Technology Suppliers",
						"description": "Used to capture a list of Technology Suppliers",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 30},{"name":"Name", "width": 30},
						{"name":"Description", "width": 30}],
						"data":  JSON.parse(jsonData), 
						"lookup": [] 
					})
					//console.log('dr',dataRows)
               switchedOn.push('supp')
            }
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Error - ' + error.message);
			});
		})
		
$('#techProductFamiliesCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataTechProdFamily)
			.then(function(response1) {
            if(switchedOn.includes('tpf')){
                     //do nothing
                  }
                  else{
				//console.log('response1',response1)
				$('#tprodfams').css('border-left','25px solid #0aa20a') 
				let jsonData=techproductfamilytableTemplate(response1.technology_product_family)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"techProductFamiliesCheck",
						"name": "Technology Product Families",
						"description": "Used to capture a list of Technology Product Families that group separate versions of a Technology Product into a family for that Product. e.g. Oracle WebLogic to group WebLogic 7.0, WebLogic 8.0, WebLogic 9.0",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 30},{"name":"Family Name", "width": 30},
						{"name":"Description", "width": 30}],
						"data":  JSON.parse(jsonData), 
						"lookup": [] 
					})
					//console.log('dr',dataRows)
               switchedOn.push('tpf')
            }
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Error - ' + error.message);
			});
		})

	 
$('#techProducttoOrgsCheck').on("change", function() {
		return promise_loadViewerAPIData(viewAPIDataTechProdOrg)
		.then(function(response1) {
         if(switchedOn.includes('tptouser')){
                     //do nothing
                  }
                  else{
			//console.log('response1',response1)
			$('#tprodors').css('border-left','25px solid #0aa20a') 
			$('#techProdsi').css('color','red') 
			$('#orgsi').css('color','red') 
			let jsonData=techproductorgtableTemplate(response1.technology_product_orgs)
			jsonData =jsonData.replace(/,\s*\]/, ']')
			//console.log('jsonData',jsonData)
			dataRows.sheets.push(
				{ "id":"techProducttoOrgsCheck",
					"name": "Tech Prods to User Orgs",
					"description": "Maps Technology Products to the Organisations that use them",
					"headerRow": 7,
					"headers": [{"name":"", "width": 20},{"name":"Technology Product", "width": 30},{"name":"Organisation", "width": 30}],
					"data":  JSON.parse(jsonData), 
					"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Products"},
					{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisations"}] 
				})
				//console.log('dr',dataRows)
            switchedOn.push('tptouser')
         }
		}).catch(function(error) {
			console.error('Error:', error);
			alert('Error - ' + error.message);
		});
	})
		
$('#dataSubjectCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataDataSubject)
			.then(function(response1) {
            if(switchedOn.includes('datasubj')){
                     //do nothing
                  }
                  else{
				//console.log('response1',response1)
				$('#dsubjs').css('border-left','25px solid #0aa20a') 
				$('#orgsi').css('color','red') 
				let jsonData=dataSubjecttableTemplate(response1.data_subjects)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"dataSubjectCheck",
						"name": "Data Subjects",
						"description": "Captures the data subjects used within the organisation",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20},{"name":"Name", "width": 30},
						{"name":"Description", "width": 30},
						{"name":"Synonym1", "width": 30},
						{"name":"Synonym2", "width": 30},
						{"name":"Data Category", "width": 30},
						{"name":"Organisation Owner", "width": 30},
						{"name":"Individual Owner", "width": 30}],
						"data":  JSON.parse(jsonData), 
						"lookup": [
						{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisations"},
						{"column": "I", "values":"C", "start": 8, "end": 2011, "worksheet": "Individuals Lookup"},{"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "DataCatLookup"}
						] 
					})
					let jsonDataIndividualLookup=appSvctableTemplate(allIndividuals)
					jsonDataIndividualLookup =jsonDataIndividualLookup.replace(/,\s*\]/, ']');
				dataRows.sheets.push(
						{ "id":"indivLookup",
							"name": "Individuals Lookup",
							"description": "Reference List of Individuals",
							"notes":"",
							"headerRow": 7,
							"visible":false,
							"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 40}],
							"data": JSON.parse(jsonDataIndividualLookup), 
							"lookup": [] 
						})
						//console.log('dr',dataRows)
			let jsonDataCatData=appSvctableTemplate(allDataCategory);
			dataRows.sheets.push(
				{ "id":"datacatLookup",
					"name": "DataCatLookup",
					"description": "List of data categories",
					"headerRow": 7,
					"visible":false,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
					"data":  JSON.parse(jsonDataCatData), 
					"lookup": [] 
				})					
            switchedOn.push('datasubj')
            }
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Error - ' + error.message);
			});
		})
$('#dataObjectCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataDataObject)
			.then(function(response1) {
            if(switchedOn.includes('dataobj')){
                     //do nothing
                  }
                  else{
				// console.log('response1',response1)
				$('#dObjs').css('border-left','25px solid #0aa20a') 
				$('#dataSubjsi').css('color','red')  
				let jsonData=dataObjecttableTemplate(response1.data_objects)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"dataObjectCheck",
						"name": "Data Objects",
						"description": "Captures the data objects used within the organisation",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20},{"name":"Name", "width": 30},
						{"name":"Description", "width": 30},
						{"name":"Synonym1", "width": 30},
						{"name":"Synonym2", "width": 30},
						{"name":"Parent Data Subject", "width": 30},
						{"name":"Data Category", "width": 30},
						{"name":"Is Abstract", "width": 30},
						],
						"data":  JSON.parse(jsonData), 
						"lookup": [{"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Data Subjects"},
						{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "DataCatLookup2"},
						{"column": "I", "values":"C", "start": 8, "end": 2011, "worksheet": "isAbstractLookup"}] 
					})

				let jsonDataCatData=appSvctableTemplate(allDataCategory);
				dataRows.sheets.push(
					{ "id":"datacat2",
						"name": "DataCatLookup2",
						"description": "List of data categories",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonDataCatData), 
						"lookup": [] 
					})	
			let jsonAbstractData=appSvctableTemplate(isAbstract);
			dataRows.sheets.push(
				{ "id":"abstract",
					"name": "isAbstractLookup",
					"description": "List of values",
					"headerRow": 7,
					"visible":false,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
					"data":  JSON.parse(jsonAbstractData), 
					"lookup": [] 
				})									
			// console.log('dr',dataRows)
               switchedOn.push('dataobj')
         }
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Error - ' + error.message);
			});
		})

		$('#dataObjectInheritCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataDataObjectInherit)
			.then(function(response1) {
            if(switchedOn.includes('dataobjinherit')){
                     //do nothing
                  }
                  else{
				//console.log('response1',response1)
				$('#dObjins').css('border-left','25px solid #0aa20a') 
				$('#dataObjsi').css('color','red') 
				let jsonData=dataObjectinheritTemplate(response1.data_object_inherit)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"dataObjectInheritCheck",
						"name": "Data Object Inheritance",
						"description": "Captures the relationships between parent and child objects",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"Parent Data Object", "width": 20},{"name":"Child Data Object", "width": 30}],
						"data":  JSON.parse(jsonData), 
						"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Data Objects"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Data Objects"}] 
					})
					//console.log('dr',dataRows)
               switchedOn.push('dataobjinherit')
            }
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Error - ' + error.message);
			});
		})		
		$('#dataObjectAttributeCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataDataObjectAttribute)
			.then(function(response1) {
            if(switchedOn.includes('dataattribs')){
                     //do nothing
                  }
                  else{
				//console.log('response1',response1)
				$('#dObjAts').css('border-left','25px solid #0aa20a') 
				$('#dataObjsi').css('color','red') 
				let jsonData=dataObjectattributeTemplate(response1.data_object_attributes)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"dataObjectAttributeCheck",
						"name": "Data Attributes",
						"description": "Captures the data object Attributes used within the organisation",
						"notes": "One of these per row, not both in one row",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20},{"name":"Data Object Name", "width": 30},
						{"name":"Data Attribute Name", "width": 30},
						{"name":"Description", "width": 40},
						{"name":"Synonym1", "width": 30},
						{"name":"Synonym2", "width": 30},
						{"name":"Data Type (Object)", "width": 30},
						{"name":"Data Type (Primitive)", "width": 30},
						{"name":"Cardinality", "width": 30}],
						"data":  JSON.parse(jsonData), 
						"lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Data Objects"},{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Data Objects"},{"column": "I", "values":"C", "start": 8, "end": 2011, "worksheet": "PrimitiveLookup"},{"column": "J", "values":"C", "start": 8, "end": 2011, "worksheet": "CardinalityLookup"}] 
					})

					  
			let jsonCardData=appSvctableTemplate(allDataCardinaility);
			dataRows.sheets.push(
				{ "id":"cardinality",
					"name": "CardinalityLookup",
					"description": "List of cardinality",
					"headerRow": 7,
					"visible":false,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
					"data":  JSON.parse(jsonCardData), 
					"lookup": [] 
				})	
				let jsonPrimitivesData=appSvctableTemplate(allDataPrimitives);
				dataRows.sheets.push(
					{
						"name": "PrimitiveLookup",
						"description": "List of data primitives",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonPrimitivesData), 
						"lookup": [] 
					})	
					//console.log('dr',dataRows)
               switchedOn.push('dataattribs')
            }
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Error - ' + error.message);
			});
		})		
$('#appDependencyCheck').on("change", function() {
			return promise_loadViewerAPIData(viewAPIDataAppDependency)
			.then(function(response1) {
            if(switchedOn.includes('appdeps')){
                     //do nothing
                  }
                  else{
				//console.log('response1',response1)
				applicationDependencies =response1;
						 //filter out APIs
					      applicationDependencies.application_dependencies = applicationDependencies.application_dependencies.filter(d => {
                      return d.sourceType !== "" && d.targetType !== "";
                     });
				$('#appDps').css('border-left','25px solid #0aa20a') 
				$('#appsi').css('color','red') 
				$('#infoXi').css('color','red') 
				let jsonData=appDependencyTemplate(applicationDependencies.application_dependencies)
				jsonData =jsonData.replace(/,\s*\]/, ']')
				//console.log('jsonData',jsonData)
				dataRows.sheets.push(
					{ "id":"appDependencyCheck",
						"name": "Application Dependencies",
						"description": "Captures the information dependencies between applications; where information passes between applications and the method for passing the information",
						"headerRow": 7,
						"headers": [{"name":"", "width": 20},{"name":"Source Application", "width": 30},{"name":"Target Application", "width": 30},
						{"name":"Information Exchanged", "width": 30},
						{"name":"Acquisition Method", "width": 40},
						{"name":"Frequency", "width": 30}],
						"data":  JSON.parse(jsonData), 
						"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},{"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Information Exchanged"},{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "AcquisitionLookup"},{"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "TimelinessLookup"}] 
					})
					  
			let jsontimelinessData=appSvctableTemplate(allTimeliness);
			dataRows.sheets.push(
				{ "id":"time",
					"name": "TimelinessLookup",
					"description": "List of timeliness",
					"headerRow": 7,
					"visible":false,
					"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
					"data":  JSON.parse(jsontimelinessData), 
					"lookup": [] 
				})	
			let jsonAcqData=appSvctableTemplate(allAcqMeth);
				dataRows.sheets.push(
					{ "id":"acquire",
						"name": "AcquisitionLookup",
						"description": "List of acquisition methods",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonAcqData), 
						"lookup": [] 
					})				
					//console.log('dr',dataRows)
               switchedOn.push('appdeps')
            }
			}).catch(function(error) {
				console.error('Error:', error);
				alert('Error - ' + error.message);
			});
		})	
 
 $('#apptotechCheck').on("change", function() {
	return promise_loadViewerAPIData(viewAPIPathApptoTech)
	.then(function(response1) {
      if(switchedOn.includes('atarch')){
                     //do nothing
                  }
                  else{
		//console.log('response1',response1)
		$('#apptechs').css('border-left','25px solid #0aa20a') 

		$('#appsi').css('color','red') 
		$('#techCompsi').css('color','red') 
		$('#techProdsi').css('color','red') 
		let jsonData= appToTechTemplate(response1.application_technology_architecture)
		jsonData =jsonData.replace(/,\s*\]/, ']')
		//console.log('jsonData',jsonData)
		dataRows.sheets.push(
			{ "id":"apptotechCheck",
				"name": "Application Technology Architecture",
				"description": "Defines the technology architecture supporting applications in terms of Technology Products, the components that they implement and the dependencies between them",
				"notes": "One of these per row, not both in one row",
				"headerRow": 7,
				"headers": [{"name":"", "width": 20},{"name":"Application", "width": 30},{"name":"Environment", "width": 30},
				{"name":"From Technology Product", "width": 30},
				{"name":"From Technology Component", "width": 30},
				{"name":"To Technology Product", "width": 30},
				{"name":"To Technology Component", "width": 30},
				],
				"data":  JSON.parse(jsonData), 
				"lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "EnvironmentLookup2"},{"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Product"},{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Component"},{"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Product"},{"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Component"}] 
			})
			jsonEnvironmentData=appSvctableTemplate(allEnvironment);
				dataRows.sheets.push(
					{ "id":"env2",
						"name": "EnvironmentLookup2",
						"description": "List of codebases",
						"headerRow": 7,
						"visible":false,
						"headers": [{"name":"", "width": 20},{"name":"ID", "width": 20}, {"name":"Name", "width": 30},{"name":"Description", "width": 60}],
						"data":  JSON.parse(jsonEnvironmentData), 
						"lookup": [] 
					})	
			//console.log('dr',dataRows)
         switchedOn.push('atarch')
            }
	}).catch(function(error) {
		console.error('Error:', error);
		alert('Error - ' + error.message);
	});
})	
      
      });