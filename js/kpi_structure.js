var allServiceQualities;

// Function to process KPIs
function processKPIs(kpis, pmType) {
    if (kpis && Array.isArray(kpis.perfCategory)) {
        kpis.perfCategory.forEach((q) => {
            let sqs = [];
            if (Array.isArray(q.qualities)) {
                q.qualities.forEach((sq) => {
                    let qual = kpis.serviceQualities.find((f) => f.id == sq);
                    if (qual) {
                        sqs.push(qual);
                    }
                });
            }
            q['sqs'] = sqs;
        });
    }

    let pmc = kpis?.perfCategory;
    let pms = kpis[pmType];
    if (Array.isArray(pms)) {
        pms.forEach((d) => {
          
            if (Array.isArray(d.perfMeasures) && d.perfMeasures.length > 0) {
               
                d.perfMeasures.forEach((e) => {
                    
                    if (e.categoryid == '' && e.serviceQuals && e.serviceQuals[0]) {
                        e.categoryid = e.serviceQuals[0].categoryId;
                    }
                });
                
            }
            if (Array.isArray(d.processPerfMeasures) && d.processPerfMeasures.length > 0) {
                d.processPerfMeasures.forEach((p) => {
                    if (Array.isArray(p.scores)) {
                        p.scores.forEach((e) => {
                            if (e.categoryid == '' && e.serviceQuals && e.serviceQuals[0]) {
                                e.categoryid = e.serviceQuals[0].categoryId;
                            }
                        });
                    }
                });
            }
        });
    }
}

// Ensure `filterPerformanceMeasuresByCategoryId` is defined before calling it
function filterPerformanceMeasuresByCategoryId(data, categoryId) {
    return data.map(item => {
        // Filter the performance measures
        const filteredPerfMeasures = item.perfMeasures.filter(measure => 
            measure.categoryid.includes(categoryId) || measure.categoryid == categoryId
        );
        
        // Return a new object with the filtered performance measures
        return {
            ...item,
            perfMeasures: filteredPerfMeasures
        };
    }).filter(item => item.perfMeasures.length > 0); // Filter out items with no performance measures
}

function createStructuredJSON(originalData) {
    // Initialize the result array
    const result = [];

    // Loop through each item in the original data
    originalData.forEach(item => {
        // Create a new object for each id
        const structuredItem = {
            id: item.id,
            name: item.name,
            dates: []
        };
        const today = new Date();
        // Loop through each performance measure
        const dateExists = item.perfMeasures.find(item => item.createdDate && item.createdDate.trim() !== "");
        item.perfMeasures.forEach(perfMeasure => { 
            // Create an array to hold the serviceQs for this month/year
            const serviceQs = [];
            
            // Loop through each service quality
            max=0;
       
            perfMeasure.serviceQuals.forEach(serviceQual => {
                    serviceQs.push({
                        name: serviceQual.serviceName,
                        id: serviceQual.id,
                        max: allServiceQualities.get(serviceQual.serviceId).maxScore,
                        service_quality_value: serviceQual.value,
                        service_quality_type: serviceQual.serviceId,
                        score: Number(serviceQual.score) // Convert score to a number
                    });
                });
                
            if(dateExists){
                // Initialize variables to track the closest past date
                let closestPastDate = null;
                let minDifference = Infinity;
            
                const timeDifference = today - new Date(perfMeasure.date);

                // If the date is in the past and is closer than the current closest date
                if (timeDifference > 0 && timeDifference < minDifference) {
                    closestPastDate = new Date(perfMeasure.date);
                    minDifference = timeDifference;
                        
                }

                // Add the month/year and its serviceQuals to the date array
                structuredItem.dates.push({
                    date: perfMeasure.date,
                    serviceQuals: serviceQs
                });

                structuredItem.dates.forEach(dateItem => {
                    
                    if(closestPastDate){
                        if (dateItem.date !='' && new Date(dateItem.date).getTime() === closestPastDate.getTime()) {
                            dateItem.isClosestPastDate = true;
                        }
                    }
                });
            }else{
                structuredItem.dates.push({
                    date: new Date(),
                    serviceQuals: serviceQs
                });
            }
        });

        // Add the structured item to the result array
        result.push(structuredItem);
    });

    return result;
}

function getPerfData(data, cat) {
    const filteredData = filterPerformanceMeasuresByCategoryId(data, cat);
    const structuredData = createStructuredJSON(filteredData);
    return structuredData;
}