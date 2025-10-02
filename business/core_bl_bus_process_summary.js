if (!Handlebars.helpers.some) {
    Handlebars.registerHelper('some', function (array, key) {
        return array && array.some(item => item[key]);
    });
}

if (!Handlebars.helpers.styles) {
    Handlebars.registerHelper('styles', function (value) {
        let match = styles?.find((a) => a.id == value);
        return match ? `background-color:${match.backgroundColour}; color:${match.textColour}` : '';
    });
}

Handlebars.registerHelper('getType', function(arg1, arg2, options) {
    if(arg1){

    return arg1.substring(0, arg1.indexOf("_"));
    }
});

Handlebars.registerHelper('formatDate', function(arg1) {
    return formatDateforLocale(arg1, currentLang)
})			


Handlebars.registerHelper('formatCurrency', function(arg1, arg2, options) {
    var formatter = new Intl.NumberFormat(undefined, {  });
    if(arg1){
    return formatter.format(arg1);
    }
});


if (!Handlebars.helpers.breaklines) {
    Handlebars.registerHelper('breaklines', function (html) {
        html = html.replace(/(\r<li&gt;)/gm, '<li&gt;').replace(/(\r)/gm, '<br/>');
        return new Handlebars.SafeString(html);
    });
}

if (!Handlebars.helpers.ifContains) {
    Handlebars.registerHelper('ifContains', function (arg1, arg2, options) {
        if (arg1.role.includes(arg2)) {
            return `<label>${arg1.role}</label><ul class="ess-list-tags"><li class="tagActor">${arg1.actor}</li></ul>`;
        }
    });
}

if (!Handlebars.helpers.ifEquals) {
    Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
        return arg1 == arg2 ? options.fn(this) : options.inverse(this);
    });
}

if (!Handlebars.helpers.ifNotEquals) {
  Handlebars.registerHelper('ifNotEquals', function (arg1, arg2, options) {
      return arg1 == arg2 ? options.fn(this) : options.inverse(this);
  });
}

/**
* Manage stakeholders Information
* 
* Separate group and invidual actors and group by actors
**/
function getIndivAndGroupActorsStakeholders(focusProcess) {
    let indivStakeholders = focusProcess.stakeholders?.filter((f) => { return f.type != 'Group_Actor' });
    focusProcess['orgStakeholders'] = focusProcess.stakeholders?.filter((f) => { return f.type == 'Group_Actor' });

    if(indivStakeholders){
        let indivStakeholdersList = d3.nest()
            .key(function (d) { return d.actor; })
            .entries(indivStakeholders);

        indivStakeholdersList?.forEach((d) => {
            let sid = focusProcess.stakeholders?.find((s) => {
                return s.actor == d.key
            })
            d['id'] = sid.actorId;
            d['name'] = d.key;
        });
        focusProcess['indivStakeholdersList'] = indivStakeholdersList;
    }
    if(focusProcess.orgStakeholders){
        let orgStakeholdersList = d3.nest()
            .key(function (d) { return d.actor; })
            .entries(focusProcess.orgStakeholders);

        orgStakeholdersList?.forEach((d) => {
            let sid = focusProcess.stakeholders.find((s) => {
                return s.actor == d.key
            })
            d['id'] = sid.actorId;
            d['name'] = d.key;
        })
        focusProcess['orgStakeholdersList'] = orgStakeholdersList;
    }
    return focusProcess;
}

function activateStakeholdersDataTable() {
    $('.dt_stakeholders tfoot th').each(function () {
        let stakeholdertitle = $(this).text();
        $(this).html('<input type="text" placeholder="Search ' + stakeholdertitle + '" />');
    });

    stakeholdertable = $('.dt_stakeholders').DataTable({
        scrollY: "350px",
        scrollCollapse: true,
        paging: false,
        info: false,
        sort: true,
        responsive: true,
        columns: [{ "width": "30%" }, { "width": "30%" }],
        dom: 'Bfrtip',
        buttons: ['copyHtml5', 'excelHtml5', 'csvHtml5', 'pdfHtml5', 'print']
    });

    stakeholdertable.columns().every(function () {
        var that = this;

        $('input', this.footer()).on('keyup change', function () {
            if (that.search() !== this.value) {
                that
                    .search(this.value)
                    .draw();
            }
        });
    });


    stakeholdertable.columns.adjust();
}
var styles, nodeMap, meta, defaultCcy, ccy; ;

$('document').ready(function () {

    var panelFragment = $("#panel-template").html();
    panelTemplate = Handlebars.compile(panelFragment);

    var selectFragment = $("#select-template").html();
    selectTemplate = Handlebars.compile(selectFragment);

    var costTotalFragment = $("#costTotal-template").text();
    costTotalTemplate = Handlebars.compile(costTotalFragment); 

    var selectTemplateFragment = $("#select-template").html();
    selectTemplate = Handlebars.compile(selectTemplateFragment);



    Promise.all([
        promise_loadViewerAPIData(viewAPIDataProcess),
        promise_loadViewerAPIData(viewAPIDataPhysProcess) 
        ]).then(function(responses) { 
           let processes =responses[0].businessProcesses;
          // console.log('responses[1]', responses[1])
           ccy=responses[0].ccy;
           processes.forEach((p)=>{
            $('#subjectSelection').append('<option value="'+p.id+'">'+p.name+'</option>');
            })
            meta =responses[0].meta;

            defaultCurrency = responses[0].ccy.find(currency => currency.default === "true"); 

            responses[1].process_to_apps.forEach((p)=>{ 

     // Build a lookup object from appProcessCriticalities keyed by appid
const criticalitiesMap = p.appProcessCriticalities.reduce((map, crit) => {
    map[crit.appid] = crit;
    return map;
  }, {});
  
  // Process apps in 'appsdirect'
  p.appsdirect.forEach(a => {
    // Initialise appInfo
    a.appInfo = {
      "id": a.appid,
      "name": "<i class='fa fa-bars'></i>",
      "className": "Application_Provider"
    };
      
    const match = criticalitiesMap[a.id]; 
    
    if (match) {
      a.style = match.criticalityStyle;
      a.criticality = match.appCriticality;
    }
  });
  
  // Process apps in 'appsviaservice'
  p.appsviaservice.forEach(a => {
    a.appInfo = {
      "id": a.appid,
      "name": "<i class='fa fa-bars'></i>",
      "className": "Application_Provider"
    };
    
    const match = criticalitiesMap[a.id]; 
    
    if (match) {
      a.style = match.criticalityStyle;
      a.criticality = match.appCriticality;
    }
  });
  
            })

           const processToAppsByProcessId = responses[1].process_to_apps.reduce((acc, item) => {
            if (!acc[item.processid]) {
              acc[item.processid] = [];
            }
            acc[item.processid].push(item);
            return acc;
          }, {});
          
          //   Merge process_to_apps entries into processes
           processes = processes.map(proc => ({
            ...proc,
            // Add the matching process_to_apps entries; if none exist, default to an empty array
            processToApps: processToAppsByProcessId[proc.id] || []
          }));

          function mergeBusProctype(dataArray) {
            return dataArray.map(data => {
                if (!data.busproctype_relation || !data.busproctype_uses_infoviews) return data;
                
                let infoViewsMap = new Map();
                data.busproctype_uses_infoviews.forEach(view => {
                    infoViewsMap.set(view.id, view);
                });
                
                data.busproctype_relation.forEach(relation => {
                    if (infoViewsMap.has(relation.infoRep)) {
                        let infoView = infoViewsMap.get(relation.infoRep);
                        relation.infoView = infoView;
                        
                        if (relation.read === "Yes") {
                            data.bus_process_type_reads_information = data.bus_process_type_reads_information || [];
                            data.bus_process_type_reads_information.push(infoView);
                        }
                        if (relation.create === "Yes") {
                            data.bus_process_type_creates_information = data.bus_process_type_creates_information || [];
                            data.bus_process_type_creates_information.push(infoView);
                        }
                        if (relation.update === "Yes") {
                            data.bus_process_type_updates_information = data.bus_process_type_updates_information || [];
                            data.bus_process_type_updates_information.push(infoView);
                        }
                        if (relation.delete === "Yes") {
                            data.bus_process_type_deletes_information = data.bus_process_type_deletes_information || [];
                            data.bus_process_type_deletes_information.push(infoView);
                        }
                    }
                });
                
                return data;
            });
        }  

        function updateProcesses(processes) {
       
            // Iterate over processes and update bp_sub_business_processes
            processes.forEach(proc => {
                proc.bp_sub_business_processes = proc.bp_sub_business_processes
                    .filter(id => processMap.has(id)) // Only keep IDs that exist in processMap
                    .map(id => ({
                        id,
                        name: processMap.get(id) // Guaranteed to exist due to the filter
                    }));
            });
 
            return processes;
        }

        mergeBusProctype(processes) 

        const processMap = new Map(processes.map(p => [p.id, p.name]));
        updateProcesses(processes)


            focusProcess = processes.find((e)=>{return e.id == focusProcessId})
            focusProcess['className']='Business_Process';

            $('#selectMenu').html(selectTemplate(focusProcess))
                .find('.context-menu-busProcessGenMenu')
                .html('<i class="fa fa-bars"></i> Menu'); 
        //console.log('planDataByType', planDataByType) 
            if (planDataByType?.['Business_Process']?.[focusProcess?.id]) { 
                 focusProcess['planData'] = planDataByType['Business_Process'][focusProcess.id];
            } else { 
                // do nothing, no plan data for this process
            } 
              //console.log('focusProcess', focusProcess.planData) 

            if(focusProcess){
                drawView(focusProcess)
            }
            $('#subjectSelection').off('change').on('change', function () {
                let selected = $(this).val();
                if (focusProcess?.id !== selected) {  // Prevent duplicate calls
                    focusProcess = processes.find((e) => e.id == selected);
                    if (focusProcess) {
                        drawView(focusProcess);
                            focusProcess['className']='Business_Process';
                        	$('#selectMenu').html(selectTemplate(focusProcess))
                                .find('.context-menu-busProcessGenMenu')
                                .html('<i class="fa fa-bars"></i> Menu'); 
                    }
                }
            });
            
            $('#subjectSelection').select2();
            if ($('#subjectSelection').val() !== focusProcessId) {
                $('#subjectSelection').val(focusProcessId).trigger('change');
            }
              

//cost start 
  

    if (!defaultCurrency || Object.keys(defaultCurrency).length === 0) {
 
        defaultCurrency = rcCcyId || {};
    }
    
      
    const calculateDefaultCosts = (costArray, currencyArray) => {
       
        let defaultExchangeRate = defaultCurrency ? parseFloat(defaultCurrency.exchangeRate) : 1;
      
          if(isNaN(defaultExchangeRate)){defaultExchangeRate=1} 
        return costArray?.map(cost => {
            const matchingCurrency = currencyArray.find(ccy => ccy.ccySymbol === cost.component_currency);
            let exchangeRate = matchingCurrency ? parseFloat(matchingCurrency.exchangeRate) : 1;
            if(isNaN(exchangeRate)){exchangeRate=1}
            const defaultCost = parseFloat(cost.cost) * (exchangeRate / defaultExchangeRate); 
            return {
                ...cost,
                defaultCost: defaultCost.toFixed(2)
            };
        });
    };
    
    if(focusProcess){
    const updatedCosts = calculateDefaultCosts(focusProcess.costs, ccy); 
 
     focusProcess.costs=updatedCosts
    }else{
        focusProcess.costs=[];
    }
    
    let costByCategory=[];
    let costByType=[];
    let costByFreq =[]
    if(focusProcess.costs){ 
        costByCategory = d3.nest()
            .key(function(d) { return d.costCategory; })
            .rollup(function(v) { return {
        total: d3.sum(v, function(d) { return d.cost; })
    }})
    .entries(focusProcess.costs);
    
    costByType = d3.nest()
    .key(function(d) { return d.name; })
    .rollup(function(v) { return {
        total: d3.sum(v, function(d) { return d.cost; })
    }})
    .entries(focusProcess.costs);
    
    costByFreq = d3.nest()
    .key(function(d) { return d.costType; })
    .rollup(function(v) { return {
        total: d3.sum(v, function(d) { return d.cost; })
    }})
    .entries(focusProcess.costs);
    }
    let costDivider;
    let fromDateArray = [];
    let toDateArray = [];
    let totalAnnualCost = 0;
    let totalMonthlyCost = 0;
    let monthsActive = 0;
    let today = new Date();
    let nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 1);
    
    if (focusProcess.costs) {
        focusProcess.costs.forEach((d) => {
    
            let numericCost = parseFloat(d.cost); // Convert string to number
     
            let costDivider = 1; // Default: 1 (full cost)
     
            // Determine how to distribute costs
            if (d.costType === "Adhoc_Cost_Component") {
                return; // Skip Adhoc costs in monthly and annual calculations
            } else if (d.costType === "Annual_Cost_Component") {
                costDivider = 12; // Spread annual cost over 12 months
            } else if (d.costType === "Quarterly_Cost_Component") {
                costDivider = 1; // Apply cost every 3 months
            } else if (d.costType === "Monthly_Cost_Component") {
                costDivider = 1; // Already a monthly cost
            }
    
            d.monthlyAmount = numericCost / costDivider; // Base calculation
     
            // **Guard code** to handle NaN for monthlyAmount
            if (isNaN(d.monthlyAmount)) {
                d.monthlyAmount = 0; // Set to 0 if NaN
            }
    
            let fromDate = d.fromDate ? new Date(d.fromDate) : today;
            let toDate = d.toDate ? new Date(d.toDate) : nextMonth;
    
            // If toDate is not set, make it 12 months from fromDate, assumes no date so just a recurring cost
            if (!d.toDate) {
                toDate.setFullYear(toDate.getFullYear() + 1);
            }
     
            // **Keep monthsActive for other calculations**
            monthsActive = (toDate.getFullYear() - fromDate.getFullYear()) * 12 + (toDate.getMonth() - fromDate.getMonth()) + 1; 
    
            // **Condition for Annual Cost**
            if (d.costType === "Annual_Cost_Component") {
                totalAnnualCost += numericCost; // Add the full cost for the year
            } else if (d.costType === "Quarterly_Cost_Component") {
                for (let i = 0; i < 12; i++) {
                    if (i % 3 === 0) { // Apply cost every 3 months
                        totalAnnualCost += d.monthlyAmount
     
                    }
                }
            } else if (d.costType === "Monthly_Cost_Component") {
         
                totalAnnualCost += d.monthlyAmount * 12; // Monthly cost components
            }
             
        });
    }
     
    // **Fix totalMonthlyCost Calculation**
    // If the period is less than 12 months, calculate based on the actual period
     
    if (monthsActive < 12) {
        if(monthsActive==0){
            monthsActive=1;
        }
    
        totalMonthlyCost = totalAnnualCost / monthsActive;
    } else {
        totalMonthlyCost = totalAnnualCost / 12; // Spread across 12 months if the period is full-year or more
    }
     
    // Format cost output
    let costNumbers = {};
      
    let formatter = new Intl.NumberFormat(undefined, { style: "currency", currency: defaultCurrency.ccyCode  });
    if (isNaN(totalMonthlyCost)) {
        totalMonthlyCost = 0; // Set to 0 if NaN
    }
    
    costNumbers['annualCost'] = formatter.format(Math.round(totalAnnualCost));
    costNumbers['monthlyCost'] = formatter.format(Math.round(totalMonthlyCost));
     
     
    if (focusProcess.costs) {
        focusProcess.costs.forEach((d) => {
            if (d.fromDate) fromDateArray.push(d.fromDate);
            if (d.toDate) toDateArray.push(d.toDate);
        });
    }
    
    // **Fix sorting issue**
    fromDateArray.sort((a, b) => new Date(a) - new Date(b));
    toDateArray.sort((a, b) => new Date(a) - new Date(b));
    
    let momentStartFinYear = moment(fromDateArray[0]);
    let momentEndFinYear = moment(toDateArray[toDateArray.length - 1]);
    
    if (momentEndFinYear.isBefore(moment())) {
        momentEndFinYear = moment();
    }
    
    let costChartRowList = [];
    let costCurrency;
    
    // **Iterate over each cost component**
    focusProcess.costs?.forEach(function (aCost) {
        let numericCost = parseFloat(aCost.cost); // Ensure cost is a number
    
        // **Ensure numericCost is valid**
        if (isNaN(numericCost)) {
            console.error(`Invalid cost for:`, aCost);
            numericCost = 0; // Default to zero to avoid NaN propagation
        }
    
        // **Fix cost validity period**
        let thisFromDate = aCost.fromDate ? new Date(aCost.fromDate) : today;
        let thisToDate = aCost.toDate ? new Date(aCost.toDate) : nextMonth;
        let thisStart = moment(thisFromDate, 'YYYY-MM-DD', true);
        let thisEnd = moment(thisToDate, 'YYYY-MM-DD', true);
    
        // **Ensure valid dates before proceeding**
        if (!thisStart.isValid() || !thisEnd.isValid()) {
            console.error(`Invalid date range for:`, aCost);
            return; // Skip this cost entry
        }
    
        thisStart = moment.max(thisStart, momentStartFinYear);
        thisEnd = moment.min(thisEnd, momentEndFinYear);
    
        // **Fix month count calculation (ensure inclusive of both start and end months)**
        let monthCount = thisEnd.diff(thisStart, 'months') + 1;
    
        // **Ensure monthCount is valid**
        if(monthCount==0){monthCount=1}
    
        if (isNaN(monthCount) || monthCount <= 0) {
            console.error(`Invalid monthCount for:`, aCost, `Calculated monthCount:`, monthCount);
            monthCount = 1; // Ensure at least 1 month
        }
        aCost['monthCount'] = Math.ceil(monthCount);
    
        // **Fix monthStart calculation**
        let monthStart = thisStart.diff(momentStartFinYear, 'months');
        if (isNaN(monthStart) || monthStart < 0) {
            console.error(`Invalid monthStart for:`, aCost, `Calculated monthStart:`, monthStart);
            monthStart = 0; // Ensure valid 0-based index
        }
        aCost['monthStart'] = Math.floor(monthStart);
    
        // **Ensure correct cost distribution**
        if (aCost.costType === "Adhoc_Cost_Component") {  
            aCost.monthlyAmount = numericCost / aCost.monthCount;
        } else if (aCost.costType === "Annual_Cost_Component") {
            aCost.monthlyAmount = numericCost / 12;
        } else if (aCost.costType === "Quarterly_Cost_Component") {
            aCost.monthlyAmount = numericCost; // Keep full amount but apply only every 3 months
        } else {
            aCost.monthlyAmount = numericCost;
        }
    
        // Assign currency dynamically
        costCurrency = aCost.ccy_code; 
        // **Fix missing dates dynamically**
        if (!aCost.toDate) aCost['toDate'] = momentEndFinYear.format('YYYY-MM-DD');
        if (!aCost.fromDate || aCost.fromDate === '') aCost['fromDate'] = momentStartFinYear.format('YYYY-MM-DD');
    
        // **Fix total amount for valid months**
        aCost['inScopeAmount'] = Math.round(aCost['monthlyAmount'] * aCost['monthCount']);
    
        // **Fix costChartRow creation**
        let costChartRow = new Array(aCost.monthStart).fill(0); // Fill with zeros for inactive months
    
        if (aCost.costType === "Quarterly_Cost_Component") {
            for (let i = 0; i < aCost.monthCount; i++) {
                if ((i + aCost.monthStart) % 3 === 0) { // Apply cost every 3rd month
                    costChartRow.push(aCost.monthlyAmount);
                } else {
                    costChartRow.push(0); // Keep zero in other months
                }
            }
        } else {
            for (let i = 0; i < aCost.monthCount; i++) {
                costChartRow.push(aCost.monthlyAmount);
            }
        } 
        costChartRowList.push(costChartRow);
    });
    
    // **Fix month-by-month cost distribution**
    let monthsListCount = momentEndFinYear.diff(momentStartFinYear, 'months') + 1;
    let monthsList = [];
    let sumsList = Array(monthsListCount).fill(0);
    
    for (let i = 0; i < monthsListCount; i++) {
        monthsList.push(moment(momentStartFinYear).add(i, 'months').format('MM/YYYY'));
    
        let monthlyTotal = 0;
        costChartRowList.forEach((row) => {
            if (row[i]) {
                monthlyTotal += row[i];
            }
        });
    
        sumsList[i] = monthlyTotal;
    }
 
    cbcLabels=[];
    cbcVals=[];
     
    cbtLabels=[];
    cbtVals=[];
    
    cbfLabels=[];
    cbfVals=[]; 
    costByCategory.forEach((f)=>{ 
    if(f.key=='undefined'){ 
    f['key']='Run Cost'
    } 
        cbcLabels.push(f.key);
        cbcVals.push(f.value.total);
    })
    
    costByType.forEach((f)=>{
        cbtLabels.push(f.key);
        cbtVals.push(f.value.total);
    })
    
    let totalCost=0;
    costByFreq.forEach((f)=>{
        cbfLabels.push(f.key);
        cbfVals.push(f.value.total);
    })
 

$('.costTotal-container').html(costTotalTemplate(costNumbers))
 

ccy.forEach((c)=>{
 
	$('#ccySelect').append('<option value="'+c.id+'">'+c.ccyCode+'</option>');
})

$('#ccySelect').select2({
  width:'100px'
});

$('#ccySelect').on('change', function() {
  const currency = $(this).val();
  updateCharts(currency);
});

if(cbfLabels.length>0){
const chartCostByFrequency = new Chart(document.getElementById("costByFrequency-chart"), {
  type: 'doughnut',
  data: {
    labels: cbfLabels,
    datasets: [
      {
        label: "Frequency",
        backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
        data: cbfVals
      }
    ]
  },
  options: {
    responsive: true,
    title: {
      display: true,
      text: 'Cost By Frequency'
    },
    legend: {
      position: "bottom",
      align: "middle"
    }
  }
});

// Repeat for other charts
const chartCostByCategory = new Chart(document.getElementById("costByCategory-chart"), {
  type: 'doughnut',
  data: {
    labels: cbcLabels,
    datasets: [
      {
        label: "Type",
        backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
        data: cbcVals
      }
    ]
  },
  options: {
    responsive: true,
    title: {
      display: true,
      text: 'Cost By Category'
    },
    legend: {
      position: "bottom",
      align: "middle"
    }
  }
});

const chartCostByType = new Chart(document.getElementById("costByType-chart"), {
  type: 'doughnut',
  data: {
    labels: cbtLabels,
    datasets: [
      {
        label: "Type",
        backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
        data: cbtVals
      }
    ]
  },
  options: {
    responsive: true,
    title: {
      display: true,
      text: 'Cost By Type'
    },
    legend: {
      position: "right",
      align: "middle"
    }
  }
});

const locale = navigator.language || 'en-US';

const chartCostByMonth = new Chart(document.getElementById("costByMonth-chart"), {
  type: 'bar',
  data: {
    labels: monthsList,
    datasets: [
      {
        label: "Cost Per Month",
        backgroundColor: "#f5aa42",
        data: sumsList
      }
    ]
  },
  options: {
    responsive: true,
    scales: {
      yAxes: [{
        ticks: {
          beginAtZero: true,
          callback: function(value) {
            return new Intl.NumberFormat(locale, { style: 'currency', currency: defaultCurrency.ccyCode}).format(value); // Change to the selected currency
          }
        }
      }]
    },
    plugins: {
      labels: false
    }
  }
});


function updateCharts(currency) {
	 
	let ccySelected=ccy.find(d => d.id == currency)
 	let rate = ccySelected.exchangeRate;
	let ccyCd = ccySelected.ccyCode;
	
  // Convert the rate to a float
  rate = parseFloat(rate); 

  if (isNaN(rate)) {
    rate = 1;
  } 
  // Remove the currency symbol and commas, then convert the string to a float
  let annualCostValue = parseFloat(costNumbers.annualCost.replace(/[^\d.-]/g, ''));
  let monthlyCostValue = parseFloat(costNumbers.monthlyCost.replace(/[^\d.-]/g, ''));

  // Multiply the costs by the exchange rate
  annualCostValue *= rate;
  monthlyCostValue *= rate;

	$('#regAnnual').text(new Intl.NumberFormat('en-US', { 
      style: 'currency', 
      currency: ccyCd 
    }).format(annualCostValue));

	$('#regMonthly').text(new Intl.NumberFormat('en-US', { 
      style: 'currency', 
      currency: ccyCd 
    }).format(monthlyCostValue));

  // Multiply the values by the exchange rate
  const updatedCbfVals = cbfVals.map(value => value * rate);
  const updatedCbcVals = cbcVals.map(value => value * rate);
  const updatedCbtVals = cbtVals.map(value => value * rate);
  const updatedSumsList = sumsList.map(value => value * rate);

    // Update the Y-axis label with the selected currency symbol
  chartCostByMonth.options.scales.yAxes[0].ticks.callback = function(value) {
    return new Intl.NumberFormat('en-US', { 
      style: 'currency', 
      currency: ccyCd 
    }).format(value);
  };

  // Update each chart
  chartCostByFrequency.data.datasets[0].data = updatedCbfVals;
  chartCostByCategory.data.datasets[0].data = updatedCbcVals;
  chartCostByType.data.datasets[0].data = updatedCbtVals;
  chartCostByMonth.data.datasets[0].data = updatedSumsList;

  // Re-render the charts
  chartCostByFrequency.update();
  chartCostByCategory.update();
  chartCostByType.update();
  chartCostByMonth.update();
}
}
 })
//cost end 



})

function drawView(nodeToShow){ 

   function refreshDiagram(aDiagram) {
 
        showEditorSpinner('Loading diagram...');
        essPromise_getAPIElement('/essential-core/v1', 'diagrams', aDiagram.id, 'Diagram')
        .then(function(response) { 
            removeEditorSpinner(); 
            drawDiagram(response.config);  
            
            return;
        })
        .catch(function (error) {
            removeEditorSpinner();
            console.log(error);
            //Show an error message: error
        });
    }
    function drawDiagram(diagramData) {
       // console.log('paperScroller', paperScroller.el)
        paperScroller.setCursor('grab'); 
        graph.fromJSON(diagramData);
       // console.log('paper', paper)

        paper.fitToContent({
            padding: 5,
            maxWidth: 1200,
            height: 600,
            allowNewOrigin: 'any'
        });

        setTimeout(() => {
           
          //  paperScroller.zoomToFit();
            paperScroller.center();
        }, 300);

       paper.on('blank:pointerdown', function(event, x, y) {
        paperScroller.startPanning(event);
    });

    paper.on('element:pointerdown', function(elementView, event) {
        paperScroller.startPanning(event);
    });

        // Improved zooming: zoom towards the mouse pointer
     const containerpc = paperScroller.el;

// your zoom/pan logic
function onWheel(evt) {
  // prevent the browser’s default zoom/scroll
  evt.preventDefault();

  if (evt.ctrlKey || evt.metaKey) {
    // zoom the diagram only
    const delta = evt.deltaY > 0 ? -0.1 : 0.1;
    paperScroller.zoom(
      Math.max(0.2, Math.min(paperScroller.zoom() + delta, 2)),
      { absolute: true, ox: evt.offsetX, oy: evt.offsetY }
    );
  } else {
    // pan the diagram
    paperScroller.el.scrollBy({
      top:  evt.deltaY,
      left: evt.deltaX,
      behavior: 'auto'
    });
  }
}

// **This { passive:false } is the key**
 containerpc.addEventListener('wheel', onWheel, { passive: false });


        // Fix container scrolling
       // document.getElementById('paper-container').style.overflow = 'auto';

        // diagram steps
 let nodes = {};
        let adj = {};
        let pools = {};
        let flowLookup = {};
        let startNode = null;
        let potentialEndNodes = []; // For Greedy BFS heuristic
        let currentAlgorithm = 'dfs'; // Default algorithm

        // --- Utility: Simple Priority Queue for Greedy BFS ---
        function PriorityQueue() {
            this.elements = []; // Store {priority, item}
        }
        PriorityQueue.prototype.enqueue = function(item, priority) {
            this.elements.push({ item: item, priority: priority });
            this.elements.sort((a, b) => a.priority - b.priority); // Keep sorted for min-priority
        };
        PriorityQueue.prototype.dequeue = function() {
            if (this.isEmpty()) return null;
            return this.elements.shift().item;
        };
        PriorityQueue.prototype.isEmpty = function() {
            return this.elements.length === 0;
        };

        // --- Utility: Euclidean Distance for Heuristic ---
        function euclideanDistance(pos1, pos2) {
            if (!pos1 || !pos2) return Infinity; // Should not happen with valid nodes
            return Math.sqrt(Math.pow(pos1.x - pos2.x, 2) + Math.pow(pos1.y - pos2.y, 2));
        }

        // --- Setup and Parsing (runs once) ---
        function initializeBPMNData(jsonData) {
             
            // Reset global stores
            nodes = {};
            adj = {};
            pools = {};
            flowLookup = {};
            startNode = null;
            potentialEndNodes = [];

            const cells = jsonData.cells;
            const tempFlows = []; // Temporary for building adj list
            const nodeTypes = ['bpmn2.Event', 'bpmn2.Activity', 'bpmn2.Gateway'];

            cells.forEach(cell => {
                if (nodeTypes.includes(cell.type)) {
                    nodes[cell.id] = {
                        id: cell.id,
                        name: cell.attrs.label ? cell.attrs.label.text : 'Unnamed',
                        type: cell.type.replace('bpmn2.', ''),
                        rawType: cell.type,
                        position: cell.position,
                        parentId: cell.parent // Store parent ID
                    };
                } else if (cell.type === 'bpmn2.Flow' && cell.source && cell.target) { // Ensure source and target exist
                    const flowData = { id: cell.id, source: cell.source.id, target: cell.target.id, labels: cell.labels };
                    tempFlows.push(flowData);
                    flowLookup[`${cell.source.id}->${cell.target.id}`] = flowData; // For branch identifier lookup
                } else if (cell.type === 'bpmn2.HeaderedPool') {
                    pools[cell.id] = {
                        name: cell.attrs.headerLabel ? cell.attrs.headerLabel.text : 'Unnamed Pool'
                    };
                }
            });

            tempFlows.forEach(flow => {
                if (!adj[flow.source]) adj[flow.source] = [];
                adj[flow.source].push(flow.target);
            });

            const allTargetIds = new Set(tempFlows.map(f => f.target));
            let startNodeCandidates = Object.values(nodes).filter(node => node.rawType === 'bpmn2.Event' && !allTargetIds.has(node.id));
            if (startNodeCandidates.length === 0) {
                startNodeCandidates = Object.values(nodes).filter(node => !allTargetIds.has(node.id));
            }
            if (startNodeCandidates.length > 1) {
                startNodeCandidates.sort((a,b) => a.position.x - b.position.x || a.position.y - b.position.y);
            }
            startNode = startNodeCandidates.length > 0 ? startNodeCandidates[0] : (Object.keys(nodes).length > 0 ? Object.values(nodes)[0] : null);

            // Identify potential end nodes (nodes with no outgoing flows) for Greedy BFS heuristic
            for (const nodeId in nodes) {
                if (!adj[nodeId] || adj[nodeId].length === 0) {
                    potentialEndNodes.push(nodes[nodeId]);
                }
            }
            // Sort potential end nodes (e.g., prefer rightmost/bottommost)
            if (potentialEndNodes.length > 1) {
                potentialEndNodes.sort((a,b) => (b.position.x - a.position.x) || (b.position.y - a.position.y));
            }
        }

        // --- Algorithm Implementations ---
        let orderedSteps = [];
        let visited = new Set();

        function runDFS() { 
            function dfsRecursive(nodeId, parentNodeId, inheritedBranchLabel) {
                if (!nodeId || visited.has(nodeId) || !nodes[nodeId]) return;
                visited.add(nodeId);
                const node = nodes[nodeId];
                const poolName = node.parentId && pools[node.parentId] ? pools[node.parentId].name : 'N/A';
                
                let currentBranchLabel = inheritedBranchLabel;
                if (parentNodeId && nodes[parentNodeId] && nodes[parentNodeId].type === 'Gateway') {
                    const flow = flowLookup[`${parentNodeId}->${nodeId}`];
                    if (flow && flow.labels && flow.labels.length > 0 && flow.labels[0].attrs && flow.labels[0].attrs.label && flow.labels[0].attrs.label.text) {
                        currentBranchLabel = flow.labels[0].attrs.label.text;
                    } else {
                        currentBranchLabel = ''; // Unlabeled branch from gateway
                    }
                }
                orderedSteps.push({ ...node, rowName: poolName, branchIdentifier: currentBranchLabel });

                let neighbors = (adj[nodeId] || []).map(id => nodes[id]).filter(n => n);
                if (node.type === 'Gateway') { // Sort gateway branches by Y position
                    neighbors.sort((a,b) => a.position.y - b.position.y);
                }
                neighbors.forEach(neighbor => dfsRecursive(neighbor.id, nodeId, currentBranchLabel));
            }
            if (startNode) dfsRecursive(startNode.id, null, ''); // Initial call
        }

        function runBFS() { 
            const queue = [];
            if (startNode) {
                queue.push({ nodeId: startNode.id, parentNodeId: null, inheritedBranchLabel: '' });
                visited.add(startNode.id);
            }

            while (queue.length > 0) {
                const { nodeId, parentNodeId, inheritedBranchLabel } = queue.shift();
                const node = nodes[nodeId];
                const poolName = node.parentId && pools[node.parentId] ? pools[node.parentId].name : 'N/A';

                let currentBranchLabel = inheritedBranchLabel;
                 if (parentNodeId && nodes[parentNodeId] && nodes[parentNodeId].type === 'Gateway') {
                    const flow = flowLookup[`${parentNodeId}->${nodeId}`];
                    if (flow && flow.labels && flow.labels.length > 0 && flow.labels[0].attrs && flow.labels[0].attrs.label && flow.labels[0].attrs.label.text) {
                        currentBranchLabel = flow.labels[0].attrs.label.text;
                    } else {
                         currentBranchLabel = ''; // Unlabeled branch from gateway
                    }
                }
                orderedSteps.push({ ...node, rowName: poolName, branchIdentifier: currentBranchLabel });

                let neighbors = (adj[nodeId] || []).map(id => nodes[id]).filter(n => n);
                if (node.type === 'Gateway') { // Sort gateway branches by Y position
                    neighbors.sort((a,b) => a.position.y - b.position.y);
                }
                neighbors.forEach(neighbor => {
                    if (!visited.has(neighbor.id)) {
                        visited.add(neighbor.id);
                        // Pass currentBranchLabel as the inherited one for the next level
                        queue.push({ nodeId: neighbor.id, parentNodeId: nodeId, inheritedBranchLabel: currentBranchLabel });
                    }
                });
            }
        }

        function runGreedyBFS() { 
            if (!startNode) return;
            const pq = new PriorityQueue();
            // Use the first potential end node as a simple goal for the heuristic
            const goalNode = potentialEndNodes.length > 0 ? potentialEndNodes[0] : null; 

            function heuristic(nodeId) {
                const node = nodes[nodeId];
                if (goalNode && node && node.position && goalNode.position) {
                    return euclideanDistance(node.position, goalNode.position);
                }
                // Fallback heuristic: prefer nodes to the right (larger x) or bottom (larger y)
                // Since PQ is min-priority, we can use -x or a combination.
                // For simplicity, if no goal, just use a basic positional preference.
                return node && node.position ? -node.position.x - node.position.y : Infinity; 
            }

            pq.enqueue({ nodeId: startNode.id, parentNodeId: null, inheritedBranchLabel: '' }, heuristic(startNode.id));
            
            while (!pq.isEmpty()) {
                const { nodeId, parentNodeId, inheritedBranchLabel } = pq.dequeue();

                if (visited.has(nodeId)) continue;
                visited.add(nodeId);

                const node = nodes[nodeId];
                const poolName = node.parentId && pools[node.parentId] ? pools[node.parentId].name : 'N/A';
                
                let currentBranchLabel = inheritedBranchLabel;
                if (parentNodeId && nodes[parentNodeId] && nodes[parentNodeId].type === 'Gateway') {
                    const flow = flowLookup[`${parentNodeId}->${nodeId}`];
                     if (flow && flow.labels && flow.labels.length > 0 && flow.labels[0].attrs && flow.labels[0].attrs.label && flow.labels[0].attrs.label.text) {
                        currentBranchLabel = flow.labels[0].attrs.label.text;
                    } else {
                        currentBranchLabel = ''; // Unlabeled branch from gateway
                    }
                }
                orderedSteps.push({ ...node, rowName: poolName, branchIdentifier: currentBranchLabel });

                if (goalNode && nodeId === goalNode.id) break; // Optional: stop if goal reached

                let neighbors = (adj[nodeId] || []).map(id => nodes[id]).filter(n => n);
                if (node.type === 'Gateway') { // Sort gateway branches by Y position
                    neighbors.sort((a,b) => a.position.y - b.position.y);
                }
                neighbors.forEach(neighbor => {
                    if (!visited.has(neighbor.id)) {
                        // Pass currentBranchLabel as the inherited one for the next step
                        pq.enqueue({ nodeId: neighbor.id, parentNodeId: nodeId, inheritedBranchLabel: currentBranchLabel }, heuristic(neighbor.id));
                    }
                });
            }
        }

        // --- Table Population ---
        function populateTable() {
            // This function is now called by regenerateTable after orderedSteps is populated
            // The actual orderedSteps array is a global (within script scope)
            // and populated by the specific algorithm function.

            // Add any unvisited nodes (e.g., disconnected parts of the diagram)
            Object.values(nodes).forEach(node => { 
                if (!visited.has(node.id)) { // Now uses the global 'visited' set
                    const poolName = node.parentId && pools[node.parentId] ? pools[node.parentId].name : 'N/A';
                    orderedSteps.push({ ...node, rowName: poolName, branchIdentifier: '' }); // No branch info for disconnected
                }
            });
            
            const tableBody = document.getElementById('bpmnTableBody');
            if (!tableBody) {
                console.error('Table body not found!');
                return;
            }
            tableBody.innerHTML = ''; // Clear existing rows

            orderedSteps.forEach((step, index) => { // Now uses the global 'orderedSteps' array
                const row = tableBody.insertRow();
                
                const cellStep = row.insertCell();
                cellStep.textContent = index + 1;

                const cellName = row.insertCell();
                cellName.textContent = step.name;

                const cellType = row.insertCell();
                cellType.textContent = step.type;

                const cellRow = row.insertCell();
                cellRow.textContent = step.rowName;

                // Add the 'hide-id' class to the ID cell
                const cellId = row.insertCell();
                cellId.classList.add('hide-id');

                const cellBranch = row.insertCell();
                cellBranch.textContent = step.branchIdentifier || '';

                const cellNextSteps = row.insertCell();
                const nextStepIds = adj[step.id] || [];
                
                const nextStepDetails = nextStepIds.map(targetId => {
                    const foundStepIndex = orderedSteps.findIndex(s => s.id === targetId);
                    if (foundStepIndex !== -1) {
                        const flow = flowLookup[`${step.id}->${targetId}`];
                        let flowLabel = ''; // Default to empty if no label
                        if (flow && flow.labels && flow.labels.length > 0 && flow.labels[0].attrs && flow.labels[0].attrs.label && flow.labels[0].attrs.label.text) {
                            flowLabel = flow.labels[0].attrs.label.text;
                        }
                        return { number: foundStepIndex + 1, label: flowLabel };
                    }
                    return null; 
                }).filter(detail => detail !== null); // Filter out any nulls

                if (nextStepDetails.length > 0) {
                    const ul = document.createElement('ul');
                    ul.style.margin = '0px'; // Remove default ul margin
                    ul.style.paddingLeft = '20px'; // Standard ul padding for bullets
                    nextStepDetails.forEach(detail => {
                        const li = document.createElement('li');
                        li.textContent = detail.label ? `${detail.number} (${detail.label})` : `${detail.number}`;
                        ul.appendChild(li);
                    });
                    cellNextSteps.appendChild(ul);
                } else {
                    cellNextSteps.textContent = ''; // Or 'None'
                }
            });
        }

        // --- Main control function ---
        function regenerateTable() {
            orderedSteps = []; // Clear previous results
            visited.clear();   // Clear visited set

            currentAlgorithm = document.getElementById('algorithmSelect').value;

            switch (currentAlgorithm) {
                case 'dfs':
                    runDFS();
                    break;
                case 'bfs':
                    runBFS();
                    break;
                case 'greedy_bfs':
                    runGreedyBFS();
                    break;
                default:
                    runDFS(); // Default to DFS
            }
            populateTable();
        }
 
        // Initialize and first run
        initializeBPMNData(diagramData);

        $('#algorithmSelect').on('change', function(){ 
            regenerateTable()
        });
        regenerateTable(); // Initial table generation using the default algorithm

    }

    var graph = new joint.dia.Graph({ type: 'standard.HeaderedRectangle' }, { cellNamespace: joint.shapes });

    var windowWidth = $('#processModal').width();
    var windowHeight = $('#processModal').height();
    var paper = new joint.dia.Paper({
        width: 1,
        height: 1,
        model: graph,
        gridSize: 5,
        async: true,
        sorting: joint.dia.Paper.sorting.APPROX,
        interactive: { 
            linkMove: false,
            elementMove: false, // Enable dragging elements
            paper: true // Allow interactions with the background
        },
        snapLabels: true,
        cellViewNamespace: joint.shapes,
        restrictTranslate: false // Allow elements to move freely
    });

    var paperScroller = new joint.ui.PaperScroller({
        autoResizePaper: true,
        padding: 20,
        paper: paper,
        scrollWhileDragging: true,
        mouseWheel: false // Enable scrolling while dragging
    });

   

    
function getDiagram(procid){
    //get diagrams - only works on Cloud/Docker 
  
    let viewAPIDiagramInfo= apiPath+''+ procid; 
   
        promise_loadViewerAPIData(viewAPIDiagramInfo)
            .then(function(response) { 
 
        const instance = response.instance.find(inst => inst.name === "ea_diagrams");
    
         if(instance){
            $('#diagramtabid').show()
         }else{
            $('#diagramtabid').hide();
         }
                        if (instance && instance.values.length > 0) { 
                            $('#diagrams').empty();
                            $('#diagrams').append('<option>Choose</option>')
                            instance.values.forEach((s)=>{
                         
                                $('#diagrams').append('<option value="'+s.id+'">'+s.name+'</option>')
                                
                            })
                             
                           $('#diagrams').select2({ width: "200px" });

                            let diagramtoShow={"id": instance.values[0].id} 
                            //    refreshDiagram(diagramtoShow)  

                            $('#diagrams').off().on('change', function(){  
                                let selectedDiagram= $('#diagrams option:selected').val();
                                $('#diagramName').text($('#diagrams option:selected').text());
  
                                let diagramtoShow={"id": selectedDiagram}
                                    
                                refreshDiagram(diagramtoShow)  
                            })
                        }else{
                                
                        }   
            }) 
           
        }    
   
    $('#selectMenu').html(selectTemplate(nodeToShow))
        .find('.context-menu-busProcessGenMenu')
        .html('<i class="fa fa-bars"></i> Menu'); 
 


focusProcess = getIndivAndGroupActorsStakeholders(nodeToShow);
 
if(eip == false){focusProcess['eip']=false}
console.log('focusProcess', focusProcess)
$('#mainPanel').html(panelTemplate(focusProcess))

        paperScroller.render();
 
        document.getElementById('paper-container').appendChild(paperScroller.el);

        // 2) Bind startPanning directly, preserving the scroller as `this`:
paper.on('blank:pointerdown', function(event, x, y) {
 
  paperScroller.startPanning.call(paperScroller, event);
});

paper.on('element:pointerdown', function(elementView, event) {
  paperScroller.startPanning.call(paperScroller, event);
});
        paperScroller.setCursor('grab');
 

  getDiagram(focusProcess.flowid)
activateStakeholdersDataTable()
$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){ $($.fn.dataTable.tables(true)).DataTable() .columns.adjust(); } ); 

$('#diagramtabid').off('click').on('click', function () {
    const firstOption = $('#diagrams option:eq(1)').val();
     
    if (firstOption) {
        $('#diagrams').val(firstOption).trigger('change');
    } 
})

}
