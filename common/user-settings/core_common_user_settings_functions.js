/***************************************
* INSTANCE SETTINGS FUNCTIONS
/***************************************/

const ESS_LOCAL_INSTANCE_SETTINGS_KEY = 'ESSENTIAL_USER_SETTINGS.INSTANCE_SETTINGS';

/* INSTANCE SETTINGS */
function essGetLocalEssentialInstanceSettings(className) {
    let instanceSettingsKey = ESS_LOCAL_INSTANCE_SETTINGS_KEY + '.' + essUserSettingsRepoId + '.' + className;
    let instanceSettingsString = localStorage.getItem(instanceSettingsKey);
    let instanceSettings;
    if(!instanceSettingsString) {
        instanceSettings = {};
        instanceSettingsString = JSON.stringify(instanceSettings);
        localStorage.setItem(instanceSettingsKey, instanceSettingsString);         
    } else {       
        try {
            instanceSettings = JSON.parse(instanceSettingsString);
        }
        catch(e) {
            console.log('Exception when loading instance settings for ' + className + '  class');
            console.log(e);
        }
    }
    return instanceSettings;
}


function essSaveLocalEssentialInstanceSettings(className, settings) {
    let instanceSettingsKey = ESS_LOCAL_INSTANCE_SETTINGS_KEY + '.' + essUserSettingsRepoId + '.' + className;
    if(settings != null) {
        let settingsString = JSON.stringify(settings);
        localStorage.setItem(instanceSettingsKey, settingsString);         
    }
    return settings;
}


/****************************************
 * VIEW SCOPING SETTINGS VARIABLES AND FUNCTIONS
 ***************************************/

const ESS_LOCAL_VIEW_SCOPE_SETTINGS_KEY = 'ESSENTIAL_USER_SETTINGS.VIEW_SCOPE_SETTINGS';

var essUserScopeSettings;
var essUserScope=[];
var essScopingLists;
var essCurrentScopingCat;
var essScopingDDTemplate, essScopeValuesTemplate, essRMTableRowSelectTemplate, essRMTableNameTemplate, essRMTableTypeTemplate, essRMTableChangeTemplate, essRMTableListTemplate;

const essViewScopeParam = 'essscope';


//variable holding the callback function whenever the scope is updated
var essRefreshScopeCallback;

var scopeInitialised = false;

 //Class that represents the pairing of a resource property with a scoping meta-class
class ScopingProperty {
    constructor(property, metaClass) {
      this.property = property;
      this.metaClass = metaClass;
    }
}
  
//Class that represents the results of scoping a list of resources in terms of a list of resources and a list of their ids
class ResourceScope {
    constructor(resources) {
      this.resources = resources;
      this.resourceIds = resources.map(res => res.id);
    }
}

//Class that represents a scping value
class ScopingValue {
    constructor(category, value, isExcludes) {

        this.id = value.id;
        this.name = value.name; 
        if(category.name.length > 24){
            this.category = category.name.replace(/\b(\S{1,6})\S*/g, '$1').replace(/ /g, '.. ');
        }else
        {
        this.category = category.name;
        }
        this.icon = category.icon;
        this.color = category.color;
        this.valueClass = category.valueClass;
        this.isGroup = category.isGroup;
        if(category.isGroup) {
            this.group = value.group;
        }
        this.isExcludes = isExcludes;
    }
}

var essFilterClassList = [];

var essDynamicFilterList = [];
var essFilterLabelList = '';
var essRMApiData = {};
var essRoadmapEnabled = false;
var essRMEndDate = moment().format('yyyy-mm-dd');

const CHANGE_TYPE_INFO = [
    {
        "name": "Creation Change",
        "icon": "fa-arrow-right",
        "colour": "#4f8956"
    },
    {
        "name": "Enhancement Change",
        "icon": "fa-arrow-up",
        "colour": "#4f8956"
    },
    {
        "name": "Reduction Change",
        "icon": "fa-arrow-down",
        "colour": "#e3a131"
    },
    {
        "name": "Removal Change",
        "icon": "fa-times",
        "colour": "#ba2401"
    }
];

class PlannedChange {
    constructor(aChange, inScopeInstances, typeInfo) {
        let allStratPlans = essRMApiData.rpp.strategicPlans;
        let allChangeActivities = essRMApiData.rpp.changeActivities;
        let allRoadmaps = essRMApiData.rpp.roadmaps;
        let allPlanningActions = essRMApiData.rpp.planningActions;


        this.id = aChange.id;
        this.icon = typeInfo?.icon;
        this.instance = inScopeInstances.find(inst => inst.id == aChange?.instId);
        if(!this.instance.type) {
            this.instance.type = typeInfo?.label;
        }
        this.instance.icon = typeInfo?.icon;
        this.strategicPlan = allStratPlans.find(sp => sp.id == aChange?.planId);
        this.planningAction = allPlanningActions.find(pa => pa.id == aChange?.actionId);
        if(this.planningAction?.changeType) {
            let changeType = this.planningAction.changeType;
            let changeInfo = CHANGE_TYPE_INFO.find(chgInfo => chgInfo.name == changeType);
            this.planningAction.icon = changeInfo?.icon;
            this.planningAction.colour = changeInfo?.colour;
        }
        this.changeActivity = allChangeActivities.find(ca => ca.id == aChange?.changeActivityId);
        this.roadmaps = allRoadmaps.filter(rm => aChange?.roadmapIds.indexOf(rm.id) >= 0);
    }
}

//Function call by Views/Editors to initialise the scoping capability and then call the callback function
function essInitViewScoping(callback, initfilterClassList,  dynamicFilters, isRMEnabled) {
   // console.log('initfilterClassList',initfilterClassList)
    // console.log('isRMEnabled',isRMEnabled)
    scopeInitialised = true;
    if(!isRMEnabled){
        isRMEnabled = false;
    }
    
    if((!essPlannedChangesAPIURL.length > 0) || (!essRoadmapsPlansProjectsAPIURL.length > 0)) {
        isRMEnabled = false;
    }

    if(isRMEnabled) {
        rmInitDates();
        essRoadmapEnabled = isRMEnabled;
    } else {
        essRoadmapEnabled = false;
        // Hide the Roadmap filtering section
        $('#roadmap-filter-wrapper').hide();
        /* $('#rmEnabledCheckbox').prop('checked', false);
        $('#rmEnabledCheckbox').prop('disabled', true);
        $('#rmWidgetEndDateSelect').prop('disabled', true);
        //$('#rmWidgetEndDateSelect').MonthPicker('Disable');
        // Update the Roadmap Widget Button
        $('#rm-button-active').hide();
        $('#rm-button-inactive').show();
        $('#playRoadmap').addClass('rm-btn-disabled');
        $('#pauseRoadmap').addClass('rm-btn-disabled');
        $('#resetRoadmap').addClass('rm-btn-disabled'); */
    }
   // console.log('essRoadmapEnabled',essRoadmapEnabled)
    if(initfilterClassList) {
        essFilterClassList = initfilterClassList;
    }

    if(dynamicFilters) {
        essDynamicFilterList = dynamicFilters;
    }
    
    //call the callback to refresh the view/editor
    //essRefreshScopeCallback();

    let hbFragment = $("#ess-scope-dropdown-list-template").html();
    essScopingDDTemplate = Handlebars.compile(hbFragment);

    hbFragment = $("#ess-scoping-value-template").html();
    essScopeValuesTemplate = Handlebars.compile(hbFragment);

    hbFragment = $("#ess-rm-table-row-selection-template").html();
    essRMTableRowSelectTemplate = Handlebars.compile(hbFragment);

    hbFragment = $("#ess-rm-table-instance-name-template").html();
    essRMTableNameTemplate = Handlebars.compile(hbFragment);
    
    hbFragment = $("#ess-rm-table-instance-type-template").html();
    essRMTableTypeTemplate = Handlebars.compile(hbFragment);
    
    hbFragment = $("#ess-rm-table-planned-change-template").html();
    essRMTableChangeTemplate = Handlebars.compile(hbFragment);
    
    hbFragment = $("#ess-rm-table-instance-list-template").html();
    essRMTableListTemplate = Handlebars.compile(hbFragment);

    $('#ess-scoping-category-list').select2({
        placeholder: "Select a scoping category",
        theme: "bootstrap"
    });

    $('#ess-scoping-value-list').select2({
        theme: "bootstrap"
    });

    essRefreshScopeCallback = callback;
    
    //Get the scoping lists from local storage for the current repo
    //Check the view url for a url parameter
    essUserScopeSettings = getLocalEssentialScopeSettings();  
    if(essWindowParams.has(essViewScopeParam)) {
        let scopeStringVal = essWindowParams.get(essViewScopeParam);
        essUserScopeSettings.userScope = essDeserializeUrlParam(scopeStringVal);   
        essUpdateUserSettings();
    }
    essUserScope = essUserScopeSettings.userScope;
    

    //if the timestamp is earlier than the latest publish, call the common scoping API and replace local storage scoping lists
    if(essUserScopeSettings.timestamp && essUserScopeSettings.timestamp >= essUserSettingsPublishTimestamp) {
     //   console.log('Found local scoping lists');
        //If roadmap enablement is enabled, initalise the capability
        if(essRoadmapEnabled) {
            Promise.all([
                promise_loadViewerAPIScopeData(essPlannedChangesAPIURL),
                promise_loadViewerAPIScopeData(essScopeViewAPIURL),
                promise_loadViewerAPIScopeData(essRoadmapsPlansProjectsAPIURL)
            ])
            .then(function(responses) {    
                essRMApiData.plans = responses[0].plans;
                essRMApiData.rpp = responses[2];
                //onGotLayers();
                essScopingLists = essUserScopeSettings.scopingLists;
              // console.log('ess1', essScopingLists)
                essSetScopingDropdowns();
                essRefreshScopingValues();
                initRoadmapEnUI();
            });
        } else {
            essScopingLists = essUserScopeSettings.scopingLists;
           // console.log('ess2', essScopingLists)
            essSetScopingDropdowns();
            essRefreshScopingValues();
        }
    } else {
     //   console.log('Getting new scoping lists');
        //call the common scoping API and replace local storage scoping lists
        let initFilterPromises = [promise_loadViewerAPIScopeData(essScopeViewAPIURL)];
        if(essRoadmapEnabled) {
            //console.log('essRoadmapEnabled', essRoadmapEnabled)
            initFilterPromises.push(promise_loadViewerAPIScopeData(essPlannedChangesAPIURL));
            initFilterPromises.push(promise_loadViewerAPIScopeData(essRoadmapsPlansProjectsAPIURL));
          //  initFilterPromises.push(promise_loadViewerAPIScopeData(essScopeViewAPIURL));
        }
        Promise.all(initFilterPromises)
        .then(function(responses) {    
         //   console.log('Init Responses', responses);
            //If roadmap enablement is enabled, initalise the capability
            if(essRoadmapEnabled) {
                essRMApiData.plans = responses[1].plans;
                essRMApiData.rpp = responses[2];

                initRoadmapEnUI();
            }
            essUserScopeSettings.scopingLists = responses[0].scopingLists;
            essScopingLists = essUserScopeSettings.scopingLists;
            // console.log('Returned scoping list:');
            // console.log(essScopingLists);

            //save local scoping data with updated timestamp
            essUserScopeSettings.timestamp = essUserSettingsPublishTimestamp;
            essUpdateUserSettings();
            essSetScopingDropdowns();
            essRefreshScopingValues();
        });
    }
 
}

function essIsViewScopingReady() {
    return scopeInitialised;
}

// Function to populate the scoping category drop down list with nothing selected (first dropsown is enabled)
function essSetScopingDropdowns() {
    //console.log('essScopingLists',essScopingLists)
    if(essScopingLists && essScopingLists.length > 0) {
        //add the list of filters dynamically provided by the containing view
        essDynamicFilterList?.forEach(flt => {
            if(flt.valueClass && essFilterClassList.indexOf(flt.valueClass) < 0) {
                essFilterClassList.push(flt.valueClass);
                essScopingLists.push(flt);
            }
        });

        let inScopeList = essScopingLists;
        if(essFilterClassList.length > 0) {
            inScopeList = essScopingLists.filter(scope => essFilterClassList.indexOf(scope.valueClass) >= 0);
        }

        inScopeList.forEach(function(scope,idx){
            if(idx > 0) {
                essFilterLabelList = essFilterLabelList + ', ';
            }
            essFilterLabelList = essFilterLabelList + scope.name;
        }); 
        $('#ess-filter-scope-summary').text(essFilterLabelList);
 
        $('#ess-scoping-category-list').html(essScopingDDTemplate(inScopeList));
        $('#ess-scoping-category-list').prop('disabled', false);
        
        //add the scoping event listeners
        addScopingEventListeners();
    }
}

// Function to add a scoping filter
//PARAMS:
//@thisCatId = typically the class of the type of filter to be applied
//@selectedValId = the string value ID of the instance to be used as a filter
//@isExcludeFilter = boolean defining whether the filter is to be applied as an exclusion (default is false)
function essAddFilter(thisCatId, selectedValId, isExcludeFilter) {
    //console.log(thisCatId+":"+selectedValId +":")
    //console.log(essScopingLists);
    let scopingCat = essScopingLists.find(cat => cat.id == thisCatId);
    let valObj = scopingCat?.values.find(val => val.id == selectedValId);
    if(valObj != null) {
        let newScopingObj = new ScopingValue(scopingCat, valObj, (isExcludeFilter == true));
        essUserScope.push(newScopingObj);
        essSetScopeButtonStatuses();
        essRefreshScopingValues();
    }
}

// Function to add a scoping filter
//PARAMS:
//@thisValId = the id of the filter value to remove
function essRemoveFilter(thisValId) {
    if(thisValId) {
        let thisVal = essUserScope.find(aVal => aVal.id == thisValId);
        if(thisVal) {
            let valIdx = essUserScope.indexOf(thisVal);
            essUserScope.splice(valIdx, 1);
            essSetScopeButtonStatuses();
            essRefreshScopingValues();
        }
    }
}

function essGetScope(){
    return essUserScope
}

// Function to add the scoping event listeners
function addScopingEventListeners() {
    $('#ess-scoping-category-list').on('change', function(event) {
        let thisCatId = $(this).val();
        if(thisCatId != null) {
            essCurrentScopingCat = essScopingLists.find(cat => cat.id == thisCatId);
            if(essCurrentScopingCat != null) {
                $('#ess-scoping-value-list').select2({
                    placeholder: 'Select a ' + essCurrentScopingCat.name
                });
                $('#ess-scope-value-label').text(essCurrentScopingCat.name);
                $('#ess-scoping-value-list').html(essScopingDDTemplate(essCurrentScopingCat.values)).promise().done(function(){
                    essSetScopeButtonStatuses();
                });
                $('#ess-scoping-value-list').prop('disabled', false);
            }
        }
    });
    
    $('#ess-scoping-value-list').on('change', function(event) {
        essSetScopeButtonStatuses();
    });
    
    $('#ess-add-scoping-value-btn').off().on('click', function(event) {
        
        let selectedValId = $('#ess-scoping-value-list').val();
        if(essCurrentScopingCat != null) {
            let valObj = essCurrentScopingCat.values.find(val => val.id == selectedValId);
            if(valObj != null) {
                let newScopingObj = new ScopingValue(essCurrentScopingCat, valObj, false);
                essUserScope.push(newScopingObj);
                essSetScopeButtonStatuses();
                essRefreshScopingValues();
            }
        }
    });

    $('#ess-add-exl-scoping-value-btn').off().on('click', function(event) {
        
        let selectedValId = $('#ess-scoping-value-list').val();
        if(essCurrentScopingCat != null) {
            let valObj = essCurrentScopingCat.values.find(val => val.id == selectedValId);
            if(valObj != null) {
                let newScopingObj = new ScopingValue(essCurrentScopingCat, valObj, true);
                essUserScope.push(newScopingObj);
                essSetScopeButtonStatuses();
                essRefreshScopingValues();
            }
        }
    });
    
}

function essSetScopeButtonStatuses() {
    let selectedVal = $('#ess-scoping-value-list').val();
    if(selectedVal != null) {
        let userScopeIds = essUserScope.map(val => val.id);
        if(!userScopeIds.includes(selectedVal)) {
            $('#ess-add-scoping-value-btn').prop('disabled', false);
            $('#ess-add-exl-scoping-value-btn').prop('disabled', false);
        } else {
            $('#ess-add-scoping-value-btn').prop('disabled', true);
            $('#ess-add-exl-scoping-value-btn').prop('disabled', true);
        }
    } else {
        $('#ess-add-scoping-value-btn').prop('disabled', true);
        $('#ess-add-exl-scoping-value-btn').prop('disabled', true);
    }
}

function essRefreshScopingValues() {
    var scopeCount = essUserScope.length;
    $('#scope-filter-count').text(scopeCount);
    $('#ess-scoping-scope').html(essScopeValuesTemplate(essUserScope)).promise().done(function(){
        $('.ess-remove-scope-btn').on('click', function(event) {
            let thisValId = $(this).attr('eas-id');
            if(thisValId) {
                let thisVal = essUserScope.find(aVal => aVal.id == thisValId);
                if(thisVal) {
                    let valIdx = essUserScope.indexOf(thisVal);
                    essUserScope.splice(valIdx, 1);
                    essSetScopeButtonStatuses();
                    essRefreshScopingValues();
                }
            }
        });
    });
    //set the summary text
    essRefreshScopeSummary();
    //save the new scope
    essUpdateUserSettings();
    //call the callback function to refresh the view/editor
    essRefreshScopeCallback();
} 


function essRefreshScopeSummary() {

    let summaryString = '';
    if(essUserScope.length > 0) {
        essUserScope.forEach(function(aVal, idx) {
            let operand = '';
            if(idx > 0) {
                summaryString = summaryString + ', ';
            }
            if(aVal.isExcludes) {
                summaryString = summaryString + 'NOT ';
            }
            summaryString = summaryString + aVal.name + ' (' + aVal.category + ')';
        });
    } else {
        summaryString = 'All';
    }
    $('#ess-scope-summary').text(summaryString);
}


//function to retrieve the current list of scoping objects of a given class - including flattening scoping groups - returns a Set object containing id values
function essGetScopeForMetaClass(aClass) {
    let scopeForMetaClass = {};
    let includesScopeForClass = essUserScope.filter(scope => scope.valueClass == aClass && !scope.isExcludes);
    let includesScopeValues = [];

    includesScopeForClass.forEach(function(scopeVal) {
        
        if(scopeVal.isGroup) {
            includesScopeValues=includesScopeValues.concat(scopeVal.group);
        } else {
            includesScopeValues.push(scopeVal);
        }
    });
 
    if(includesScopeValues.length > 0) {
        let includesScopeValueIds = includesScopeValues.map(val => val.id); 
        scopeForMetaClass['includes'] = new Set(includesScopeValueIds);
    } else {
        scopeForMetaClass['includes'] =  null;
    } 


    let excludesScopeForClass = essUserScope.filter(scope => scope.valueClass == aClass && scope.isExcludes);
    let excludesScopeValues = [];
    excludesScopeForClass.forEach(function(scopeVal) {
        if(scopeVal.isGroup) {
            excludesScopeValues=excludesScopeValues.concat(scopeVal.group);
        } else {
            excludesScopeValues.push(scopeVal);
        }
    });
    if(excludesScopeValues.length > 0) { 
        let excludesScopeValueIds = excludesScopeValues.map(val => val.id);
        scopeForMetaClass['excludes'] = new Set(excludesScopeValueIds);
    } else {
        scopeForMetaClass['excludes'] =  null;
    } 
 
    return scopeForMetaClass;
}


//function to filter a given list of resources against the given scope
//Assumes that each resource has a property containing a list of essential instance ids (e.g. Group_Actor ids)
 
function essFilterResources(scopedResources, scopeForProperty, scopingProperty) {
    let filteredResources = scopedResources.filter(function(aRes) {
        let inScope = true;
        let isIncludeInScope = true;
 //console.log('aRes',aRes)
/*
function essFilterResources(scopedResources, scopeForProperty, scopingProperty) {
    return scopedResources.filter(function(aRes) {
        let isIncludeInScope = true;
*/
let resScope

if(!Array.isArray(aRes[scopingProperty])){
    resScope= new Set([aRes[scopingProperty].id]);
}else{
    resScope= new Set(aRes[scopingProperty]);
}  

        if(scopeForProperty.includes) {
     
            //let intersection = new Set([...scopeForProperty.includes].filter(scopeValue => resScope.has(scopeValue)));
            //isIncludeInScope = intersection.size > 0;
            let intersection = [...scopeForProperty.includes].map(scopeValue => resScope.has(scopeValue));
            //console.log('Includes Intersection',intersection);
            isIncludeInScope = intersection.includes(true);
        }
            
        let isExcludeInScope = true;
        if(scopeForProperty.excludes) {
            //let intersection = new Set([...scopeForProperty.excludes].filter(scopeValue => !resScope.has(scopeValue)));
            //isExcludeInScope = intersection.size > 0;
            let intersection = [...scopeForProperty.excludes].map(scopeValue => resScope.has(scopeValue));
            //console.log('Excludes Intersection',intersection);
            isExcludeInScope = !intersection.includes(true);
        }

        //console.log('Applying Filter for ' + scopingProperty + ' on instance: ' + aRes.name, aRes);
        //console.log('In Scope for Exclude?', isExcludeInScope);
        //console.log('In Scope for Include?', isIncludeInScope);
        return isIncludeInScope && isExcludeInScope;
    });
   // console.log('filteredResources',filteredResources)
    return filteredResources;
}

function essResetRMChanges() {
    essRMInScopeChanges = [];
}

//Main function called by Views/Editor to filter a given list of resources based on the provided property to meta-class pairings
function essScopeResources(resourceList, scopingPropertyList, typeInfo) {

    let scopedResources = resourceList;

    if(essRoadmapEnabled) {
        let rmChangesEndDate = moment().format('YYYY-MM-DD');
        scopedResources = easTimeMachine.getRMInstances(scopedResources, typeInfo);
     
        //return filteredResources;
    }

    scopingPropertyList.forEach(function(aSP) {
        let scopeForProperty = essGetScopeForMetaClass(aSP.metaClass);
        if(scopeForProperty.includes || scopeForProperty.excludes) {
            scopedResources = essFilterResources(scopedResources, scopeForProperty, aSP.property);
        }        
    });
    return new ResourceScope(scopedResources);
}


//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data   
var promise_loadViewerAPIScopeData = function(dataSetURL) {   
    return new Promise(function (resolve, reject) {
      //  console.log('Loading Scoping Lists');
        if (dataSetURL != null) {
            let xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    let viewerData = JSON.parse(this.responseText);
                 //   console.log(viewerData);
                    resolve(viewerData);
                }
            };
            xmlhttp.onerror = function (e) {
                console.log('Error loading reference data');
                reject(false);
            };
            xmlhttp.open("GET", dataSetURL, true);
            xmlhttp.send();
        } else {
            console.log('Data set not found');
            reject(false);
        }                
    });
};

function getLocalEssentialScopeSettings() {
    let scopeSettingsKey = ESS_LOCAL_VIEW_SCOPE_SETTINGS_KEY + '.' + essUserSettingsRepoId;
    let scopeSettingsString = localStorage.getItem(scopeSettingsKey);
    let scopeSettings;
    if(!scopeSettingsString) {
        scopeSettings = {
            "userScope": []
        };
        // scopeSettingsString = JSON.stringify(scopeSettings);
        // localStorage.setItem(scopeSettingsKey, scopeSettingsString);         
    } else {       
        try {
            scopeSettings = JSON.parse(scopeSettingsString);
        }
        catch(e) {
            console.log('Exception when loading scope settings');
            console.log(e);
        }
    }
    return scopeSettings;
}


function saveLocalEssentialScopeSettings(scopeSettings) {
    let scopeSettingsKey = ESS_LOCAL_VIEW_SCOPE_SETTINGS_KEY + '.' + essUserSettingsRepoId;
    if(scopeSettings != null) {
        let settingsString = JSON.stringify(scopeSettings);
        localStorage.setItem(scopeSettingsKey, settingsString);         
    }
    return scopeSettings;
}


/****************************************
 * VIEW STATE SETTINGS FUNCTIONS
 ***************************************/

const ESS_LOCAL_VIEW_STATE_SETTINGS_KEY = 'ESSENTIAL_USER_SETTINGS.VIEW_STATE_SETTINGS';

const essWindowParams = new URLSearchParams(window.location.search);
const essViewStateParam = 'essstate';
const essViewId = essWindowParams.get('XSL');

var essCurrentViewState;

//window.onpopstate = essRevertViewState;

function essInitViewState(stateObj, defaultViewState) {

    essCurrentViewState = stateObj;
    let stateVal;
    let thisState;
    

    //Check the view url for a url parameter
    if(essWindowParams.has(essViewStateParam)) {
        stateVal = essWindowParams.get(essViewStateParam);
        thisState = essDeserializeUrlParam(stateVal);
    } else {
        //if the url parameter is empty, see if there is anything in local storage
        thisState = essGetLocalEssentialViewState(essUserSettingsRepoId);
    }

    //if a state value was found, deserialize it into a JSON object
    if(!thisState) {
        thisState = defaultViewState;
    }

    essCurrentViewState['state'] = thisState;
    essUpdateUserSettings();
    //return thisState;
}


function essGetLocalEssentialViewState() {
    let viewStateKey = ESS_LOCAL_VIEW_STATE_SETTINGS_KEY + '.' + essUserSettingsRepoId + '.' + essViewId;
    let viewStateString = localStorage.getItem(viewStateKey);
    //console.log('Locally stored encoded state: ' + viewStateString);
    let viewState;
    if(viewStateString) {     
        try {
            viewState = JSON.parse(viewStateString);
        }
        catch(e) {
            console.log('Exception when loading scope settings');
            console.log(e);
        }
    }
    return viewState;
}


function essSaveLocalEssentialViewState(viewState) {
    let viewStateKey = ESS_LOCAL_VIEW_STATE_SETTINGS_KEY + '.' + essUserSettingsRepoId + '.' + essViewId;
    if(viewState != null) {
     //   console.log('Saving View State');
     //   console.log(viewState);
        let settingsString = JSON.stringify(viewState);
        localStorage.setItem(viewStateKey, settingsString);         
    }
    return viewState;
}

/****************************************
 * COMMON FUNCTIONS
 ***************************************/

function essUpdateUserSettings() {
    if(essUserSettingsRepoId) {
        let newURL = essGeneratePageLink();
        let newState = {};

        // if defined, set the state parameter to the current url
        if(essCurrentViewState) {
            newState['viewState'] = essCurrentViewState.state;
            essSaveLocalEssentialViewState(essCurrentViewState.state);
        }

        // if defined, set the scope parameter to the current url
        if(essUserScopeSettings && essUserScope) {
            newState['viewScope'] = essUserScope;
            newState['timestamp'] = essUserSettingsPublishTimestamp;
            saveLocalEssentialScopeSettings(essUserScopeSettings);
        }

        history.replaceState(newState, null, newURL);
    }
}


function essRevertViewState(e) {
    // page reload
    if(e.state) {
        if(e.state.viewState) {
            essCurrentViewState.state = e.state.viewState;
            essSaveLocalEssentialViewState(essCurrentViewState.state);
        }

        if(e.state.viewScope && essUserScopeSettings) {
            essUserScope = e.state.viewScope;
            essUserScopeSettings.userScope = essUserScope;
            if(e.state.timestamp) {
                essUserScopeSettings.timestamp = timestamp;
            }
            saveLocalEssentialScopeSettings(essUserScopeSettings);
        }

        
    } else {
        console.log('No State Found');
        console.log(e.state);
    }
}

function essGeneratePageLink() {
    let url = new URL(location.href);
    let search_params = url.searchParams;

    // if defined, set the state parameter to the current url
    if(essCurrentViewState) {
        let currentState = essCurrentViewState.state;
        search_params.set(essViewStateParam, essSerializeUrlParam(currentState));
    }

    // if defined, set the scope parameter to the current url
    if(essUserScope) {
        search_params.set(essViewScopeParam, essSerializeUrlParam(essUserScope));
    }

    // change the search property of the main url
    url.search = search_params.toString();

    // return the new url string
    return url.toString();
}


// helper function to turn an object into a base64 encoded string
function essSerializeUrlParam(data) {
    let jsonStr = JSON.stringify(data);
    return encodeURIComponent(btoa(jsonStr));
}

// helper function to turn a base64 encoded string back into an object
function essDeserializeUrlParam(string) {
    try {
        let jsonStr = atob(decodeURIComponent(string));
        return JSON.parse(jsonStr);
    } catch (err) {
        console.error('Invalid value could not be deserialised!', err);
        return undefined;
    }
}

function essSortByField(field) {
    return function (a, b) {
        let aField = a;
        let bField = b;
        if (Array.isArray(field)) {
            field.forEach(f => {
                aField = aField[f];
                bField = bField[f];
            })
        } else {
            aField = aField[field];
            bField = bField[field];
        }
        if (a[field] < b[field]) {
            return -1;
        }
        if (b[field] > a[field]) {
            return 1;
        }
        return 0;
    };
}

//function to copy the url for the current instance

function closeSharePopover(){
	$('#shareLink').popover('hide');
    $('#shareLink').on('hidden.bs.popover', function (e) {
	    $(e.target).data("bs.popover").inState.click = false;
	});
}

function essCopyPageLink() {
    $('.btn#ess-copy-page-link > span').text('Copied!');
    setTimeout(closeSharePopover,1000);
    setTimeout(essRevertCopyButton,1500);
    
    let dummy = document.createElement('input');  
    let newURL = window.location.href;
    
    document.body.appendChild(dummy);
    dummy.value = newURL;
    dummy.select();
    //dummy.setSelectionRange(0, 99999); /* For mobile devices */
    document.execCommand('copy');
    document.body.removeChild(dummy);
}

function essRevertCopyButton(){
    $('#ess-copy-page-link > span').text('Copy');
};

/****************************************
 * ROADMAP ENABLEMENT FUNCTIONS
 ***************************************/

var essRMInScopeChanges = [];

 function getSelectValues(select) {
    var result = [];
    var options = select && select.options;
    var opt;
  
    for (var i=0, iLen=options.length; i<iLen; i++) {
      opt = options[i];
  
      if (opt.selected) {
        result.push(opt.value || opt.text);
      }
    }
    return result;
  }


function easTimeMachineAddToFilteredInstances(filteredInstances,inScopeLayerName,inScopeInstanceType,inScopeInstance){
    //first find the layer, add if not there
    var layer,instances,found=false;
    for(var i=0;i<filteredInstances.length;i++){
        var layer=filteredInstances[i];
        if(layer.layer===inScopeLayerName){
            found=true;
            break;
        }
    }
    if(found===false){
        layer={
            layer:inScopeLayerName,
            instances:{}
        };
        filteredInstances.push(layer);
    }
    //now find the instance type
    found=false;
    for(var instanceType in layer.instances){
        if(instanceType===inScopeInstanceType){
            found=true;
            instances=layer.instances[instanceType];
            break;
        }
    }
    if(found===false){
        layer.instances[inScopeInstanceType]=[];
        instances=layer.instances[inScopeInstanceType];
    }
    //now see if the instance has already been added
    found=false;
    for(var i=0;i<instances.length;i++){
        var instance=instances[i];
        if(instance.id===inScopeInstance.id){
            found=true;
            break;
        }
    }
    if(found===false){
        instances.push(inScopeInstance);
    }
    return filteredInstances;
}

function easTimeMachineRemoveFromFilteredInstances(filteredInstances,inScopeLayer,inScopeInstanceType,inScopeInstance){
    for(var i=0;i<filteredInstances.length;i++){
        var layer=filteredInstances[i];
        if(layer.layer===inScopeLayer){
            for(var instanceType in layer.instances){
                if(instanceType===inScopeInstanceType){
                    var instances=layer.instances[instanceType];
                    for(var j=0;j<instances.length;j++){
                        var instance=instances[j];
                        if(instance.id===inScopeInstance.id){
                            instances.splice(j,1);
                            j--;
                        }
                    }
                }
            }
        }
    }
    return filteredInstances;
}

function easTimeMachineAddMissingAdds(layers){
    //first pass of the planned actions look for REMOVEs/ENHANCEs that have no ADD before them and insert an ADD for 1970-01-01
    for(var i=0;i<layers.length;i++){
        var layer=layers[i];
        for(var instanceType in layer.plannedActions){
            var instanceActions=layer.plannedActions[instanceType];
            var instIdsAdded={};
            for(var j=0;j<instanceActions.length;j++){
                var action=instanceActions[j];
                switch(action.actionType){
                    case 'Enhancement Change':
                    case 'Removal Change':
                        if(instIdsAdded[action.instId]!==true){
                            var newAction={};
                            for(var field in action){
                                newAction[field]=action[field];
                            }
                            newAction.end='1970-01-01';
                            newAction.actionType='Creation Change';
                            instanceActions.unshift(newAction);
                            instIdsAdded[action.instId]=true;
                        }
                        break;
                    default:
                        instIdsAdded[action.instId]=true;
                        break;
                }
            }
        }
    }
    return layers;
}

function easTimeMachineApplyAction(filteredInstances,rmMonthStop,action,inScopeLayer,inScopeInstanceType,inScopeInstance){
    if(action.instId===inScopeInstance.id){
        if(rmMonthStop.localeCompare(action.end)>=0){
            switch(action.actionType){
                case 'Creation Change':
                    filteredInstances=easTimeMachineAddToFilteredInstances(filteredInstances,inScopeLayer,inScopeInstanceType,inScopeInstance);
                    break;
                case 'Removal Change':
                    filteredInstances=easTimeMachineRemoveFromFilteredInstances(filteredInstances,inScopeLayer,inScopeInstanceType,inScopeInstance);
                    break;
            }
        }
    }
    return filteredInstances;
}

function easTimeMachineApplyPlan(filteredInstances,roadmaps,plans,projects,rmMonthStop,layer,inScopeInstanceType,inScopeInstance){
    for(var instanceType in layer.plannedActions){
        if(instanceType===inScopeInstanceType){
            var instanceActions=layer.plannedActions[instanceType];
            for(var h=0;h<instanceActions.length;h++){
                var action=instanceActions[h];
                var actionRoadmapIds=action.roadmapId.split(' ');
                var found=false;
                for(var i=0;i<actionRoadmapIds.length;i++){
                    if(roadmaps.includes(actionRoadmapIds[i])){
                        found=true;
                        break;
                    }
                }
                if(roadmaps.length===0 || found===true){
                    //now do the same for plans
                    if(plans.length===0 || plans.includes(action.planId)){
                        //now do the same for projects
                        if(projects.length===0 || action.changeActivityId.length===0 || projects.includes(action.changeActivityId)){
                            filteredInstances=easTimeMachineApplyAction(filteredInstances,rmMonthStop,action,layer.layer,inScopeInstanceType,inScopeInstance);
                        }
                    }
                }
            }
        }
    }
    return filteredInstances;
}


//function to initialise the start and end dates
function rmInitDates() {
    let today = new Date();
    let y = today.getFullYear(), m = new Date().getMonth();

    let initEndDate  = new Date(y, m + 1, 0);
    essRMEndDate = moment(initEndDate).format('YYYY-MM-DD');
    $('#rm-button-end-date').text(moment(essRMEndDate).format('M YYYY'));
}

function initRoadmapEnUI() {
  //  console.log('ROADMAP REF DATA:', essRMApiData);

    $('#playRoadmap').on('click', function(evt) {
        //start roadmap animation
        startRoadmapAnimation();
        $('#playRoadmap').prop('disabled', true);
        $('#playRoadmap').addClass('rm-btn-disabled');

        $('#pauseRoadmap').prop('disabled', false);
        $('#pauseRoadmap').removeClass('rm-btn-disabled');

        $('#resetRoadmap').prop('disabled', false);
        $('#resetRoadmap').removeClass('rm-btn-disabled');
    });
    
    $('#pauseRoadmap').on('click', function(evt) {
        //pause roadmap animation
        endRoadmapAnimation();
        $('#playRoadmap').prop('disabled', false);
        $('#playRoadmap').removeClass('rm-btn-disabled');

        $('#pauseRoadmap').prop('disabled', true);
        $('#pauseRoadmap').addClass('rm-btn-disabled');
    });
    
    $('#resetRoadmap').on('click', function(evt) {
        //reset the roadmap
        resetRoadmapAnimation();
        $('#playRoadmap').prop('disabled', false);
        $('#playRoadmap').removeClass('rm-btn-disabled');

        $('#pauseRoadmap').prop('disabled', true);
        $('#pauseRoadmap').addClass('rm-btn-disabled');

        $('#resetRoadmap').prop('disabled', true);
        $('#resetRoadmap').addClass('rm-btn-disabled');
    });
    
    
    
    $('#rmActiveButton').on('click', function(evt){
        if ($(this).hasClass("rmActive")){
           // console.log('Roadmap Inactive');          
            essRoadmapEnabled = false;
            $(this).removeClass('btn-success');
            $(this).addClass('btn-danger');
            $(this).removeClass('rmActive');
            $(this).text('Inactive');
            $('#rmWidgetEndDateSelect').MonthPicker('Disable');
            $('#playRoadmap').addClass('rm-btn-disabled');
            $('#pauseRoadmap').addClass('rm-btn-disabled');
            $('#resetRoadmap').addClass('rm-btn-disabled');
            $('#roadmap-filter-count-wrapper').addClass('text-muted');
        } else
        {
         //  console.log('Roadmap Active');
            essRoadmapEnabled = true;
            $(this).removeClass('btn-danger');
            $(this).addClass('btn-success');
            $(this).addClass('rmActive');        
            $(this).text('Active');        
            $('#rmWidgetEndDateSelect').MonthPicker('Enable');
            $('#playRoadmap').removeClass('rm-btn-disabled');
            $('#resetRoadmap').removeClass('rm-btn-disabled');
            $('#pauseRoadmap').removeClass('rm-btn-disabled');
            $('#roadmap-filter-count-wrapper').removeClass('text-muted');
        }
        essRefreshScopeCallback();
    });
    
    //initalise the start and end date selectors
    //rmInitDates();
    $('#rmWidgetEndDateSelect').MonthPicker({
        ShowIcon: false,
        ButtonIcon: 'ui-icon-calendar',
        ShowOn: 'both',
        MonthFormat: 'M yy',
        UseInputMask: true,
        Animation: 'fadeToggle',
        SelectedMonth: 0,
        OnAfterChooseMonth: function( selectedDate ){
            let y = selectedDate.getFullYear(), m = selectedDate.getMonth();
            let newDate = new Date(y, m, 1);
            $('#rmWidgetEndDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
            let isoDate = moment(newDate).format('YYYY-MM-DD');
            
            let currentVal = essRMEndDate;
            if (currentVal != isoDate) {
                rmUpdateEndDate(newDate);
            }
        } 
    });

    //$('#rmWidgetEndDateSelect').MonthPicker('option', {'AltFormat': 'yy-mm'});

    // Initialise the Roadmap Widget Button dates
    $('#rm-button-end-date').text(moment(essRMEndDate).format('M YYYY'));
    
}

function initRMDatePickerOLD() {
   /***************************************************
    Initialise Roadmap Month Picker
   ****************************************************/

    $('#rm-date-picker').MonthPicker({
        //ShowIcon: true,
        //ButtonIcon: false,
        Button: '.rm-date-btn',
        /* Button: function() {
            return $(this).prev('.trigger-month-picker');
        }, */
        ShowOn: 'both',
        AltField: '#rm-date-display', 
        AltFormat: "M yy",
        UseInputMask: true,
        Animation: 'fadeToggle',
        SelectedMonth: 0,
        Disabled: false,
        OnAfterChooseMonth: function( selectedDate ){
            let y = selectedDate.getFullYear(), m = selectedDate.getMonth();
            let newDate = new Date(y, m, 1);
            $('#rm-date-picker').MonthPicker('option', 'SelectedMonth', newDate);
            let isoDate = moment(newDate).format('YYYY-MM-DD');
            
            let currentVal = essRMEndDate;
            if (currentVal != isoDate) {
                essRMEndDate = isoDate;
                //$('#rm-date-display').val(moment(essRMEndDate).format('DD MMM YYYY'));
                essRefreshScopeCallback();
            }
        } 
      });
    
    /* $('#rm-date-picker').datepicker({
        format: {
            toDisplay: function (date, format, language) {
                return moment(date).format('YYYY-MM-DD');
            },
            toValue: function (date, format, language) {
                return new Date(date);
            }
        },
        todayHighlight: true,
        autoclose: true,
        clearBtn: false,
        showOnFocus: false
    });

    $('#rm-date-picker').val(moment(essRMEndDate));
    $('#rm-date-picker').datepicker('setDate', new Date(essRMEndDate));
    $('#rm-date-display').val(moment(essRMEndDate).format('DD MMM YYYY'));
    
    $('#rm-date-picker').inputmask('9999-99-99');
    
    $('#rm-date-trigger').click(function () {
        $('#rm-date-picker').datepicker('show');
    });
    
    $('#rm-date-picker').datepicker().on('changeDate blur', function (e) {
        let newDate = $(this).val();
        let currentVal = essRMEndDate;

        if (currentVal != newDate) {
            essRMEndDate = newDate;
            $('#rm-date-display').val(moment(essRMEndDate).format('DD MMM YYYY'));
            essRefreshScopeCallback();
        }
    }); */
}

//roadmap animation variables
var roadmapTimer;
var roadmapStepCount = 1;
var roadmapTimerInterval = 1500;
var roadmapMaxStepCount = 10;
var roadmapTimerMonths = 6;


//function to update the end date of the roadmap
function rmUpdateEndDate(newDate) {
    essRMEndDate = moment(newDate).format('YYYY-MM-DD');
    $('#rm-button-end-date').text(moment(newDate).format('MM yyyy'));
    
    //redraw the view
    essRefreshScopeCallback();
}

function roadmapTimerEvent() {
    if(roadmapStepCount <= roadmapMaxStepCount) {
        console.log('Roadmap Animated');
        let newDateMoment = moment(essRMEndDate).add(roadmapTimerMonths, 'months');
        let newDate = newDateMoment.toDate();
        $('#rmWidgetEndDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
        rmUpdateEndDate(newDate);
        roadmapStepCount++;
      } else {
          $('#rmWidgetEndDateSelect').removeClass('rm-animation-date-blink');
      }
}

//function to start the animation of the roadmap at set intervals
function startRoadmapAnimation() {
    $('#rmWidgetEndDateSelect').addClass('rm-animation-date-blink');
    roadmapTimer = setInterval(roadmapTimerEvent, roadmapTimerInterval);
}

//function to stop the animation of the roadmap at set intervals
function endRoadmapAnimation() {
    console.log('Roadmap Animation Paused');
    if(roadmapTimer != null) {
        clearInterval(roadmapTimer);
        $('#rmWidgetEndDateSelect').removeClass('rm-animation-date-blink');
    }
}

//function to reset the animation of the roadmap at set intervals
function resetRoadmapAnimation() {
    //remove the roadmap timer, if one exists
    if(roadmapTimer != null) {
        clearInterval(roadmapTimer);
        $('#rmWidgetEndDateSelect').removeClass('rm-animation-date-blink');
    }
    //reset the end date to today + 1 month
    let newDateMoment = moment().add(1, 'months');
    let newDate = newDateMoment.toDate();
    $('#rmWidgetEndDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
    rmUpdateEndDate(newDate);
    
    //reset the roadmap animation variables
    roadmapStepCount = 1;
    roadmapTimer = null;
    console.log('Resetting roadmap animation');
}



var easTimeMachine={
    initRMEnablement:function(){
        function onGotLayers(){
            self.layers=easTimeMachineAddMissingAdds(essRMApiData.plans);
            console.log('self.layers',self.layers)
        }

        var self=this;
        Promise.all([
            promise_loadViewerAPIScopeData(essPlannedChangesAPIURL),
            promise_loadViewerAPIScopeData(essScopeViewAPIURL)
        ])
        .then(function(responses) {    
            essRMApiData.plans = responses[0].plans;
            essRMApiData.rpp = responses[1];
         //   console.log('responses[0]',responses[0])
         //   console.log('responses[1]',responses[1])
            onGotLayers();
        });
    },
    getRMInstances:function(inScopeInstances, typeInfo){
      // console.log('ALL PLANS', essRMApiData.plans); 
        let plans = essRMApiData.plans;
        let rmMonthStop = essRMEndDate;
        let inScopePlans = [];
        let filteredInstances = inScopeInstances.filter(inst => {
            let allPlansForInst = plans?.filter(plan => plan.instId == inst.id);

    
            //If there are no plans for the instance, it is in scope
            if(!(allPlansForInst?.length > 0)) {return true};

            //get all plans that are completed before the end date
            let instInScopePlans = allPlansForInst.filter(plan => plan.end <= rmMonthStop);
            inScopePlans = inScopePlans.concat(instInScopePlans);

            //if there is a future CREATE plan for the instance, it is NOT in scope
            let futureCreatePlans = allPlansForInst.filter(plan => plan.end > rmMonthStop && plan.actionType == "Creation Change");
           
            if(futureCreatePlans.length > 0) {return false};

            //if there is a REMOVE plan before the given date for the instance, it is NOT in scope
            let removePlans = allPlansForInst.filter(plan => plan.end <= rmMonthStop  && plan.actionType == "Removal Change");

            if(removePlans.length > 0) {
                return false
            };

            //otherwise, it is in scope
            return true;
        });
      //  console.log('NEW IN SCOPE CHANGE DATA: ', inScopePlans);
        rmRefreshInScopeChanges();
        essRMInScopeChanges = essRMInScopeChanges.concat(inScopePlans.map(chg => new PlannedChange(chg, inScopeInstances, typeInfo)));
        easTimeMachine.updateRMInScopeChangesUI();
        return filteredInstances;
    },
    updateRMInScopeChangesUI() {
        rmRefreshInScopeChanges();
        $('#roadmap-filter-count').text(essRMInScopeChanges.length);
        $('#ess-rm-changes-end-date').text(moment(essRMEndDate).format('Do MMM YYYY'));
    },
    getRMInstancesOLD:function(rmMonthStop,roadmaps,plans,projects,inScopeInstances){
        var filteredInstances=[];
        
        //if instance ID in inScopeInstances then apply it to our current set of instances, e.g ADD/REMOVE/ENHANCE
        for(var i=0;i<inScopeInstances.length;i++){
            var inScopeLayer=inScopeInstances[i];
            for(var inScopeInstanceType in inScopeLayer){
                for(var j=0;j<this.layers.length;j++){
                    var layer=this.layers[j];     
                    var inScopeInstanceIds=inScopeLayer[inScopeInstanceType];
                 //   console.log('RM In Scope Instances: ', inScopeInstanceIds); 
                    for(var k=0;k<inScopeInstanceIds.length;k++){
                        var inScopeInstance=inScopeInstanceIds[k];
                        filteredInstances=easTimeMachineApplyPlan(filteredInstances,roadmaps,plans,projects,rmMonthStop,layer,inScopeInstanceType,inScopeInstance);
                    }
                }
            }//for(var instanceType in inScopeLayer){
        }
        return filteredInstances;
    }
}

/*********************************
 *  ROADMAP UI - PANEL AND TABLES
 **********************************/

var essRMInScopeChangesTable, essRMFiltersTable;


function renderRoadmapPanel(){		
				
    /* $('#ess-roadmap-type-filter').select2();
        
    var essRMInScopeChangesTable = $('#dt-roadmap-table-filter').DataTable({
        paging: false,
        deferRender:    true,
        scrollY:        350,
        scrollCollapse: true,
        info: true,
        sort: true,
        responsive: false,
        destroy: true
    });

    essRMInScopeChangesTable.columns.adjust();
    
    $(window).resize( function () {
        essRMInScopeChangesTable.columns.adjust();
    });
    
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        rmRefreshInScopeChanges();
    }); */

    rmRefreshInScopeChanges();
    
}

function stringifyTopLevels(obj, depth = 2) {
    let currentDepth = 0;

    function replacer(key, value) {
        if (currentDepth > depth) return undefined;
        if (typeof value === 'object' && value !== null) currentDepth++;
        return value;
    }

    return JSON.stringify(obj, replacer);
}

function rmRefreshInScopeChanges() {
    
    if(!essRMInScopeChangesTable) {
        rmCreateInScopeChangesTable();
    } else {
       
   
        essRMInScopeChangesTable.clear().draw();
		essRMInScopeChangesTable.rows.add(essRMInScopeChanges); // Add new data
		essRMInScopeChangesTable.columns.adjust().draw(); // Redraw the DataTable
    }
}


function rmCreateInScopeChangesTable() {

    // Setup - add a text input to each footer cell
    $('#dt-roadmap-table-changes tfoot th').each( function () {
        var title = $(this).text();
        $(this).html( '<input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" />' );
    } );


    let changesTableColumns = [
        {
            //"title": "Changed Element",
			"data": "instance.name",
			"type": "html",
            "visible": true,
			"width": "25%",
            "render": function( d, type, row, meta ) {
                return essRMTableNameTemplate(row);
            }
		},
        {
            //"title": "Type",
			"data": "instance.type",
			"type": "html",
            "visible": true,
			"width": "15%",
            "render": function( d, type, row, meta ) {
                return essRMTableTypeTemplate(row);
            }
		},
        {
            //"title": "Description",
			"data": "instance.description",
			"type": "html",
            "visible": true,
			"width": "30%",
            "render": function( d, type, row, meta ) {
                return d ? d : '-';
            }
		},
        {
            //"title": "Planned Change",
			"data": "planningAction.name",
			"type": "html",
            "visible": true,
			"width": "15%",
            "render": function( d, type, row, meta ) {
                return essRMTableChangeTemplate(row);
            }
		},
        {
            //"title": "Completion Date",
			"data": "strategicPlan.endDate",
			"type": "html",
            "visible": true,
			"width": "15%",
            "render": function( d, type, row, meta ) {
                if ( type === 'sort' || type === 'type' ) {
                    return d ? d : '-';
                }
                if ( type === 'display' ) {
                   // Manipulate your display data
                  return d ? moment(d).format('Do MMM YYYY') : '-';
                }
                return d ? moment(d).format('Do MMM YYYY') : '-';
            }
		},
        {
            //"title": "Part of Plan",
			"data": "strategicPlan.name",
			"type": "html",
            "visible": false,
			"width": "15%",
            "render": function( d, type, row, meta ) {
                return d ? d : '-';
            }
		},
        {
            //"title": "Part of Roadmap",
			"data": "roadmaps",
			"type": "html",
            "visible": false,
			"width": "15%",
            "render": function( d, type, row, meta ) {
                return essRMTableListTemplate(d);;
            }
		},
        {
            //"title": "Implemented By",
			"data": "changeActivity.name",
			"type": "html",
            "visible": false,
			"width": "15%",
            "render": function( d, type, row, meta ) {
                return d ? d : '-';
            }
		}
    ]

    essRMInScopeChangesTable = $('#dt-roadmap-table-changes').DataTable({
        paging: false,
        data: essRMInScopeChanges,
        deferRender:    true,
        scrollY:        350,
        scrollCollapse: true,
        info: true,
        sort: true,
        responsive: false,
        destroy: true,
        sort: true,
        rowId: "id",
        order: [[4, 'asc']],  //sort by the end date of the changes
        columns: changesTableColumns,
        drawCallback: function (settings) {
            //do nothing
        },
        buttons: ['colvis'],
        dom: 'Bflrtip'
    });
    
    // Apply the search
    essRMInScopeChangesTable.columns().every( function () {
        var that = this;
        $( 'input', this.footer() ).on( 'keyup change', function () {
            if ( that.search() !== this.value ) {
                that
                .search( this.value )
                .draw();
            }
        });
    });
    
    essRMInScopeChangesTable.columns.adjust();
    
    $(window).resize( function () {
        essRMInScopeChangesTable.columns.adjust();
    });

}

var currentLang=`<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>`;

function formatDateforLocale(datestring, locale){
    const date = new Date(datestring);
    return new Intl.DateTimeFormat(locale, {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    }).format(date);

}

