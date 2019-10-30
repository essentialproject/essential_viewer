/* Copyright (c) 2017 Michael Hall
Thanks go to Michael Hall for providing this re-usable donut chart
see https://bl.ocks.org/mbhall88/b2504f8f3e384de4ff2b9dfa60f325e2 for details */

function renderAppCodebaseDonutChartData(data) {
    
    var widgetData = {
        'valueProperty': 'proportion',
        'categoryProperty': 'codebase',
        'data': data.applications
    };
    
    return widgetData;

}