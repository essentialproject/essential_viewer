const DEFAULT_METRIC_COLOUR = "#8b8c8b";
const INSTANCE_SERVICE_QUALITY_GROUPS_URL = "sys-instance-service-quality-groups";
const TARGET_METRIC_VALUES_URL = "sys-target-metric-values";
const ACTUAL_METRIC_VALUES_URL = "sys-actual-metric-values";

var currentSQGroup, currentActualMetrics, currentTargetMetrics, currentSQMetrics, sqMetricsTemplate;

function initKPIs() {
    console.log('init')
    let hbFrag = $('#ess-perf-trkng-sq-chart-partial');
    Handlebars.registerPartial('sqMetricsPartial', hbFrag.html());

    hbFrag = $("#ess-perf-trkng-panel-list-template").html();
    sqMetricsTemplate = Handlebars.compile(hbFrag);

    Handlebars.registerHelper('getSQFormattedDateTime', function(isoDT, options) {
        if(isoDT?.length > 0) {
            return moment(isoDT).format('DD MMM YYYY')
        } else {
            return '-';
        }
    });

    /***  NEED TO SET THIS VARIABLE TO THE ID 
    OF THE CURENT INSTANCE BEING SUMMARISED  ****/

}

//UTILITY FUNCTIONS
function getNewUUID() {
    return uuid.v4();
}

class ServiceQualityPerformance {
    constructor(sqDoc, targets, actuals) {
        this.id = getNewUUID();
        this.sqDoc = sqDoc;

        switch (this.sqDoc.type?.name) {
            case 'Enumeration':
                this.sqDoc.values?.sort(function(a, b){
                    if (a.score > b.score) {return -1;}
                    if (b.score < a.score) {return 1;}
                    return 0;
                });
                break;
            case 'Boolean':
                this.sqDoc.boolValues?.sort(function(a, b){
                    if (a.score > b.score) {return -1;}
                    if (b.score < a.score) {return 1;}
                    return 0;
                });
                break;
            default:
                break;
        }

        this.targets = targets;
        this.targets?.sort(function(a, b){
            if (a.frmDt < b.frmDt) {return -1;}
            if (b.frmDt > a.frmDt) {return 1;}
            return 0;
        });

        this.actuals = actuals;
        this.actuals?.sort(function(a, b){
            if (a.toDt < b.toDt) {return -1;}
            if (b.toDt > a.toDt) {return 1;}
            return 0;
        });

        this.refresh();
    }
    newFromDateIsValid(date) {
        let existingDate = this.targets?.find(tgt => tgt.frmDt >= date);
        return existingDate == null;
    }
    newToDateIsValid(date) {
        let existingDate = this.actuals?.find(act =>act.toDt >= date);
        return existingDate == null;
    }
    setEnumTargetChartVals() {
        let thisPerf = this;
        this.targets?.forEach(tgt => {
            let thisEnum = thisPerf.sqDoc?.values?.find(val => val.id == tgt.val);
            if(thisEnum?.score) {
                tgt.chartVal = thisEnum.score;
                tgt.chartLbl = thisEnum.label;
            } else {
                tgt.chartVal = 0;
            }
        });
    }
    setEnumActualColours() {
        let thisPerf = this;
        this.lastValBgClr = DEFAULT_METRIC_COLOUR;
        this.actuals?.forEach(function(act, idx){
            let thisEnum = thisPerf.sqDoc?.values?.find(val => val.id == act.val);
            if(thisEnum?.score) {
                act.chartVal = thisEnum.score;
                act.chartLbl = thisEnum.label;
            } else {
                act.chartVal = 0;
            }
            if(act.status == 'SYS_CONTENT_DRAFT') {
                act.clr = DEFAULT_METRIC_COLOUR;
            } else {
                if(thisEnum?.backgroundColor) {
                    act.clr = thisEnum.backgroundColor;
                } else {
                    act.clr = DEFAULT_METRIC_COLOUR;
                }
                if(idx == (thisPerf.actuals.length - 1)) {
                    thisPerf.lastValBgClr = act.clr;
                }
            }
        });
        thisPerf.lastValTxtClr = invertColor(thisPerf.lastValBgClr, true); 
    }
    setScalarTargetChartVals() {
        this.targets?.forEach(tgt => {
            tgt.chartVal = tgt.val;
        });
    }
    setScalarActualColours() {
        let thisPerf = this;
        let rangeCount = this.sqDoc?.scalarRanges?.length;
        this.lastValBgClr = DEFAULT_METRIC_COLOUR;
        if(rangeCount > 0) {
            this.actuals?.forEach(function(act, idx){
                act.chartVal = act.val;
                if(act.status == 'SYS_CONTENT_DRAFT') {
                    act.clr = DEFAULT_METRIC_COLOUR;
                } else {
                    let actVal = act.val;
                    let rngClr;
                    for (let index = 0; index < rangeCount; index++) {
                        const rng = thisPerf.sqDoc.scalarRanges[index];
                        if((index == rangeCount - 1) && (actVal >= rng.lowerLimit)) {
                            rngClr = rng.backgroundColor;
                        } else {
                            if((actVal >= rng.lowerLimit) && (actVal < rng.upperLimit)) {
                                rngClr = rng.backgroundColor;
                                break;
                            }
                        }
                    }
                    if(rngClr?.length > 0) {
                        act.clr = rngClr
                    } else {
                        act.clr = DEFAULT_METRIC_COLOUR;
                    }
                    if(idx == (thisPerf.actuals.length - 1)) {
                        thisPerf.lastValBgClr = act.clr;
                    }
                }
            });
        } else {
            this.actuals?.forEach(act => {
                act.clr = DEFAULT_METRIC_COLOUR;
            });
        }
        this.lastValTxtClr = invertColor(thisPerf.lastValBgClr, true);
    }
    setBoolTargetChartVals() {
        let thisPerf = this;
        this.targets?.forEach(tgt => {
            let thisBool = thisPerf.sqDoc?.boolValues?.find(val => val.value == tgt.val);
            if(thisBool?.score) {
                tgt.chartVal = thisBool.score;
                tgt.chartLbl = thisBool.label;
            } else {
                tgt.chartVal = 0;
            }
        });
    }
    setBoolActualColours() {
        let thisPerf = this;
        this.lastValBgClr = DEFAULT_METRIC_COLOUR;
        this.actuals?.forEach(function(act, idx){
            let thisBool = thisPerf.sqDoc?.boolValues?.find(val => val.value == act.val);
            if(thisBool?.score) {
                act.chartVal = thisBool.score;
                act.chartLbl = thisBool.label;
            } else {
                act.chartVal = 0;
            }
            if(act.status == 'SYS_CONTENT_DRAFT') {
                act.clr = DEFAULT_METRIC_COLOUR;
            } else {
                if(thisBool) {
                    act.clr = thisBool.backgroundColor;
                } else {
                    act.clr = DEFAULT_METRIC_COLOUR;
                }
            }
            if(idx == (thisPerf.actuals.length - 1)) {
                thisPerf.lastValBgClr = act.clr;
            }
        });
        this.lastValTxtClr = invertColor(thisPerf.lastValBgClr, true);
    }
    setShowChart() {
        this.showChart = (this.actuals?.length > 0) || (this.targets?.length > 0);
    }
    refresh() {
        let thisPerf = this;
        this.setShowChart();
        switch (this.sqDoc.type?.name) {
            case 'Scalar':
                thisPerf.setScalarActualColours();
                thisPerf.setScalarTargetChartVals();
                break;
            case 'Enumeration':
                thisPerf.setEnumActualColours();
                thisPerf.setEnumTargetChartVals();
                break;
            case 'Boolean':
                thisPerf.setBoolActualColours();
                thisPerf.setBoolTargetChartVals();
                break;
            default:
                break;
        }
    }
}


function initKPIEventListeners() {
    console.log('initiated')
    $('.ess-kpis-scroll-to-btn').off().on('click', function(evt) {
        let elId = $(this).attr('eas-id');
        $('#ess-kpis-container').scrollTo('a[name="ql-' + elId + '"]');
    });

    let updateFromDate = function(newDate) {
        currentSQGroup.fromDate = newDate;
        refreshSQMetricCharts();
    }
    let dateWidget = $('#ess-kpi-from-date-picker');
    let dateTrigger = $('#ess-kpi-from-date-picker-trigger');
    let dateDisplay = $('#ess-kpi-from-date-picker-display');
    initDatePicker(currentSQGroup?.fromDate, dateWidget, dateTrigger, dateDisplay, updateFromDate);

    let updateToDate = function(newDate) {
        currentSQGroup.toDate = newDate;
        refreshSQMetricCharts();
    }
    dateWidget = $('#ess-kpi-to-date-picker');
    dateTrigger = $('#ess-kpi-to-date-picker-trigger');
    dateDisplay = $('#ess-kpi-to-date-picker-display');
    initDatePicker(currentSQGroup?.toDate, dateWidget, dateTrigger, dateDisplay, updateToDate)
}

function refreshInstSQMetricsPanel(theSQMetrics) {

    let templateData = {
        "sqMetrics": theSQMetrics
    }

    $('#ess-kpis-container').html(sqMetricsTemplate(templateData)).promise().done(function(){
        initKPIEventListeners();
        refreshSQMetricCharts();
    });
}

function refreshSQMetricCharts() {
    currentSQMetrics?.forEach(sqm => {
        renderSQMetricChart(sqm);
    });
}

function initDatePicker(initDate, thisWidget, thisTrigger, thisDisplay, updateCallback) {

    let allowClear = false;
    
    //thisWidget.bootstrapDP({
    thisWidget.datepicker({
      format: {
          toDisplay: function (date, format, language) {
            if(date != null) {
              return moment(date).format('YYYY-MM-DD');
            } else {
              return '';
            }
          },
          toValue: function (date, format, language) {
              if(date) {
                return new Date(date);
              } else {
                return null;
              }
          }
      },
      todayHighlight: true,
      autoclose: true,
      clearBtn: allowClear,
      showOnFocus: false
    });
    //$('.datePicker').inputmask('9999-99-99');
    thisTrigger.click(function () {
        //$(this).next('.datePicker').bootstrapDP('show');
        $(this).next('.datePicker').datepicker('show');
    });

    let updateDateCallback = function(newVal) {
      if(newVal != null && newVal.length >= 10) {
        thisDisplay.val(moment(newVal).format('DD MMM YYYY'));
      } else {
        thisDisplay.val('');
      }
    }

    //thisWidget.bootstrapDP().on('hide', function (e) {
    thisWidget.datepicker().on('hide', function (e) {
      let newDate = $(this).val();
      let isoDate;
      if(newDate?.length > 0) {
        isoDate = moment(newDate).format('YYYY-MM-DD');
      }
      updateDateCallback(isoDate);
    });

    if(!initDate?.length > 0) {
        initDate = moment().format('YYYY-MM-DD');
    }
    thisWidget.val(moment(initDate).format('YYYY-MM-DD'));
    //thisWidget.bootstrapDP('setDate', new Date(initDate));
    thisWidget.datepicker('setDate', new Date(initDate));
    thisDisplay.val(moment(initDate).format('DD MMM YYYY'));
}


function renderSQMetricChart(aSQMetric) {
    console.log('GENERATING CHART FOR:', aSQMetric);
    function transparentize(color, opacity) {
        //if it has an alpha, remove it
        if (color.length > 7) {
            color = color.substring(0, color.length - 2);
        }

        // coerce values so ti is between 0 and 1.
        const _opacity = Math.round(Math.min(Math.max(opacity, 0), 1) * 255);
        let opacityHex = _opacity.toString(16).toUpperCase()

        // opacities near 0 need a trailing 0
        if (opacityHex.length == 1) {
            opacityHex = "0" + opacityHex;
        }
        return color + opacityHex;
    }

    if(aSQMetric.chart != null) {
        aSQMetric.chart.destroy();
    }

    let fromDate = currentSQGroup.fromDate;
    if(!fromDate) {
        fromDate = moment().subtract(18, 'months').format('YYYY-MM-DD');
    }
    let toDate = currentSQGroup.toDate;
    if(!toDate) {
        toDate = moment().add(18, 'months').format('YYYY-MM-DD');
    }

    //console.log('ALL TARGETS FROM ' + fromDate + ' TO ' + toDate);
    let confirmedTargetColour = '#b0a9a9'; 
    let targetData = [];
    let fullTargetColours = [];
    if(aSQMetric.targets?.length > 0) {
        let inScopeTargets = aSQMetric.targets.filter(tgt => (tgt.frmDt >= fromDate) && (tgt.frmDt <= toDate));
        //console.log('ALL TARGETS FOR ' + aSQMetric.sqDoc.lbl, aSQMetric.targets);
        let targetValProp = "chartLbl";
        if(aSQMetric.sqDoc.type?.name == 'Scalar') {
            targetValProp = "chartVal";
        }
        targetData = inScopeTargets.map(tgt => {
            return {
                "id": tgt._id?.$oid,
                "x": tgt.frmDt,
                "y": tgt[targetValProp],
                "metric": tgt
            }
        });
        fullTargetColours = inScopeTargets.map(tgt => confirmedTargetColour);
    }
    let targetColours = fullTargetColours.map(clr => transparentize(clr, 0.7),);

    
    let actualsData = [];
    let fullActualsColours = [];
    if(aSQMetric.actuals?.length > 0) {
        let inScopeActuals = aSQMetric.actuals.filter(act => (act.toDt >= fromDate) && (act.toDt <= toDate));
        let actValProp = "chartLbl";
        if(aSQMetric.sqDoc.type?.name == 'Scalar') {
            actValProp = "chartVal";
        }
        actualsData = inScopeActuals.map(act => {
            return {
                "id": act._id?.$oid,
                "x": act.toDt,
                "y": act[actValProp],
                "metric": act
            }
        });
        fullActualsColours = inScopeActuals.map(act => act.clr);
    }
    //console.log('ACTUALS DATA FOR ' + aSQMetric.sqDoc.lbl, actualsData);
    //console.log('ACTUALS COLOURS FOR ' + aSQMetric.sqDoc.lbl, fullActualsColours);

    //fullActualsColours = ['#cc3232', '#e7b416', '#2dc937'];
    let actualsColours = fullActualsColours.map(clr => transparentize(clr, 0.7),);

    //make the target line continous, if needed
    if((targetData?.length > 0)) {
        let lastDate = toDate;
        let actualsCount = actualsData.length;
        if((actualsData?.length > 0) && actualsData[actualsCount - 1].x > lastDate) {
            lastDate = actualsData[actualsCount - 1].x;
        }
    
        let targetCount = targetData.length;
        if(lastDate > targetData[targetCount - 1].x) {
            targetData.push({
                x: lastDate,
                y: targetData[targetCount - 1].y
            });
        }
    }

    let sqChartDatasets = [
        {
            label: 'Target',
            pointStyle: 'rect',
            pointRadius: 6,
            fill: false,
            borderColor: transparentize('#111111', 0.7),
            borderDash: [5, 5],
            pointHoverRadius: 9,
            data: targetData,
            pointBackgroundColor: targetColours,
            borderWidth: 1,
            spanGaps: true
        },
        {
            label: 'Actual',
            pointStyle: 'circle',
            fill: false,
            borderColor: transparentize('#0f79a3', 0.7),
            pointRadius: 6,
            pointHoverRadius: 9,
            data: actualsData,
            pointBackgroundColor: actualsColours,
            pointBorderColor: actualsColours,
            borderWidth: 1
        }
    ];

    let chartScales = {
        x: {
            type: 'time',
            time: {
                unit: 'year',
                displayFormats: {
                    year: 'YYYY'
                },
                tooltipFormat: "DD MMM YYYY"
            },
            min: fromDate,
            max: toDate
        }
    };

    switch (aSQMetric.sqDoc?.type?.name) {
        case 'Scalar':
            chartScales['y'] = {
                ticks: {
                    suggestedMin: 0
                },
                position: 'left',
                stack: 'performance',
                stackWeight: 2,
                min: 0
            }
            if(aSQMetric.sqDoc.max) {
                chartScales['y'].max = aSQMetric.sqDoc.max;
            }
            break;
            case 'Boolean':
                chartScales['y'] = {
                    type: 'category',
                    labels: aSQMetric.sqDoc.boolValues.map(bl => bl.label),
                    position: 'left',
                    stack: 'performance',
                    stackWeight: 2
                }
                break;
            case 'Enumeration':
                chartScales['y'] = {
                    type: 'category',
                    labels: aSQMetric.sqDoc.values.map(val => val.label),
                    position: 'left',
                    stack: 'performance',
                    stackWeight: 2
                }
                break;
        default:
            break;
    }

    let thisChartId = 'perf-trkg-' + aSQMetric.id + '-sqm-chart'
    let ctx = document.getElementById(thisChartId)?.getContext('2d');
    aSQMetric.chart = new Chart(ctx, {
        type: 'line',
        options: {
          scales: chartScales,
          plugins: {
            tooltip: {
                callbacks: {
                    label: function(context) {
                        //return moment(d.labels[x[0].index]).format('dd MMM DD, YYYY');
                        console.log('LABEL CONTEXT', context);
                        console.log('LABEL PERF METRIC', aSQMetric);
                        let labelString = '';
                        if(context.raw.factor) {
                            labelString = context.raw.factor.label;
                        } else {
                            labelString = context.raw?.metric?.chartVal;
                            switch (aSQMetric.sqDoc?.type?.name) {
                                case 'Scalar':
                                    let valSuffix = aSQMetric.sqDoc.uom?.abbreviation;
                                    if(!valSuffix) {
                                        valSuffix = aSQMetric.sqDoc.uom?.label;
                                    }
                                    labelString = labelString + ' ' + valSuffix;
                                    break;
                                    case 'Boolean':
                                        labelString = context.raw?.metric?.chartLbl;
                                        if(!labelString) {
                                            labelString = context.raw?.metric?.chartVal;
                                        }
                                        break;
                                    case 'Enumeration':
                                        labelString = context.raw?.metric?.chartLbl;
                                        if(!labelString) {
                                            labelString = context.raw?.metric?.chartVal;
                                        }
                                        break;
                                default:
                                    break;
                            }
                        }
                        return labelString;
                    },
                    footer: function(context) {
                        //return moment(d.labels[x[0].index]).format('dd MMM DD, YYYY');
                        //console.log('FOOTER CONTEXT', context);
                        //console.log('FOOTER PERF METRIC', aSQMetric);
                        let footerString = '';
                        if(context[0]?.raw?.factor) {
                            footerString = context[0].raw.factor.desc?.length > 0 ? context[0].raw.factor.desc : '';
                        } else {
                            switch (aSQMetric.sqDoc?.type?.name) {
                                case 'Boolean':
                                    let thisVal = context[0]?.raw?.metric?.val;
                                    let boolVal =  aSQMetric.sqDoc?.boolValues?.find(bl => bl.value == thisVal);
                                    if(boolVal?.description) {
                                        footerString = boolVal.description;
                                    }
                                    break;
                                case 'Enumeration':
                                    let enumId = context[0]?.raw?.metric?.val;
                                    let enumVal =  aSQMetric.sqDoc?.values?.find(ev => ev.id == enumId);
                                    if(enumVal?.description) {
                                        footerString = enumVal.description;
                                    }
                                    break;
                                default:
                                    break;
                            }
                        }
                        return footerString;
                    }
                }
            }
          }
        },
        data: {
            datasets: sqChartDatasets
        }
    });

    document.getElementById(thisChartId).mouseup = function(evt){
        let activePoints = aSQMetric.chart.getElementsAtEvent(evt);
        activePoints?.forEach(ap => {
            let datasetIdx = ap._datasetIndex;
            let dataIdx = ap._index;
            if((datasetIdx >= 0 && (dataIdx >= 0))) {
                let clickOnMetric = sqChartDatasets[datasetIdx]?.data[dataIdx];
                console.log('CLICK ON ACTIVE POINT:', clickOnMetric);
            }
        });
    };
}

function refreshSQMetricsData() {
    currentSQMetrics = [];
    currentSQGroup?.sqs?.forEach(sq => {
        let sqTargets = currentTargetMetrics?.filter(tgt => tgt.sqId == sq.id);
        let sqActuals = currentActualMetrics?.filter(tgt => tgt.sqId == sq.id);

        let newPerfMetric = new ServiceQualityPerformance(sq, sqTargets, sqActuals);
        
        currentSQMetrics.push(newPerfMetric);
    });
    console.log('ADDED SQ METRICS', currentSQMetrics);
    refreshInstSQMetricsPanel(currentSQMetrics);
    return currentSQMetrics;
}

function fetchInstSQMetrics(instId, callback) {
    //empty the cSQ Metrics Container
    currentSQMetrics?.forEach(sqm => {
        console.log('DESTROYING CHART', sqm);
        sqm?.chart?.destroy();
    });
    $('.ess-kpis-container').empty();
    
    let sqGroupsUrl = INSTANCE_SERVICE_QUALITY_GROUPS_URL + '?instId=' + instId;
    essPromise_getNoSQLCurrentRepoElements(sqGroupsUrl, 'KPI Groups')
    .then(function(response) {
        if(response.instances?.length > 0) {
            currentSQGroup = response.instances[0];

            let targetMetricsUrl = TARGET_METRIC_VALUES_URL + '?instId=' + instId;
            let actualMetricsUrl = ACTUAL_METRIC_VALUES_URL + '?instId=' + instId;
            Promise.all([
                essPromise_getNoSQLCurrentRepoElements(targetMetricsUrl, 'Target KPI Metrics'),
                essPromise_getNoSQLCurrentRepoElements(actualMetricsUrl, 'Actual KPI Metrics')
            ])
            .then(function(responses) {
                currentTargetMetrics = responses[0].instances;
                currentActualMetrics = responses[1].instances;
                refreshSQMetricsData();
                if(callback) {
                    callback(currentSQMetrics);
                }
            })
            .catch (function (error) {
                console.log(error);
            });
        } else {
            currentTargetMetrics = [];
            currentActualMetrics = [];
            currentSQGroup = null;
            refreshSQMetricsData();
            if(callback) {
                callback(currentSQMetrics);
            }
        }
    })
    .catch (function (error) {
        console.log(error);
    });
}

function invertColor(hex, bw) {
    if (hex.indexOf('#') === 0) {
        hex = hex.slice(1);
    }
    // convert 3-digit hex to 6-digits.
    if (hex.length === 3) {
        hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }
    if (hex.length !== 6) {
        throw new Error('Invalid HEX color.');
    }
    var r = parseInt(hex.slice(0, 2), 16),
        g = parseInt(hex.slice(2, 4), 16),
        b = parseInt(hex.slice(4, 6), 16);
    if (bw) {
        // https://stackoverflow.com/a/3943023/112731
        return (r * 0.299 + g * 0.587 + b * 0.114) > 186
            ? '#000000'
            : '#FFFFFF';
    }
    // invert color components
    r = (255 - r).toString(16);
    g = (255 - g).toString(16);
    b = (255 - b).toString(16);
    // pad each with zeros and return
    return "#" + padZero(r) + padZero(g) + padZero(b);
  }