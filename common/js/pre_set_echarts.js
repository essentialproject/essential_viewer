/* set of predefined echarts
createMultiDateLineChart(containerId, chartTitle, seriesData, legendData)
send multiple dates to a chart

createLineChart(exampleData, "Changes Overview 2024", ['Application A', 'Application B']);
simple lne chart
*/

function createMultiDateLineChart(containerId, chartTitle, seriesData, legendData) {
    var chartDom = document.getElementById(containerId);
    var myChart = echarts.init(chartDom);
    var option = {
        title: {
            text: chartTitle
        },
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            data: legendData
        },
        grid: {
            left: '100px' // Adjust the grid setting to align properly on the chart.
        },
        xAxis: {
            type: 'time', // Ensures that the xAxis is treated as datetime.
            boundaryGap: false
        },
        yAxis: {
            type: 'value',
            axisLabel: {
                formatter: '${value}' // Formats the yAxis values with a dollar sign.
            }
        },
        series: seriesData // Expects an array of series objects.
    };

    myChart.setOption(option);
}

/* example usage
const costData = [
    {
        name: 'Annual',
        type: 'line',
        data: [['2024-01-01', 800], ['2024-02-01', 900], ['2024-03-01', 1000]]
    },
    {
        name: 'Monthly',
        type: 'line',
        data: [['2024-01-01', 100], ['2024-02-01', 120], ['2024-03-01', 140]]
    },
    {
        name: 'Quarterly',
        type: 'line',
        data: [['2024-01-01', 300], ['2024-02-01', 330], ['2024-03-01', 360]]
    }
];

createMultiDateLineChart('main', 'Cost Overview', costData, ['Annual', 'Monthly', 'Quarterly']);
*/

function createLineChart(data, chartTitle, legendNames) {
    var chartDom = document.getElementById('main');
    var myChart = echarts.init(chartDom);
    var option;

    option = {
        title: {
            text: chartTitle
        },
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            data: legendNames
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: data.xAxis
        },
        yAxis: {
            type: 'value'
        },
        series: data.series.map(series => ({
            name: series.name,
            type: 'line',
            data: series.data
        }))
    };

    myChart.setOption(option);
}

/*
// Example data to pass to the function, including dynamic titles and multiple series
const exampleData = {
    xAxis: ['January', 'February', 'March', 'April', 'May'],
    series: [
        {
            name: 'Product A',
            data: [820, 932, 901, 934, 1290]
        },
        {
            name: 'Product B',
            data: [1200, 1132, 1411, 1344, 900]
        }
    ]
};

function: 
createLineChart(exampleData, "Sales Overview 2024", ['Product A', 'Product B']);
*/

//Data set-up functions

//cost function wher multiple dates and costs
	function expandCostData(costs) {
		const months = { 'Monthly_Cost_Component': 1, 'Quarterly_Cost_Component': 3 };
		let expandedCosts = {};
	
		costs.forEach(cost => {
			let { recurrence, amount, startDate, endDate } = cost;
	
			// Initialize array for each cost type if not already initialized
			if (!expandedCosts[recurrence]) {
				expandedCosts[recurrence] = [];
			}
	
			// Parse the start and end dates
			let currentDate = new Date(startDate);
			const end = new Date(endDate);
	
			// Set monthly or quarterly increments
			let incrementMonths = months[recurrence] || 0;
	
			// Generate rows based on recurrence
			if (incrementMonths > 0) {
				while (currentDate <= end) {
					expandedCosts[recurrence].push([currentDate.toISOString().split('T')[0], amount]); // Format as [date, amount]
					currentDate.setMonth(currentDate.getMonth() + incrementMonths);
				}
			} else {
				// For Adhoc, just add a single entry
				expandedCosts[recurrence].push([startDate, amount]); // Format as [date, amount]
			}
		});
	
		return expandedCosts;
	}

//budget function
function expandBudgetData(budgets) {
    const months = { 'Monthly_Budgetary_Element': 1, 'Quarterly_Budgetary_Element': 3 };
    let expandedBudgets = {};

    budgets.forEach(budget => {
        let { recurrence, amount, startDate, endDate } = budget;

        // Initialize array for each Budget type if not already initialized
        if (!expandedBudgets[recurrence]) {
            expandedBudgets[recurrence] = [];
        }

        // Parse the start and end dates
        let currentDate = new Date(startDate);
        const end = new Date(endDate);

        // Set monthly or quarterly increments
        let incrementMonths = months[recurrence] || 0;

        // Generate rows based on recurrence
        if (incrementMonths > 0) {
            while (currentDate <= end) {
                expandedBudgets[recurrence].push([currentDate.toISOString().split('T')[0], amount]); // Format as [date, amount]
                currentDate.setMonth(currentDate.getMonth() + incrementMonths);
            }
        } else {
            // For Adhoc, just add a single entry
            expandedBudgets[recurrence].push([startDate, amount]); // Format as [date, amount]
        }
    });
 
    return expandedBudgets;
}    

//calculate totals

function calculateTotals(costData) {
    const totals = {};

    // Iterate over each property in the cost data
    Object.keys(costData).forEach(key => {
        // Initialize total to 0 for each component
        totals[key] = 0;

        // Sum up all amounts in the data arrays for each component
        costData[key].forEach(costEntry => {
            totals[key] += costEntry[1]; // Add the second element of each array which is the cost
        });
    });

    return totals; 
}

//merges dates with the same data type but on different lines
function mergeAndSumDateValues(dataObject) {
    // Iterate over each property in the data object
    for (const key in dataObject) {
        const dateSums = {};  // Temporary object to hold sums of values by date for the current property

        // Process each date-value pair in the current property
        dataObject[key].forEach(([date, value]) => {
            if (dateSums[date]) {
                dateSums[date] += value;  // Add to the existing sum for this date
            } else {
                dateSums[date] = value;  // Initialize with the first value for this date
            }
        });

        // Replace the original array with a new array of merged and summed date-values
        dataObject[key] = Object.entries(dateSums).map(([date, sum]) => [date, sum]);
    }

    return dataObject;  // Optionally return the modified object for further use
}