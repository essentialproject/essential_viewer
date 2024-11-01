/* script for creating plus sheets in launchpad */
const generateStratPlans = (data, refMap, plusIdType) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        // If roadmap is an array, create a row for each roadmap
        if (Array.isArray(item.roadmaps)) {
          return item.roadmaps.map((roadmap) => ({
            id: refValue,
            roadmap: roadmap,
            name: item.name,
            description: item.description,
            startDate: item.validStartDate ?? "",
            endDate: item.validEndDate ?? ""
          }));
        } else {
          // Otherwise, create a single row with the given roadmap
          return {
            id: refValue,
            roadmap: item.roadmap ?? "",
            name: item.name,
            description: item.description,
            startDate: item.validStartDate ?? "",
            endDate: item.validEndDate ?? ""
          };
        }
      })
      .filter(Boolean); // Filter out null or empty values
  };
  
  const generateStratPlansObj = (data, refMap, plusIdType) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        // If roadmap is an array, create a row for each roadmap
        if (Array.isArray(item.objectives)) {
          return item.objectives.map((obj) => ({
            name: item.name,
            objectives: obj.name ?? ""
          }));
        } else {
          // Otherwise, create a single row with the given roadmap
          return {
            name: item.name,
            objectives: item.objectives.name
          };
        }
      })
      .filter(Boolean); // Filter out null or empty values
  };

  
  const generateStratPlanDeps = (data, refMap, plusIdType) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        // If roadmap is an array, create a row for each roadmap
        if (Array.isArray(item.dependsOn)) {
          return item.dependsOn.map((obj) => ({
            name: item.name,
            dependsOn: obj.name ?? ""
          }));
        } else {
          // Otherwise, create a single row with the given roadmap
          return {
            name: item.name,
            dependsOn: item.dependsOn.name
          };
        }
      })
      .filter(Boolean); // Filter out null or empty values
  };
  
  const generateProgrammes = (data, refMap, plusIdType) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return {
            id: refValue, 
            name: item.name,
            description: item.description,
            startDate: item.actualStartDate ?? "",
            endDate: item.forecastEndDate ?? ""
          };
      })
      .filter(Boolean); // Filter out null or empty values
  };

  const generateProjects = (data, refMap, plusIdType) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return {
            id: refValue, 
            name: item.name,
            description: item.description,
            startDate: item.actualStartDate ?? "",
            endDate: item.forecastEndDate ?? "",
            lifecycle: item.lifecycleStatus,
            programme: item.programme.name
          };
      })
      .filter(Boolean); // Filter out null or empty values
  };
  
  const generatePlanningActions = (data, refMap, plusIdType) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return { 
            plan: item.plan,
            item: item.name,
            change: item.action,
            rationale: item.relation_name ?? "",
            project: item.projectName ?? ""
          };
      })
      .filter(Boolean); // Filter out null or empty values
  };

  
  const generatePlanPhysProcesses = (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return { 
            name: item.busProcessName,
            organisation: item.orgName,
            role: item.role || ""
          };
      })
      .filter(Boolean); // Filter out null or empty values
  };

  const generateSvcQuals = (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return { 
            id: item.id,
            name: item.name, 
            description: item.description

          };
      })
      .filter(Boolean); // Filter out null or empty values
  };

  const generateCJTemplate = (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If plusIdType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        // Check if item.products exists and is an array
        if (Array.isArray(item.products) && item.products.length > 0) {
          // Map each product to a row
          return item.products.map((product) => ({
            id: item.id,
            name: item.name,
            description: item.description,
            product: product.name // Assuming each product has its own properties
          }));
        }
  
        // Return a single row if no products array exists
        return {
          id: item.id,
          name: item.name,
          description: item.description,
          product: item.product.name // Use item.product if no products array exists
        };
      })
      .filter(Boolean); // Filter out null or empty values
  };
  
  const generateCJPTemplate = (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If plusIdType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        // Return a single row if no products array exists
        return {
          id: item.id,
          journey: item.cjp_customer_journey,
          index: item.index,
          phase: item.name.replace(/.*\d+\.\s*/, ''),
          description: item.description,
          experience: item.cjp_experience_rating 
        };
      })
      .filter(Boolean); // Filter out null or empty values
  };
 
  
  const generateCJPtoVSTemplate = (data) => {
    return data
    .flatMap((item) => {
        return {  
          cjp: item.cjp,
          vs: item.vs
        };
    })
  };

  const generateCJPtoPPTemplate = (data) => {
    return data
    .flatMap((item) => {
        return {  
          cjp: item.cjp,
          pp: item.pp
        };
    })
  };

  const generateCJPtoEmot = (data) => {
    return data
    .flatMap((item) => {
        return {  
          cjp: item.cjp,
          vs: item.emot
        };
    })
  };

  const generateCJPtoSQV = (data) => {
    return data
    .flatMap((item) => {
        return {  
          cjp: item.cjp,
          sqv: item.sqv
        };
    })
  };
  

  const generateSvcQualsVals = (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return { 
            id: item.id,
            name: item.name.split(" - ")[0], 
            value: item.value,
            description: item.description,
            colour:item.colour,
            style:item.classStyle,
            score: item.score


          };
      })
      .filter(Boolean); // Filter out null or empty values
  };

  const generateStageTemplate = (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return { 
            id: item.id,
            name: item.name.split(':')[0].trim(), 
            index: item.name.split(':')[1].match(/\d+/)[0],
            stagename: item.link,
            description:item.description

          };
      })
      .filter(Boolean); // Filter out null or empty values
  };

  const generateEnums = (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return { 
            id: item.id,
            name: item.name,
            description: item.description,
            colour: item.colour, 
            styleClass: item.class,
            index: item.seqNo,
            score: item.score

          };
      })
      .filter(Boolean); // Filter out null or empty values
  };

  const generateCompositeSQs= (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
  
        return item.perfmeasures.map((sq) => ({
          id:sq.id,
          name: item.name,           // Parent name, repeated for each measure
          service_quality: sq.name,  // Performance measure name
        }));
      }).filter(Boolean);
       // Filter out null or empty values
  };

  
 
  const generateTPSTemplate= (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
        return { 
          id: item.id,
          name: item.name, 
          supplier: item.supplier, 
          description:item.description

        };
      }).filter(Boolean);
       // Filter out null or empty values
  };

  
  const generateContractTypeTemplate= (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
        return { 
          id: item.id,
          name: item.name, 
          description:item.description,
          sequence: item.sequence_no,
          colour: item.backgroundColour,
          styleClass: item.styleClass,
          label: item.label

        };
      }).filter(Boolean);
       // Filter out null or empty values
  };

  const generateContractType2Template= (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
        return { 
          id: item.id,
          name: item.name, 
          description:item.description,
          sequence: item.sequence_no,
          colour: item.backgroundColour,
          styleClass: item.styleClass

        };
      }).filter(Boolean);
       // Filter out null or empty values
  };
 
  const generateSupplierTemplate= (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
        return { 
          id: item.id,
          name: item.name, 
          description:item.description,
          relationshipStatus: item.supplierRelStatus,
          link: item.suuplier_url,
          external: ""

        };
      }).filter(Boolean);
       // Filter out null or empty values
  };

  const generateContractTemplate= (data) => {
    return data
      .flatMap((item) => {
        // Ensure item.id exists and is valid
        const hasValidId = item && item.id !== undefined && item.id !== null;
        if (!hasValidId) {
          return [];
        }
  
        // Determine the reference value for item.id
        let refValue = refMap && refMap[item.id] ? refMap[item.id].name : item.id;
        if (!plusIdType) {
          refValue = item.id; // Use item.id if plusIdType is false
        }
  
        // If idType is true but no reference exists in refMap, skip this item
        if (plusIdType && (!refMap || !refMap[item.id])) {
          return [];
        }
        return { 
          id: item.id,
          suppliername: item.supplier_name, 
          contractName:item.name,
          contractOwner: item.owner,
          description: item.description,
          signDate: item.signature_date,
          renewalDate: item.renewalDate,
          endDate: item.contract_end_date,
          noticePeriod: item.renewalNoticeDays,
          url: ""

        };
      }).filter(Boolean);
       // Filter out null or empty values
  };

$('document').ready(function () {
    $('#exportApplicationLifecycles').on("click", function() {
        dataRows = {"sheets": []}; 
        Promise.all([
			promise_loadViewerAPIData(viewAPIPathAppLifecycles) 
			]).then(function(responses) {
                
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
                })
                
    });

    /* Final JSON structure
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
   */  

    });


    $('#exportApplicationIntegrations').on('click', function(){
        dataRows = {"sheets": []}; 
        Promise.all([
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataInfoRep) 
			]).then(function(responses) {
            
        let headers = [
            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
            {"name": "ID", "width": 20},
            {"name": "Name", "width": 40},
            {"name": "Description", "width": 40}
        ];

        let compapps=responses[0].applications.filter((e)=>{return e.class=='Composite_Application_Provider'})
        let appProapps=responses[0].applications.filter((e)=>{return e.class=='Application_Provider'})

        let jsonData=generateStandardTemplate(compapps);
        let jsonDataAP=generateStandardTemplate(appProapps);
        let jsonDataInfoEx=generateStandardTemplate(responses[1].infoReps);
        let jsonDataAPI=generateStandardTemplate(apis);
        let frequencyTypesJson=generateStandardTemplate(frequencyTypes);
        let jsonDataAPIJson=generateStandardTemplate(acquisitionTypes);
      
        dataRows.sheets.push(
            {  "id":"frequency",
                "name": "Frequency",
                "description": "Frequency list",
                "notes": " ",
                "headerRow": 7,
                "headers": headers,
                "visible": false,
                "data": frequencyTypesJson,  
                "lookup": [] 
            })

             
         
        dataRows.sheets.push(
            {  "id":"acquisition",
                "name": "Acquisition",
                "description": "Acquisition list",
                "notes": " ",
                "headerRow": 7,
                "headers": headers,
                "visible": false,
                "data": jsonDataAPIJson,  
                "lookup": [] 
            })    

        dataRows.sheets.push(
            {  "id":"applications",
                "name": "Applications",
                "description": "Captures information about the Applications used within the organisation",
                "notes": "Use this sheet for Composite Application Providers",
                "headerRow": 7,
                "headers": headers,
                "data": jsonData,  
                "lookup": [] 
            })

        dataRows.sheets.push(
            {  "id":"applicationmodules",
                "name": "Application Modules",
                "description": "Captures information about the Application Modules used within the organisation",
                "notes": "Use this sheet for Application Providers",
                "headerRow": 7,
                "headers": headers,
                "data": jsonDataAP,  
                "lookup": [] 
                })    

        dataRows.sheets.push(
            {  "id":"infoExchange",
                "name": "Information Exchanged",
                "description": "Captures information for info exchnage between applications",
                "notes": " ",
                "headerRow": 7,
                "headers": headers,
                "data": jsonDataInfoEx,  
                "lookup": [] 
                })  

        dataRows.sheets.push(
            {  "id":"apis",
                "name": "App Pro Interface",
                "description": "Captures information for APIs",
                "notes": " ",
                "headerRow": 7,
                "headers": headers,
                "data": jsonDataAPI,  
                "lookup": [] 
                })   
        
                

        })
     
 
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
                 
                    if(sheetName){
                     sheets[sheetName].push({ sourceApp, info, targetApp, acquisition, frequency });
                    }
                
                
            }
            function addAPIEntry(sheetName, targetApp, info, api, apiInfo, sourceApp, acquisition, frequency) {
              
              
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

                if(sheetName){
                    sheets[sheetName].push({ sourceApp, info, api, apiInfo, targetApp, acquisition, frequency});
                }

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
             
                            info.forEach((inf)=>{
                                addNonAPIEntry("Application Dependencies CACA", targetApp, inf, sourceApp, acquisition, frequency);
                            })
                        }else{
                            addNonAPIEntry("Application Dependencies CACA", targetApp, info, sourceApp, acquisition, frequency);
                        }
                    } else if (targetAppType === "Composite_Application_Provider" && sourceAppType === "Application_Provider") {
                        addNonAPIEntry("Application Dependencies APCA", targetApp, info, sourceApp, acquisition, frequency);
                    } else if (targetAppType === "Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                        addNonAPIEntry("Application Dependencies CAAP", targetApp, info, sourceApp, acquisition, frequency);
                    } else if (targetAppType === "Application_Provider" && sourceAppType === "Application_Provider") {
                        addNonAPIEntry("Application Dependencies APAP", targetApp, info, sourceApp, acquisition, frequency);
                    } 
                    if(targetAppType === "Application_Provider_Interface"){
                        let matches=apus.filter((e)=>{
                            return e.toAppId == targetAppId
                        })
       
                     
                        matches.forEach((m)=>{
                   
             
                            let sheetName='';
                            if (m.fromApptype === "Composite_Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                sheetName='App Interface Dependencies CACA';

                            }
                            else if (m.fromApptype === "Composite_Application_Provider" && sourceAppType === "Application_Provider") {
                                sheetName='App Interface Dependencies APCA'
                                
                            }
                            else if (m.fromApptype === "Application_Provider" && sourceAppType === "Composite_Application_Provider") {
                                sheetName='App Interface Dependencies CAAP'
                            
                            }else if (m.fromApptype  === "Application_Provider" && sourceAppType === "Application_Provider") {
                                    sheetName='App Interface Dependencies APAP'
                               
                            }
                      
                                if(m.info.length > 0){
                                 
                                    m.info.forEach((inf)=>{
                                        if(info.length > 0){
                                            info.forEach((infB)=>{
                                            addAPIEntry(sheetName, m.fromApp, infB, targetApp, inf, sourceApp, acquisition, frequency );
                                            })
                                        
                                        }else{
                                            addAPIEntry(sheetName, m.fromApp, info, targetApp, inf, sourceApp, acquisition, frequency );
                                        }

                                    })
                                }else{        
                                    info.forEach((infB)=>{
                                        addAPIEntry(sheetName, m.fromApp, infB, targetApp, m.info, sourceApp, acquisition, frequency );
                                        })
                                }
                            
                        })
                      
                    }
                    /*
                    if(sourceAppType === "Application_Provider_Interface"){
                        let matches=apus.filter((e)=>{
                            return e.toAppId == sourceAppId
                        })
       
                     
                        matches.forEach((m)=>{
                            console.log('APIS', sourceApp)
                            console.log('API', targetApp)
                            console.log(m.fromApptype)
                            console.log(m)
                        })
                    }
                        */
    
            }
        
           
            dataArray.forEach(entry => {
                processEntry(entry);
            });
        
            return sheets;
        }
         
        const sheetsData = processData(apus);
       
        Object.keys(sheetsData).forEach(sheetName => {
            const propertyName = sheetName.replace(/ /g, ''); 
            const jsonData = JSON.stringify(sheetsData[sheetName]);
            let lookups=[];
            if(sheetName == "Application Dependencies CACA"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"}, 
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }else 
            if(sheetName == "Application Dependencies CAAP"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }else
            if(sheetName == "Application Dependencies APCA"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }else
            if(sheetName == "Application Dependencies APAP"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }else
            if(sheetName == "App Interface Dependencies CACA"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "App Pro Interface"},
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Information Exchanged"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
            {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }else
            if(sheetName == "App Interface Dependencies CAAP"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "App Pro Interface"},
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Information Exchanged"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }else
            if(sheetName == "App Interface Dependencies APCA"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "App Pro Interface"},
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Information Exchanged"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
            {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }else
            if(sheetName ==  "App Interface Dependencies APAP"){
                lookups=[{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "C", "values":"C", "start": 8, "end": 400, "worksheet": "Information Exchanged"},
            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "App Pro Interface"},
            {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Information Exchanged"},
            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Modules"},
            {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Acquisition"},
            {"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Frequency"}
            ] 
            }

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
                "data": JSON.parse(jsonData),
                "lookup":lookups
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
                "data": JSON.parse(jsonData),
                "lookup":lookups
            });

          }
        });
        createPlusWorkbookFromJSON()
     })

    $('#exportStrategicPlans').on("click", function() {
        dataRows = {"sheets": []}; 
        Promise.all([
            promise_loadViewerAPIData(viewAPIDataBusCaps),
            promise_loadViewerAPIData(viewAPIDataBusProcs),
            promise_loadViewerAPIData(viewAPIDataAppSvcs),
            promise_loadViewerAPIData(viewAPIDataOrgs),
            promise_loadViewerAPIData(viewAPIDataApps),
            promise_loadViewerAPIData(viewAPIDataTechComp),
            promise_loadViewerAPIData(viewAPIDataTechProd),
            promise_loadViewerAPIData(viewAPIPathPlansProjs),
            promise_loadViewerAPIData(viewAPIPathStrategic)
            
            ]).then(function(responses) {
               
                // Assume lifecycles is an array of lifecycle objects
                let headers = [
                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                    {"name": "ID", "width": 20},
                    {"name": "Name", "width": 40},
                    {"name": "Description", "width": 60}
                ];


                let jsonDataRoadmap=generateStandardTemplateInternalId(responses[7].roadmaps, refMap, plusIdType);
                    
                        dataRows.sheets.push(
                            {  "id":"roadmaps",
                                "name": "Roadmaps",
                                "description": "list of Roadmaps",
                                "notes": " ",
                                "headerRow": 7,
                                "headers": headers,
                                "visible": true,
                                "data": jsonDataRoadmap,  
                                "lookup": [] 
                            })         

                            let jsonDataPlanning=generateStandardTemplate(allPlanningAction);
                            dataRows.sheets.push(
                                {  "id":"allPlanningActions",
                                    "name": "Planning Actions",
                                    "description": "list of Planning Actions",
                                    "notes": "",
                                    "headerRow": 7,
                                    "headers": headers,
                                    "visible": false,
                                    "data": jsonDataPlanning,  
                                    "lookup": [] 
                                })  

                        let jsonDataProjLifes=generateStandardTemplate(allprojlifecycle);
                        dataRows.sheets.push(
                            {  "id":"allProjectLifecycle",
                                "name": "Project Lifecycles",
                                "description": "list of Project Lifecycles",
                                "notes": "",
                                "headerRow": 7,
                                "headers": headers,
                                "visible": false,
                                "data": jsonDataProjLifes,  
                                "lookup": [] 
                            })  

                        let jsonDataStratPlanList=generateStandardTemplate( responses[7].allPlans);
                            dataRows.sheets.push(
                                {  "id":"allStratPlanList",
                                    "name": "Strat Plan List",
                                    "description": "list of Strat plans",
                                    "notes": "",
                                    "headerRow": 7,
                                    "headers": headers,
                                    "visible": false,
                                    "data": jsonDataStratPlanList,  
                                    "lookup": [] 
                                })    

                let jsonData=generateStandardTemplate(responses[0].businessCapabilities);
                
                dataRows.sheets.push(
                    {  "id":"busCaps",
                        "name": "Business Capabilities",
                        "description": "list of Business Capabilities",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": false,
                        "data": jsonData,  
                        "lookup": [] 
                    })

                let jsonDataBP=generateStandardTemplate(responses[1].businessProcesses);
                
                dataRows.sheets.push(
                    {  "id":"busProcesses",
                        "name": "Business Processes",
                        "description": "list of Business Processes",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": false,
                        "data": jsonDataBP,  
                        "lookup": [] 
                    })
                let jsonDataAS=generateStandardTemplate(responses[2].application_services);
                
                dataRows.sheets.push(
                    {  "id":"appServices",
                        "name": "Application Services",
                        "description": "list of Application Services",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": false,
                        "data": jsonDataAS,  
                        "lookup": [] 
                    })
                let jsonDataOrg=generateStandardTemplate(responses[3].organisations);
                
                dataRows.sheets.push(
                    {  "id":"orgs",
                        "name": "Organisation",
                        "description": "list of Organisations",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": false,
                        "data": jsonDataOrg,  
                        "lookup": [] 
                    })
                let jsonDataApp=generateStandardTemplate(responses[4].applications);
                
                dataRows.sheets.push(
                    {  "id":"Applications",
                        "name": "Applications",
                        "description": "list of Applications",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": false,
                        "data": jsonDataApp,  
                        "lookup": [] 
                    })
                let jsonDataTC=generateStandardTemplate(responses[5].technology_components);
                
                dataRows.sheets.push(
                    {  "id":"techComponents",
                        "name": "Technology Components",
                        "description": "list of Technology Components",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": false,
                        "data": jsonDataTC,  
                        "lookup": [] 
                    })
                let jsonDataTP=generateStandardTemplate(responses[6].technology_products);
                
                dataRows.sheets.push(
                    {  "id":"techProducts",
                        "name": "Technology Products",
                        "description": "list of Technology Products",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": false,
                        "data": jsonDataTP,  
                        "lookup": [] 
                    })

                let jsonDataObj=generateStandardTemplateInternalId(responses[8].objectives, refMap);
                    
                    dataRows.sheets.push(
                        {  "id":"objectives",
                            "name": "Objectives",
                            "description": "list of Objectives",
                            "notes": " ",
                            "headerRow": 7,
                            "headers": headers,
                            "visible": false,
                            "data": jsonDataObj,  
                            "lookup": [] 
                        })    

                let stratPlans =responses[7].allPlans
                stratPlans.forEach(plan => {
                    // Initialize the 'roadmaps' property as an empty array in each plan
                    plan.roadmaps = [];
                
                    // Loop through each roadmap in Roamaps
                    responses[7].roadmaps.forEach(roadmap => {
                        // Check if the plan id exists in the strategicPlans array of the roadmap
                        if (roadmap.strategicPlans.includes(plan.id)) {
                            // Add the roadmap name to the roadmaps array of the plan
                            plan.roadmaps.push(roadmap.name);
                        }
                    });
                });
                 
                let jsonDataStratPlans=generateStratPlans(responses[7].allPlans, refMap, plusIdType);
               
                    dataRows.sheets.push(
                        {  "id":"stratPlans",
                            "name": "Strategic Plans",
                            "description": "list of Strategic Plan",
                            "notes": "A strategic plan may appear more than once where it is mapped to multiple roadmaps, ensure the data is the same for all fields",
                            "headerRow": 7,
                            "headers": [
                                {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                {"name": "ID", "width": 20},
                                {"name": "Roadmap", "width": 40},
                                {"name": "Strategic Plan name", "width": 40},
                                {"name": "Description", "width": 60},
                                {"name": "Start Date", "width": 20},
                                {"name": "End Date", "width": 20}
                            ],
                            "visible": true,
                            "data": jsonDataStratPlans,  
                            "lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Roadmaps"}]  
                        })      
                        
                let jsonDataStratPlantoObjs=generateStratPlansObj(responses[7].allPlans, refMap, plusIdType);
               
                        dataRows.sheets.push(
                            {  "id":"stratPlansObj",
                                "name": "Strat Plan Objectives",
                                "description": "list of Strategic Plan to Objectives",
                                "notes": "",
                                "headerRow": 7,
                                "headers": [
                                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                    {"name": "Strategic Plan", "width": 40},
                                    {"name": "Objective", "width": 40}
                                ],
                                "visible": true,
                                "data": jsonDataStratPlantoObjs,  
                                "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                    {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Objectives"}] 
                            })  
                 
                   
                    const extendDependsOnWithPlanNames = (allPlans) => {
                        return allPlans.map(plan => {
                          // Check if the plan has dependsOn
                          if (plan.dependsOn && plan.dependsOn.length > 0) {
                            // Extend dependsOn with the corresponding plan names
                            const extendedDependsOn = plan.dependsOn.map(depId => {
                              // Find the plan that matches the dependsOn id
                              const matchedPlan = allPlans.find(p => p.id === depId);
                              // Return an object that includes both the ID and the name of the matched plan
                              return {
                                id: depId,
                                name: matchedPlan ? matchedPlan.name : '' // Fallback if plan not found
                              };
                            });
                      
                            // Update the dependsOn with the extended data
                            return {
                              ...plan,
                              dependsOn: extendedDependsOn
                            };
                          }
                      
                          // If no dependsOn, return the plan as is
                          return plan;
                        });
                      };
                      
                      // Use the function to extend the dependsOn property
                      const allPlans = extendDependsOnWithPlanNames(responses[7].allPlans);
                      
                      // Example usage
                       
                let jsonDataStratPlanDeps=generateStratPlanDeps(allPlans, refMap, plusIdType);
               
                    dataRows.sheets.push(
                        {  "id":"stratPlansDeps",
                            "name": "Strat Plan Dependencies",
                            "description": "list of Strategic Plan dependencies",
                            "notes": "",
                            "headerRow": 7,
                            "headers": [
                                {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                {"name": "Strategic Plan", "width": 40},
                                {"name": "Depends on Plan", "width": 40}
                            ],
                            "visible": true,
                            "data": jsonDataStratPlanDeps,  
                            "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"}] 
                        })      

                let jsonDataProgrammes=generateProgrammes(responses[7].programmes, refMap, plusIdType);
               
                        dataRows.sheets.push(
                            {  "id":"programmes",
                                "name": "Programmes",
                                "description": "list of Programmes",
                                "notes": "",
                                "headerRow": 7,
                                "headers": [
                                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                    {"name": "ID", "width": 20},
                                    {"name": "Programme Name", "width": 40},
                                    {"name": "Description", "width": 60},
                                    {"name": "Start Date", "width": 20},
                                    {"name": "End Date", "width": 20}
                                ],
                                "visible": true,
                                "data": jsonDataProgrammes,  
                                "lookup": [] 
                            })      
                       
                            const updateProjectProgrammes = (projects, programmes) => {
                                return projects.map(project => {
                                  // Find the corresponding programme by ID in the `programmes` array
                                  const matchedProgramme = programmes.find(p => p.id === project.programme);
                              
                                  // If a matching programme is found, update the `programme` property to include the name
                                  if (matchedProgramme) {
                                    return {
                                      ...project,
                                      programme: {
                                        id: project.programme,
                                        name: matchedProgramme.name
                                      }
                                    };
                                  }
                              
                                  // If no matching programme is found, return the project as is
                                  return project;
                                });
                              };
                               
                              // Use the function to extend the dependsOn property
                              const allProj = updateProjectProgrammes(responses[7].allProject, responses[7].programmes);
 
                let jsonDataProjects=generateProjects(allProj, refMap, plusIdType);
               
                dataRows.sheets.push(
                    {  "id":"projects",
                        "name": "Projects",
                        "description": "list of Projects",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [
                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                            {"name": "ID", "width": 20},
                            {"name": "Name", "width": 40},
                            {"name": "Description", "width": 60},
                            {"name": "Start Date", "width": 20},
                            {"name": "End Date", "width": 20},
                            {"name": "Lifecycle", "width": 20},
                            {"name": "Parent Programme", "width": 40}
                        ],
                        "visible": true,
                        "data": jsonDataProjects,  
                        "lookup": [{"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Project Lifecycles"},
                            {"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Programmes"}] 
                    }) 

                
                   // Function to combine and group `p2e` items by `eletype`
                   const groupP2EByEletype = (projects) => {
                    // Combine all p2e items from all projects, adding the project name
                    const combinedP2EItems = projects.flatMap(project => 
                      (project.p2e || []).map(p2eItem => ({
                        ...p2eItem, 
                        projectName: project.name // Add the project name to each p2e item
                      }))
                    );
                  
                    // Group by eletype
                    return combinedP2EItems.reduce((acc, p2eItem) => {
                      // Get the eletype of the current p2e item
                      const eletype = p2eItem.eletype || 'Unknown';
                  
                      // Initialize the group if not present
                      if (!acc[eletype]) {
                        acc[eletype] = [];
                      }
                  
                      // Add the current p2e item to the appropriate group
                      acc[eletype].push(p2eItem);
                  
                      return acc;
                    }, {});
                  };

                      let allp2e = groupP2EByEletype(allProj)

                const compsApplications = allp2e["Composite Application Provider"] || [];;
                const applications = allp2e["Application Provider"] || [];;

                const combinedApplications = [...compsApplications, ...applications];
 
                let jsonDataAppActions=generatePlanningActions(combinedApplications, refMap, plusIdType);
       
                dataRows.sheets.push(
                    {  "id":"appPlanningActions",
                        "name": "App Planning Actions",
                        "description": "list of Application Planning Actions",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [
                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                            {"name": "Strategic Plan", "width": 40},
                            {"name": "Impacted Application", "width": 40},
                            {"name": "Planned Change", "width": 20},
                            {"name": "Change Rationale", "width": 30},
                            {"name": "Implementing Project", "width": 40}
                        ],
                        "visible": true,
                        "data": jsonDataAppActions,  
                        "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                            {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
                            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Planning Actions"},
                            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Projects"}
                        ] 
                    }) 

                   
                    const appSvc = allp2e["Application Service"] || [];;
 
                    let jsonDataAppActionsSvc=generatePlanningActions(appSvc, refMap, plusIdType);
           
                    dataRows.sheets.push(
                        {  "id":"appSvcPlanningActions",
                            "name": "App Svc Planning Actions",
                            "description": "list of Application Service Planning Actions",
                            "notes": "",
                            "headerRow": 7,
                            "headers": [
                                {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                {"name": "Strategic Plan", "width": 40},
                                {"name": "Impacted Application Service", "width": 40},
                                {"name": "Planned Change", "width": 20},
                                {"name": "Change Rationale", "width": 30},
                                {"name": "Implementing Project", "width": 40}
                            ],
                            "visible": true,
                            "data": jsonDataAppActionsSvc,  
                            "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Application Services"},
                                {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Planning Actions"},
                                {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Projects"}] 
                        }) 

                        const busCap = allp2e["Business Capability"] || [];;
 
                    let jsonDataBCActionsc=generatePlanningActions(busCap, refMap, plusIdType);
           
                    dataRows.sheets.push(
                        {  "id":"bcPlanningActions",
                            "name": "Bus Cap Planning Actions",
                            "description": "list of Business Capability Planning Actions",
                            "notes": "",
                            "headerRow": 7,
                            "headers": [
                                {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                {"name": "Strategic Plan", "width": 40},
                                {"name": "Impacted Business Capability", "width": 40},
                                {"name": "Planned Change", "width": 20},
                                {"name": "Change Rationale", "width": 30},
                                {"name": "Implementing Project", "width": 40}
                            ],
                            "visible": true,
                            "data": jsonDataBCActionsc,  
                            "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Capabilities"},
                                {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Planning Actions"},
                                {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Projects"}] 
                        }) 


                        const busProc = allp2e["Business Process"] || [];;
 
                        let jsonDataBPActions=generatePlanningActions(busProc, refMap, plusIdType);
               
                        dataRows.sheets.push(
                            {  "id":"bpPlanningActions",
                                "name": "Bus Proc Planning Actions",
                                "description": "list of Business Process Planning Actions",
                                "notes": "",
                                "headerRow": 7,
                                "headers": [
                                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                    {"name": "Strategic Plan", "width": 40},
                                    {"name": "Impacted Business Process", "width": 40},
                                    {"name": "Planned Change", "width": 20},
                                    {"name": "Change Rationale", "width": 30},
                                    {"name": "Implementing Project", "width": 40}
                                ],
                                "visible": true,
                                "data": jsonDataBPActions,  
                                "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                    {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Business Processes"},
                                    {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Planning Actions"},
                                    {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Projects"}] 
                            }) 

                            const org = allp2e["Group Actor"] || [];;
 
                        let jsonDataOrgActions=generatePlanningActions(org, refMap, plusIdType);
               
                        dataRows.sheets.push(
                            {  "id":"orgPlanningActions",
                                "name": "Org Planning Actions",
                                "description": "list of Organisation Planning Actions",
                                "notes": "",
                                "headerRow": 7,
                                "headers": [
                                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                    {"name": "Strategic Plan", "width": 40},
                                    {"name": "Impacted Organisation", "width": 40},
                                    {"name": "Planned Change", "width": 20},
                                    {"name": "Change Rationale", "width": 30},
                                    {"name": "Implementing Project", "width": 40}
                                ],
                                "visible": true,
                                "data": jsonDataOrgActions,  
                                "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                    {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Organisation"},
                                    {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Planning Actions"},
                                    {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Projects"}] 
                            }) 

                            const techComp = allp2e["Technology Component"] || [];;
 
                            let jsonDataTCActions=generatePlanningActions(techComp, refMap, plusIdType);
                   
                            dataRows.sheets.push(
                                {  "id":"tcPlanningActions",
                                    "name": "Tech Comp Planning Actions",
                                    "description": "list of Technology Component Planning Actions",
                                    "notes": "",
                                    "headerRow": 7,
                                    "headers": [
                                        {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                        {"name": "Strategic Plan", "width": 40},
                                        {"name": "Impacted Technology Component", "width": 40},
                                        {"name": "Planned Change", "width": 20},
                                        {"name": "Change Rationale", "width": 30},
                                        {"name": "Implementing Project", "width": 40}
                                    ],
                                    "visible": true,
                                    "data": jsonDataTCActions,  
                                    "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                        {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Tech Components"},
                                        {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Planning Actions"},
                                        {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Projects"}] 
                                })     
                            
                                const techProd = allp2e["Technology Product"] || [];;
 
                                let jsonDataTPActions=generatePlanningActions(techComp, refMap, plusIdType);
                       
                                dataRows.sheets.push(
                                    {  "id":"tpPlanningActions",
                                        "name": "Tech Prod Planning Actions",
                                        "description": "list of Technology Product Planning Actions",
                                        "notes": "",
                                        "headerRow": 7,
                                        "headers": [
                                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                            {"name": "Strategic Plan", "width": 40},
                                            {"name": "Impacted Technology Product", "width": 40},
                                            {"name": "Planned Change", "width": 20},
                                            {"name": "Change Rationale", "width": 30},
                                            {"name": "Implementing Project", "width": 40}
                                        ],
                                        "visible": true,
                                        "data": jsonDataTPActions,  
                                        "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Strat Plan List"},
                                            {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Tech Products"},
                                            {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Planning Actions"},
                                            {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Projects"}] 
                                    })  
                                     
                    createPlusWorkbookFromJSON()
    });

    /* Final JSON structure
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
    */  
     
    });

    $('#exportControlFramework').on('click', function(){
        dataRows = {"sheets": []}; 
        Promise.all([
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataInfoRep) 
			]).then(function(responses) {
            
        let headers = [
            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
            {"name": "ID", "width": 20},
            {"name": "Name", "width": 40},
            {"name": "Description", "width": 40}
        ]

 /*
        dataRows.sheets.push(
            {  "id":"controlAssess",
                "name": "Control Assessment Framework",
                "description": "Controls for the framework",
                "notes": "",
                "headerRow": 7,
                "headers": [
                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                    {"name": "ID", "width": 20},
                    {"name": "Control Name", "width": 30}, 
                    {"name": "Description", "width": 60},
                    {"name": "Framework", "width": 30},
                    {"name": "Managing Process", "width": 40},
                    {"name": "Managing Process Owner", "width": 40},
                    {"name": "External Reference Link Name", "width": 30},
                    {"name": "External Reference Link URL", "width": 30},
                    {"name": "Assessor", "width": 40},
                    {"name": "Assessment Date", "width": 20},
                    {"name": "Outcome", "width": 30},
                    {"name": "Comments", "width": 60}
                ],	 				
                "visible": true,
                "data": ???,  
                "lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Roadmaps"}]  
            })  

            dataRows.sheets.push(
                {  "id":"controlAssess",
                    "name": "Control Assessment Framework",
                    "description": "Controls for the framework",
                    "notes": "",
                    "headerRow": 7,
                    "headers": [
                        {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                        {"name": "Control ID", "width": 20},
                        {"name": "Control Name", "width": 30}, 
                        {"name": "Assessed Business Process", "width": 60},
                        {"name": "Assessed Composite Application Provider", "width": 30},
                        {"name": "Assessed Application Provider Interface", "width": 40},
                        {"name": "Assessed Technology Product", "width": 40},
                        {"name": "Assessor", "width": 30},
                        {"name": "External Reference Link URL", "width": 30},
                        {"name": "Assessor", "width": 40},
                        {"name": "Assessment Date", "width": 20},
                        {"name": "Outcome", "width": 30},
                        {"name": "Comments", "width": 60},
                        {"name": "Description", "width": 60}     
                    ],	 				
                    "visible": true,
                    "data": ???,  
                    "lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Roadmaps"}]  
                })  
*/

        })

    })
 
  $('#exportStratPlanner').on('click', function(){
     dataRows = {"sheets": []}; 
        Promise.all([
			promise_loadViewerAPIData(viewAPIPathStratPlanner) 
			]).then(function(responses) {
      

             //   Products, CEX Ratings, Cust Emotions, Cust SQ, Ciust SQVs, Value MediaStreamAudioSourceNode, value Stages
            
        let headers = [
            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
            {"name": "ID", "width": 20},
            {"name": "Name", "width": 40},
            {"name": "Description", "width": 40}
        ]

    
       // Assuming responses[0].physProcesses and physProcesses are arrays with objects containing an ID field
physProcesses.forEach((process) => {
    // Find the matching object in responses[0].physProcesses by ID
    let matchingResponseProcess = responses[0].physProcesses.find((responseProcess) => responseProcess.id === process.id);
 
    // If a match is found, merge the objects (you can specify how to merge)
    if (matchingResponseProcess) {
        process['busProcessName']=matchingResponseProcess.busProcessName
        process['orgName']=matchingResponseProcess.orgName
    } else {
        // If no match is found, push the process into responses[0].physProcesses
        responses[0].physProcesses.push(process);
    }
});
physProcesses= physProcesses.filter((p)=>{
    return p.orgName;
})
        let jsonDataPhysProc=generatePlanPhysProcesses(physProcesses); 
        dataRows.sheets.push(
            {  "id":"physPro",
                "name": "Physical Processes",
                "description": "Physical Processes",
                "notes": "IMPORTANT: You MUST delete the cells E or F before loading.  If Org role is populated then delete column F, otherwise delete column E",
                "headerRow": 7,
                "headers": [  // If this first column is always empty or has a specific purpose, define it accordingly
                    {"name": "", "width": 20}, 
                    {"name": "Business Process", "width": 20},
                    {"name": "Organisation", "width": 30}, 
                    {"name": "Organisational Role", "width": 60}
                ],	 				
                "visible": true,
                "data": jsonDataPhysProc,  
                "lookup": [],
                "concatenate": [
                    {
                        column: "E",
                        type: "=CONCATENATE",
                        formula: 'C, " as ", D, " performing ", B',
                      },
                      {
                    column: "F",
                    type: "=CONCATENATE",
                    formula: 'C, " performing ", B',
                  },
                  {
                    column: "G",
                    type: "=CONCATENATE",
                    formula: 'E, F',
                  }    ]    
            })  

            let jsonProducts=generateStandardTemplate(allProducts);
            
            dataRows.sheets.push(
                {  "id":"products",
                    "name": "Products",
                    "description": "Product List",
                    "notes": "",
                    "headerRow": 7,
                    "headers": headers,	 				
                    "visible": true,
                    "data": jsonProducts,  
                    "lookup": []  
                })  

                let jsonCustEx=generateEnums(custEx);
                
                let jsonCustEmotion=generateEnums(custEmotions);
     
                dataRows.sheets.push(
                    {  "id":"custexRatings",
                        "name": "Customer Experience Ratings",
                        "description": "Set Customer Experience Ratings",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [
                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                            {"name": "ID", "width": 20},
                            {"name": "Experience Rating", "width": 30}, 
                            {"name": "Description", "width": 60}, 
                            {"name": "Colour", "width": 15}, 
                            {"name": "Style Class", "width": 20}, 
                            {"name": "Index", "width": 15}, 
                            {"name": "Score", "width": 15}
                        ],	 				
                        "visible": true,
                        "data": jsonCustEx,  
                        "lookup": []
                    })  

                dataRows.sheets.push(
                    {  "id":"custemRatings",
                        "name": "Customer Emotion Ratings",
                        "description": "Set Customer Emotion Ratings",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [
                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                            {"name": "ID", "width": 20},
                            {"name": "Experience Rating", "width": 30}, 
                            {"name": "Description", "width": 60}
                        ],	 				
                        "visible": true,
                        "data": jsonCustEmotion,  
                        "lookup": []  
                    })
 
                    let svqJson = generateSvcQuals(custServiceQual) 
                    let svqvalsJson = generateSvcQualsVals(custServiceQualVal) 

                dataRows.sheets.push(
                    {  "id":"custservquals",
                        "name": "Customer Service Qualities",
                        "description": "Set Customer Service Qualities",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [
                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                            {"name": "ID", "width": 20},
                            {"name": "Service Quality", "width": 30}, 
                            {"name": "Value", "width": 20}, 
                            {"name": "Description", "width": 60},  
                            {"name": "Colour", "width": 20},
                            {"name": "Description Translation", "width": 20},
                            {"name": "Language", "width": 20}
                        ],	 				
                        "visible": true,
                        "data": svqJson,  
                        "lookup": [],
                        "concatenate": {
                          column: "I",
                          type: "=CONCATENATE",
                          formula: 'C, " - ", D',
                        }  
                    })

                dataRows.sheets.push(
                    {  "id":"custSQV",
                        "name": "Customer Service Quality Values",
                        "description": "Set Customer Experience Ratings",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [
                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                            {"name": "ID", "width": 20},
                            {"name": "Service Quality", "width": 30}, 
                            {"name": "Value", "width": 20}, 
                            {"name": "Description", "width": 60},
                            {"name": "Colour", "width": 20}, 
                            {"name": "Style Class", "width": 20},  
                            {"name": "Score", "width": 10},
                            {"name": "Name Translation", "width": 60},
                            {"name": "Description Translation", "width": 60},
                            {"name": "Language", "width": 60}
                        ],	 				
                        "visible": true,
                        "data": svqvalsJson,  
                        "lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Customer Service Qualities"}]  
                    })

                    let jsonValStreams=generateStandardTemplate(responses[0].valueStreams)

                dataRows.sheets.push(
                    {  "id":"valueStreams",
                        "name": "Value Streams",
                        "description": "Value Stream List",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [
                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                            {"name": "ID", "width": 20},  
                            {"name": "Name", "width": 40},
                            {"name": "Description", "width": 60} 
                        ],	 				
                        "visible": true,
                        "data": jsonValStreams,  
                        "lookup": [
                        ]  
                    })

                    let jsonValStage=generateStageTemplate(responses[0].valueStages)
                      
                    dataRows.sheets.push(
                        {  "id":"valueStreams",
                            "name": "Value Stages",
                            "description": "Value Stage List",
                            "notes": "",
                            "headerRow": 7,
                            "headers": [
                                {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                {"name": "ID", "width": 20},
                                {"name": "Value Stream", "width": 30},
                                {"name": "Index", "width": 20},
                                {"name": "Stage Name", "width": 40},
                                {"name": "Description", "width": 60}
                            ],	 				
                            "visible": true,
                            "data": jsonValStage,  
                            "lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Value Streams"}],
                            "concatenate": {
                              column: "G",
                              type: "=CONCATENATE",
                              formula: 'C, ":", D, ". ", E',
                            },
                             
                        })

                        let jsonCustJourney=generateCJTemplate(custJourney)
                      
                        dataRows.sheets.push(
                            {  "id":"custjourneys",
                                "name": "Customer Journeys",
                                "description": "Customer Journey List",
                                "notes": "",
                                "headerRow": 7,
                                "headers": [
                                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                    {"name": "ID", "width": 20},
                                    {"name": "Name", "width": 30},
                                    {"name": "Description", "width": 60},
                                    {"name": "Product", "width": 40}
                                ],	 				
                                "visible": true,
                                "data": jsonCustJourney,  
                                "lookup": [{"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Products"}] 
                            })       
                            
                        let jsonCustJourneyPhases=generateCJPTemplate(custJourneyPhase)
                        
                            dataRows.sheets.push(
                                {  "id":"custjourneyphases",
                                    "name": "Customer Journey Phases",
                                    "description": "Customer Journey Phase List",
                                    "notes": "",
                                    "headerRow": 7,
                                    "headers": [
                                        {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                        {"name": "ID", "width": 20},
                                        {"name": "Customer Journey", "width": 30},
                                        {"name": "Index", "width": 10},
                                        {"name": "Phase Name", "width": 30},
                                        {"name": "Description", "width": 60},
                                        {"name": "Customer Experience", "width": 40}
                                    ],	 				
                                    "visible": true,
                                    "data": jsonCustJourneyPhases,  
                                    "lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Customer Journeys"},
                                        {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Customer Experience Rating"}
                                    ],
                                    "concatenate": {
                                    column: "H",
                                    type: "=CONCATENATE",
                                    formula: 'C, ":", D, ". ", E',
                                    }, 
                                })     

                                let mappedCjptoVs=[];
                                responses[0].valueStages.forEach((vs)=>{
                                    vs.customerJourneyPhaseIds.forEach((cj)=>{
                                        let phase = custJourneyPhase.find((p)=>{
                                            return p.id==cj
                                        })
                                        mappedCjptoVs.push({cjp: phase.name, vs: vs.name})

                                    })
                                }) 
                                let jsonCJPtoVS=generateCJPtoVSTemplate(mappedCjptoVs)
                        
                                dataRows.sheets.push(
                                    {  "id":"cjptovs",
                                        "name": "CJPs to Value Stages",
                                        "description": "Customer Journey Phase mapped to Value Stages",
                                        "notes": "",
                                        "headerRow": 7,
                                        "headers": [
                                            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                            {"name": "Customer Journey Phase", "width": 40},
                                            {"name": "Value Stage", "width": 40}
                                        ],	 				
                                        "visible": true,
                                        "data": jsonCJPtoVS,  
                                        "lookup": [{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Customer Journey Phases"},
                                            {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Value Stages"}
                                        ] 
                                    })   

                                    let mappedCjptoPhysProc=[];
                                    let bsqvs=[]
                                    let emot=[]

                                    custJourneyPhase.forEach((cjp)=>{
                                        cjp.emotions.forEach((e)=>{
                                            emot.push({cjp:cjp.name, emot:e.name})
                                        })
                                        cjp.physProcs.forEach((pp)=>{
                                            mappedCjptoPhysProc.push({cjp: cjp.name, pp: pp.name})
                                        })
                                        cjp.bsqvs.forEach((sqv)=>{
                                            bsqvs.push({cjp: cjp.name, sqv: sqv.name})
                                        })
                                    }) 
 
                                let jsonCJPtoPhysProc=generateCJPtoPPTemplate(mappedCjptoPhysProc)
                         
                                    dataRows.sheets.push(
                                        {  "id":"cjptopp",
                                            "name": "CJPs to Physical Process",
                                            "description": "Customer Journey Phase mapped to Physical Processes",
                                            "notes": "",
                                            "headerRow": 7,
                                            "headers": [
                                                {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                                {"name": "Customer Journey Phase", "width": 40},
                                                {"name": "Physical Process", "width": 40}
                                            ],	 				
                                            "visible": true,
                                            "data": jsonCJPtoPhysProc,  
                                            "lookup": [{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Customer Journey Phases"},
                                                {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Physical Processes"}
                                            ] 
                                        }) 
 
                                    let jsonCJPtoBSQV=generateCJPtoSQV(bsqvs)
                                        dataRows.sheets.push(
                                            {  "id":"cjptobsqv",
                                                "name": "CJPs to Service Quality Values",
                                                "description": "Customer Journey Phase mapped to Business Service Quality Values",
                                                "notes": "",
                                                "headerRow": 7,
                                                "headers": [
                                                    {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
                                                    {"name": "Customer Journey Phase", "width": 40},
                                                    {"name": "Service Quality Value", "width": 40}
                                                ],	 				
                                                "visible": true,
                                                "data": jsonCJPtoBSQV,  
                                                "lookup": [{"column": "H", "values":"C", "start": 8, "end": 2011, "worksheet": "Customer Journey Phases"},
                                                    {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Physical Processes"}
                                                ],
                                                 
                                            })         
            createPlusWorkbookFromJSON()
    })

    });

    $('#exportTechRef').on('click', function(){
      dataRows = {"sheets": []}; 
      Promise.all([
          promise_loadViewerAPIData(viewAPIDataApps),
          promise_loadViewerAPIData(viewAPIDataTechComp),
          promise_loadViewerAPIData(viewAPIDataTechProd),
          promise_loadViewerAPIData(viewAPIPathApptoTech) 
        ]).then(function(responses) {

          let headers = [
            {"name": "", "width": 20},  // If this first column is always empty or has a specific purpose, define it accordingly
            {"name": "ID", "width": 20},
            {"name": "Name", "width": 40}
        ];
          let jsonDataApp=generateStandardTemplateInternalId(responses[0].applications);
                
                dataRows.sheets.push(
                    {  "id":"Applications",
                        "name": "Applications",
                        "description": "list of Applications",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": true,
                        "data": jsonDataApp,  
                        "lookup": [] 
                    })
                
                   let jsonDataTC=generateStandardTemplateInternalId(responses[1].technology_components);
                
                dataRows.sheets.push(
                    {  "id":"techComponents",
                        "name": "Technology Components",
                        "description": "list of Technology Components",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": true,
                        "data": jsonDataTC,  
                        "lookup": [] 
                    })
           
                    let jsonDataTP=generateStandardTemplateInternalId(responses[2].technology_products);
                
                dataRows.sheets.push(
                    {  "id":"techProducts",
                        "name": "Technology Products",
                        "description": "list of Technology Products",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": headers,
                        "visible": true,
                        "data": jsonDataTP,  
                        "lookup": [] 
                    })

                    let jsonDataTechComposite=generateStandardTemplateInternalId(techComposites);
                
                    dataRows.sheets.push(
                        {  "id":"techrefarch",
                            "name": "Technology Reference Archs",
                            "description": "list of Technology Reference Architectures",
                            "notes": " ",
                            "headerRow": 7,
                            "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 40},{"name": "Description", "width": 40}],
                            "visible": true,
                            "data": jsonDataTechComposite,  
                            "lookup": [] 
                        })

                        let jsonDataTechCompositeSQs=generateCompositeSQs(techComposites);

                      dataRows.sheets.push(
                        {  "id":"techrefarchsqs",
                            "name": "Tech Ref Arch Svc Quals",
                            "description": "list of Technology Reference Architecture Service Qualities",
                            "notes": " ",
                            "headerRow": 7,
                            "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Reference Architecture", "width": 40},{"name": "Service Quality Value", "width": 40}],
                            "visible": true,
                            "data": jsonDataTechCompositeSQs,  
                            "lookup": [{"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Reference Archs"},
                              {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "TSQV Lookup"}
                            ] 
                        })   

                        let tras=[]
                        techComposites.forEach((tc)=>{
                          tc.tcus.forEach((t)=>{
                            let match=responses[1].technology_components.find((a)=>{
                              return a.id == t.from_technology_component
                            })
                            t['component_name']= match.name;
                            t.dependsOn.forEach((d)=>{
                              let match=responses[1].technology_components.find((a)=>{
                                return a.id == d.to
                              })
                              d['component_name']= match.name;
                              tras.push({"name": tc.name, "from": match.name, "to":t.component_name})
                            })
                            
                          })
                        })
                      
                        dataRows.sheets.push(
                          {  "id":"techrefmodels",
                              "name": "Tech Reference Models",
                              "description": "list of Technology Reference Models",
                              "notes": " ",
                              "headerRow": 7,
                              "headers": [{"name": "", "width": 20}, {"name": "Reference Architecture", "width": 20},{"name": "From Technology Component", "width": 40},{"name": "To Technology Component", "width": 40}],		
                              "visible": true,
                              "data": tras,  
                              "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Reference Archs"},
                                {"column": "C", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Components"},
                                {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Components"}] 
                          })   

                          
                      let apptech=[]
                      responses[3].application_technology_architecture.forEach((d)=>{

                        d.supportingTech.forEach((t)=>{
                          if(t.environmentName){
                           apptech.push({"name":d.application,"env":t.environmentName,"fromTech":t.fromTechProduct, "fromComp":t.fromTechComponent, "toTech":t.toTechProduct, "toComp":t.toTechComponent})
                          }
                        })
                      
                      })

                      dataRows.sheets.push(
                        {  "id":"apptotechprods",
                            "name": "App to Tech Products",
                            "description": "Application to Technology Mapping",
                            "notes": " ",
                            "headerRow": 7,
                            "headers": [{"name": "", "width": 20}, {"name": "Application", "width": 20},{"name": "Environment", "width": 40},{"name": "From Technology Product", "width": 40},{"name": "From Technology Component", "width": 40},{"name": "To Technology Product", "width": 40},{"name": "To Technology Component", "width": 40}],		
                            "visible": true,
                            "data": apptech,  
                            "lookup": [{"column": "B", "values":"C", "start": 8, "end": 2011, "worksheet": "Applications"},
                              {"column": "D", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Products"},
                              {"column": "E", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Components"},
                              {"column": "F", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Products"},
                              {"column": "G", "values":"C", "start": 8, "end": 2011, "worksheet": "Technology Components"}] 
                        })   
                         
 
                        let jsonDataSQVs=generateStandardTemplateInternalId(sqvs);
                
                        dataRows.sheets.push(
                            {  "id":"sqvLookup",
                                "name": "TSQV Lookup",
                                "description": "list of Tech Serv Quals",
                                "notes": " ",
                                "headerRow": 7,
                                "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 40}],
                                "visible": true,
                                "data": jsonDataSQVs,  
                                "lookup": [] 
                            })
 
                  createPlusWorkbookFromJSON()
        })
      })

        $('#exportTechnologyLifecycles').on('click', function(){
          console.log('clikc')
          dataRows = {"sheets": []}; 
          Promise.all([
              promise_loadViewerAPIData(viewAPIPathTechLife)
            ]).then(function(responses) {
  
              let vendorData=[];
              let internalData=[];
              let interalLifes=responses[0].lifecycleJSON.filter((t)=>{
                return t.type=='Lifecycle_Status'
              })
              let vendorLifes=responses[0].lifecycleJSON.filter((t)=>{
                return t.type=='Vendor_Lifecycle_Status'
              })

              responses[0].technology_lifecycles.forEach((d)=>{
                d['beta']=d.allDates.find((e)=>{
                  return e.name=='Beta'
                }) || "";
                d['ga']=d.allDates.find((e)=>{
                  return e.name=='General Availability'
                }) || "";
                d['es']=d.allDates.find((e)=>{
                  return e.name=='Extended Support'
                }) || "";
                d['eol']=d.allDates.find((e)=>{
                  return e.name=='End of Life'
                }) || "";
                vendorData.push({"vendor":d.supplier, "product":d.name,"beta": d.beta.dateOf !== undefined ? d.beta.dateOf : "", "ga": d.ga.dateOf !== undefined ? d.ga.dateOf : "",  "es": d.es.dateOf !== undefined ? d.es.dateOf : "",  "eol": d.eol.dateOf !== undefined ? d.eol.dateOf : "" })
                let internal=d.allDates.filter((e)=>{
                    return e.type =='Lifecycle_Status';
                });
                internal.forEach((f)=>{
                  internalData.push({"vendor":d.supplier, "product":d.name, "status": f.name, "date":f.dateOf})
                })
                
              })

              let lf=[]
              let ef=[]
              interalLifes.forEach((l)=>{
                lf.push({"id": l.id, "name":l.name , "desc":l.description !== undefined ? l.description : "" , "label": l.enumeration_value !== undefined ? l.enumeration_value : "", "seq":l.seq , "colour":l.backgroundColour })
              })
              vendorLifes.forEach((l)=>{
                ef.push({"id": l.id, "name":l.name , "colour":l.backgroundColour })
              })

                  dataRows.sheets.push(
                    {  "id":"techprodinterallifecycle",
                        "name": "Tech Prod Internal Lifeycle",
                        "description": "list of Technology Product Internal Lifecycles",
                        "notes": "",
                        "headerRow": 7,
                        "headers": [{"name": "", "width": 20}, {"name": "Supplier", "width": 20},{"name": "Product", "width": 20},{"name": "Internal Lifecycle Status", "width": 20},{"name": "From Date", "width": 20},],
                        "visible": true,
                        "data": internalData,  
                        "lookup": [] 
                    })

                    dataRows.sheets.push(
                      {  "id":"internalColours",
                          "name": "Internal Tech Prod Lifecycles ",
                          "description": "list of Internal Lifecycles",
                          "notes": "These will apply to any instance using the lifecycle class",
                          "headerRow": 7,
                          "headers": [{"name": "", "width": 20}, {"name": "Supplier", "width": 20},{"name": "Product", "width": 20},{"name": "Beta Start", "width": 20},{"name": "GA Start", "width": 20},{"name": "Extended Support Start", "width": 20},{"name": "EOL Start", "width": 20}],
                          "visible": true,
                          "data": vendorData,  
                          "lookup": [] 
                      })

                      dataRows.sheets.push(
                        {  "id":"techprodlifecycle",
                            "name": "Tech Prod Vendor Lifecycle",
                            "description": "list of Technology Product Vendor Lifecycles",
                            "notes": "You MUST use the English terms for mapping here",
                            "headerRow": 7,
                            "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 30},{"name": "Description", "width": 40},{"name": "Label", "width": 20},{"name": "Sequence No", "width": 20},{"name": "Colour", "width": 20}],
                            "visible": true,
                            "data": lf,  
                            "lookup": [] 
                        })

                      dataRows.sheets.push(
                        {  "id":"vendorColours",
                            "name": "Ref",
                            "description": "list of Vendor Lifecycles",
                            "notes": "DO NOT CHANGE THE NAMES OR SEQUENCE HERE",
                            "headerRow": 7,
                            "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Colour", "width": 20}],
                            "visible": true,
                            "data": ef,  
                            "lookup": [] 
                        })
                console.log('dataRows',dataRows)
 
                createPlusWorkbookFromJSON()
 
            })

          })

          $('#exportSupplierContractManagement').on('click', function(){
            console.log('exportSupplierContractManagement')
            dataRows = {"sheets": []}; 
            Promise.all([
                promise_loadViewerAPIData(viewAPIPathSupplierImpact),
                promise_loadViewerAPIData(viewAPIDataBusProcs),
                promise_loadViewerAPIData(viewAPIDataApps),
                promise_loadViewerAPIData(viewAPIDataTechProd),
                promise_loadViewerAPIData(viewAPIDataOrgs)
              ]).then(function(responses) {
 
               let owners=generateStandardTemplateInternalId(responses[4].organisations, refMap, plusIdType);
                dataRows.sheets.push(
                  {  "id":"contractOwner",
                      "name": "REF Orgs - Contract Owner",
                      "description": "list of Contract Owner",
                      "notes": " ",
                      "headerRow": 7,
                      "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Descripton", "width": 40}],
                      "visible": true,
                      "data": owners,  
                      "lookup": [] 
                  })
              let process=generateStandardTemplateInternalId(responses[1].businessProcesses, refMap, plusIdType);
                  dataRows.sheets.push(
                    {  "id":"contractbusinessProcesses",
                        "name": "REF Business Processes",
                        "description": "list of Business Processes",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Descripton", "width": 40}],
                        "visible": true,
                        "data": process,  
                        "lookup": [] 
                    })
                let apps=generateStandardTemplateInternalId(responses[2].applications, refMap, plusIdType);
                dataRows.sheets.push(
                  {  "id":"contractApplications",
                      "name": "REF Applications",
                      "description": "list of Applications",
                      "notes": " ",
                      "headerRow": 7,
                      "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Descripton", "width": 40}],
                      "visible": true,
                      "data": apps,  
                      "lookup": [] 
                  })
                  let tps=generateTPSTemplate(responses[3].technology_products, refMap, plusIdType);
                  dataRows.sheets.push(
                    {  "id":"contractTechnologyProductsr",
                        "name": "REF Technology Products",
                        "description": "list of Technology Products",
                        "notes": " ",
                        "headerRow": 7,
                        "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Supplier", "width": 30}, {"name": "Descripton", "width": 40}],
                        "visible": true,
                        "data": tps,  
                        "lookup": [] 
                    })

                    //Contract_Type
                    let conTypes=responses[0].enums.filter((e)=>{return e.type=='Contract_Type'})
                  let contype=generateContractTypeTemplate(conTypes, refMap, plusIdType);  

                          dataRows.sheets.push(
                            {  "id":"contractTypes",
                                "name": "Contract Types",
                                "description": "list of Contract Types",
                                "notes": " ",
                                "headerRow": 7,
                                "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Description", "width": 30}, {"name": "Sequence No", "width": 40},{"name": "Colour", "width": 30}, {"name": "Style Class", "width": 40}, {"name": "Custom Label", "width": 40}],
                                "visible": true,
                                "data": contype,  
                                "lookup": [] 
                            })

                    let renTypes=responses[0].enums.filter((e)=>{return e.type=='Contract_Renewal_Model'})
                    let rentype=generateContractType2Template(renTypes, refMap, plusIdType);  
     
                            dataRows.sheets.push(
                              {  "id":"renewalTypes",
                                  "name": "Renewal Types",
                                  "description": "list of Renewal Types",
                                  "notes": " ",
                                  "headerRow": 7,
                                  "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Description", "width": 30}, {"name": "Sequence No", "width": 40},{"name": "Colour", "width": 30}, {"name": "Style Class", "width": 40}],
                                  "visible": true,
                                  "data": rentype,  
                                  "lookup": [] 
                              })    
                    
                    let unitTypes=responses[0].enums.filter((e)=>{return e.type=='License_Model'})          
                    let unittype=generateContractType2Template(responses[0].enums, refMap, plusIdType);  
     
                              dataRows.sheets.push(
                                {  "id":"unitTypes",
                                    "name": "Unit Types",
                                    "description": "list of Unit Types",
                                    "notes": " ",
                                    "headerRow": 7,
                                    "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Description", "width": 30}, {"name": "Sequence No", "width": 40},{"name": "Colour", "width": 30}, {"name": "Style Class", "width": 40}],
                                    "visible": true,
                                    "data": unittype,  
                                    "lookup": [] 
                                })    
                                
                    let supplierList=generateSupplierTemplate(responses[0].suppliers, refMap, plusIdType); 
                                dataRows.sheets.push(
                                  {  "id":"suppliers",
                                      "name": "Suppliers",
                                      "description": "list of Suppliers",
                                      "notes": " ",
                                      "headerRow": 7,
                                      "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Name", "width": 20},{"name": "Description", "width": 30}, {"name": "Relationship Status", "width": 40},{"name": "Website Link", "width": 30}, {"name": "External", "width": 40}],
                                      "visible": true,
                                      "data": supplierList,  
                                      "lookup": [] 
                                  })          
                                  
                              
                     let contractList=generateContractTemplate(responses[0].contracts, refMap, plusIdType); 
                            
                                  dataRows.sheets.push(
                                    {  "id":"contracts",
                                        "name": "Contracts",
                                        "description": "list of Contracts",
                                        "notes": " ",
                                        "headerRow": 7,
                                        "headers": [{"name": "", "width": 20}, {"name": "ID", "width": 20},{"name": "Supplier or Reseller", "width": 30},{"name": "Contract Name", "width": 30}, {"name": "Contract Owner", "width": 30}, {"name": "Service Description", "width": 40}, {"name": "Signature Date (YYYY-MM-DD)", "width": 20}, {"name": "Renewal Type", "width": 20}, {"name": "Service End Date (YYYY-MM-DD)", "width": 20}, {"name": "Service Notice Period (days)", "width": 20}, {"name": "Document Link - URL", "width": 20}],
                                        "visible": true,
                                        "data": contractList,  
                                        "lookup": [] 
                                    })      
                  
                   console.log('dr', dataRows)
                   createPlusWorkbookFromJSON()
              })
            
            })
          $('#exportApplicationKPIs').on('click', function(){
            console.log('exportApplicationKPIs')
            dataRows = {"sheets": []}; 
            Promise.all([
                promise_loadViewerAPIData(viewAPIPathTechLife)
              ]).then(function(responses) {

            })
          })
         
            $('#exportBusinessModels').on('click', function(){
              console.log('exportBusinessModels')
              dataRows = {"sheets": []}; 
              Promise.all([
                  promise_loadViewerAPIData(viewAPIPathTechLife)
                ]).then(function(responses) {
  
              })
            })   

              $('#exportValueStreams').on('click', function(){
                console.log('exportValueStreams')
                dataRows = {"sheets": []}; 
                Promise.all([
                    promise_loadViewerAPIData(viewAPIPathTechLife)
                  ]).then(function(responses) {
    
                })
              })
            })

 