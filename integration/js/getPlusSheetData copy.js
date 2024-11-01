/* script for creating sheets in launchpad */
console.log('loaded')
$('document').ready(function () {
    $('#exportApplicationLifecycles').on("click", function() {
    
    // Assume lifecycles is an array of lifecycle objects
    let headers = [
        {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
        {"name": "ID", "width": 20},
        {"name": "Name", "width": 40}
    ];

    // Adding lifecycle names to the headers dynamically
    lifecycles.forEach(lifecycle => {
        headers.push({"name": lifecycle.name, "width": lifecycle.width || 40}); // Default width is 40 if not specified
    });

    let jsonData = [];
    let appLifecycles=lifecycles.filter((d)=>{return d.type=='Lifecycle_Status'})
    lifecycleModels.forEach(e => {
        if (e.type == 'Lifecycle_Model') {
            let dataRow = {
                id: e.id,
                name: e.subject // Assuming 'description' is a field in your object
            };

            // Mapping lifecycle dates to their corresponding headers
            appLifecycles.forEach(lifecycle => {
                const match = e.dates.find(d => d.lifecycle_status === lifecycle.id);
                // Add each lifecycle date to the data row, ensuring order is maintained
                dataRow[lifecycle.name] = match ? match.date : '';
            });
            jsonData.push(dataRow);
        }
    });

    // Final JSON structure
    dataRows.sheets.push(
        {  "id":"appLifecycles",
            "name": "Application Lifecycles",
            "description": "List of application Lifecycles",
            "notes": "Note you will need to edit yor import spec to map to the lifecycles you have defined",
            "headerRow": 7,
            "headers": headers,
            "data": jsonData, 
            "lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"},
            {"column": "I", "values":"C", "start": 8, "end": 100, "worksheet": "Business Domains"},
            {"column": "F", "values":"C", "start": 8, "end": 100, "worksheet": "Position Lookup"}
            ] 
        })
    
    console.log(dataRows) 
    

    });


    $('#exportApplicationIntegrations').on('click', function(){
         
        console.log('integrations1')
        console.log('integrations', apus)

        function processData(dataArray) {
            const sheets = {
                "Application Dependencies CACA": [],
                "Application Dependencies CAAP": [],
                "Application Dependencies APCA": [],
                "Application Dependencies APAP": [],
                "App Interface Dependencies CACA": [],
                "App Interface Dependencies CAAP": [],
                "App Interface Dependencies APCA": [],
                "App Interface Dependencies APAP": []
            };
        
            function addNonAPIEntry(sheetName, targetApp, info, sourceApp, acquisition, frequency) {
                console.log('i1', info)
                if(info.length==0){
                    info=""
                  }else{
                    info=info.name
                  }
                if(acquisition){ 
                  }else{
                    acquisition=""
                  }
                if(targetApp){ 
                    }else{
                        targetApp=""
                    }
            
                if(sourceApp){ 
                    }else{
                        sourceApp=""
                    }
                if(frequency){ 
                    }else{
                        frequency=""
                    }
                 
                 
                    sheets[sheetName].push({ targetApp, info, sourceApp, acquisition, frequency });
                
                
            }
            function addAPIEntry(sheetName, targetApp, info, api, apiInfo, sourceApp, acquisition, frequency) {
                console.log('i', info)
              if(info.length==0){
                info=""
              }else{
                info=info.name
              }
              if(apiInfo.length==0){
                apiInfo=""
              }else{
                apiInfo=apiInfo.name
              }
              if(acquisition){ 
            }else{
              acquisition=""
            }
            if(targetApp){ 
                }else{
                    targetApp=""
                }
            if(sourceApp){ 
                }else{
                    sourceApp=""
                }
            if(api){ 
                }else{
                    api=""
                }    
            if(frequency){ 
                }else{
                    frequency=""
                }
                sheets[sheetName].push({ sourceApp, info, api, apiInfo, targetApp, acquisition, frequency});
               

            }
        
            function processEntry(entry) {
                const targetAppType = entry.fromApptype;
                const sourceAppType = entry.toAppType;
                const targetApp = entry.fromApp;
                const sourceApp = entry.toApp;
                const targetAppId = entry.fromAppId;
                const sourceAppId = entry.toAppId;
                const acquisition = entry.acquisition;
                const frequency = entry.frequency;
                const info = entry.info;
       
              
                    if (targetAppType === "Composite_Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                        if(info.length > 0){
                            console.log('logging', info)
                            info.forEach((inf)=>{
                                addNonAPIEntry("Application Dependencies CACA", targetApp, inf, sourceApp, acquisition, frequency);
                            })
                        }else{
                            addNonAPIEntry("Application Dependencies CACA", targetApp, info, sourceApp, acquisition, frequency);
                        }
                    } else if (targetAppType === "Composite_Application_Provider" && sourceAppType === "Application_Provider") {
                        addNonAPIEntry("Application Dependencies CAAP", targetApp, info, sourceApp, acquisition, frequency);
                    } else if (targetAppType === "Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                        addNonAPIEntry("Application Dependencies APCA", targetApp, info, sourceApp, acquisition, frequency);
                    } else if (targetAppType === "Application_Provider" && sourceAppType === "Application_Provider") {
                        addNonAPIEntry("Application Dependencies APAP", targetApp, info, sourceApp, acquisition, frequency);
                    } 
                    if(targetAppType === "Application_Provider_Interface"){
                        let matches=apus.filter((e)=>{
                            return e.toAppId == targetAppId
                        })
           
                        matches.forEach((m)=>{
                            if (m.fromApptype === "Composite_Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                if(m.info.length > 0){
                                 
                                    m.info.forEach((inf)=>{
                                        if(info.length > 0){
                                            info.forEach((infB)=>{
                                            addAPIEntry("App Interface Dependencies CACA", m.fromApp, infB, targetApp, inf, sourceApp, acquisition, frequency );
                                            })
                                        
                                        }else{
                                            addAPIEntry("App Interface Dependencies CACA", m.fromApp, info, targetApp, inf, sourceApp, acquisition, frequency );
                                        }

                                    })
                                }else{ 
                                     
                                    info.forEach((infB)=>{
                                        addAPIEntry("App Interface Dependencies CACA", m.fromApp, infB, targetApp, m.info, sourceApp, acquisition, frequency );
                                        })
                                }
                            } else if (m.fromApptype === "Composite_Application_Provider" && sourceAppType === "Application_Provider") {
                                addAPIEntry("App Interface Dependencies CAAP",  m.fromApp, m.info, targetApp, info, sourceApp, acquisition, frequency );
                            } else if (m.fromApptype === "Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                addAPIEntry("App Interface Dependencies APCA",  m.fromApp, m.info, targetApp, info, sourceApp, acquisition, frequency );
                            } else if (m.fromApptype  === "Application_Provider" && sourceAppType === "Application_Provider") {
                                addAPIEntry("App Interface Dependencies APAP", m.fromApp, m.info, targetApp, info, sourceApp, acquisition, frequency );
                            } 
                        })
                      
                    }
                    else if (sourceAppType === "Application_Provider_Interface" ) {
                        
                        let smatches=apus.filter((e)=>{
                        return e.toAppId == sourceAppId
                        })
                 
                        smatches.forEach((m)=>{
                            if (m.toAppType === "Composite_Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                addAPIEntry("App Interface Dependencies CACA",  m.fromApp, m.info, targetApp, info, sourceApp, acquisition, frequency );
                            } else if (m.toAppType === "Composite_Application_Provider" && sourceAppType === "Application_Provider") {
                                addAPIEntry("App Interface Dependencies CAAP",  m.fromApp, m.info, targetApp, info, sourceApp, acquisition, frequency );
                            } else if (m.toAppType === "Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                addAPIEntry("App Interface Dependencies APCA",  m.fromApp, m.info, targetApp, info, sourceApp, acquisition, frequency );
                            } else if (m.toAppType  === "Application_Provider" && sourceAppType === "Application_Provider") {
                                addAPIEntry("App Interface Dependencies APAP",  m.fromApp, m.info, targetApp, info, sourceApp, acquisition, frequency );
                            } 
                        })
                    }
            }
        
            dataArray.forEach(entry => {
                processEntry(entry);
            });
        
            // Handle Application_Provider_Interface logic here, if needed
        
            return sheets;
        }
         
        const sheetsData = processData(apus);
        console.log(sheetsData);

        Object.keys(sheetsData).forEach(sheetName => {
            const propertyName = sheetName.replace(/ /g, '');
            const jsonData = JSON.stringify(sheetsData[sheetName]);
           
            if(sheetName.toLowerCase().includes('interface')){
                
            dataRows.sheets.push({
                "id": propertyName,
                "name": sheetName,
                "headerRow": 7,
                "headers": [
                    { "name": "", "width": 20 },
                    { "name": "Source Application", "width": 40 },
                    { "name": "Information Exchanged", "width": 40 },
                    { "name": "Interface App Used", "width": 60 },
                    { "name": "Information Exchanged", "width": 40 },
                    { "name": "Target Application", "width": 20 },
                    { "name": "Acquisition Method", "width": 10 },
                    { "name": "Frequency", "width": 30 }
                ],
                "data": JSON.parse(jsonData)
            });
            
          }else{
            dataRows.sheets.push({
                "id": propertyName,
                "name": sheetName,
                "headerRow": 7,
                "headers": [
                    { "name": "", "width": 20 },
                    { "name": "Source Application", "width": 40 },
                    { "name": "Information Exchanged", "width": 40 }, 
                    { "name": "Target Application", "width": 20 },
                    { "name": "Acquisition Method", "width": 10 },
                    { "name": "Frequency", "width": 30 }
                ],
                "data": JSON.parse(jsonData)
            });

          }
        });

        console.log('dataRows',dataRows)

        /*
        return promise_loadViewerAPIData(viewAPIDataBusCaps)
        .then(function(response1) {

            //console.log('response1',response1)
            let jsonData=deptableTemplate(response1.businessCapabilities)
            dataRows.sheets.push(
                {  "id":"busCapsWorksheetCheck",
                    "name": "Business Capabilities",
                    "description": "Used to capture the business capabilities of your organisation.  Some columns are also required to set up the view layout",
                    "notes": "Set your root capability to be a single capability which your level 1 capabilities are tied to.  For that ropt capability only, duplicate the name of the capability in this column",
                    "headerRow": 7,
                    					
                    "headers": [{"name":"", "width": 20},{"name":"Source Application", "width": 40}, {"name":"Information Exchanged", "width": 40}, {"name":"Interface App Used", "width": 60}, {"name":"Information Exchanged	", "width": 40}, {"name":"Target Application", "width": 20}, {"name":"Acquisition Method", "width": 10}, {"name":"Frequency", "width": 30}],
                    "data": JSON.parse(jsonData), 
                    "lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"},
                    {"column": "I", "values":"C", "start": 8, "end": 100, "worksheet": "Business Domains"},
                    {"column": "F", "values":"C", "start": 8, "end": 100, "worksheet": "Position Lookup"}
                    ] 
                })

      })
      */
  
     })

});