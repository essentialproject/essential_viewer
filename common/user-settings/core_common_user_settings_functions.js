

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
var essScopingDDTemplate, essScopeValuesTemplate;

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

//Function call by Views/Editors to initialise the scoping capability and then call the callback function
function essInitViewScoping(callback, initfilterClassList, dynamicFilters) {

    scopeInitialised = true;
    
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
    

    essRefreshScopingValues();

    //if the timestamp is earlier than the latest publish, call the common scoping API and replace local storage scoping lists
    if(essUserScopeSettings.timestamp && essUserScopeSettings.timestamp >= essUserSettingsPublishTimestamp) {
     //   console.log('Found local scoping lists');
        essScopingLists = essUserScopeSettings.scopingLists;
        essSetScopingDropdowns();
    } else {
     //   console.log('Getting new scoping lists');
        //call the common scoping API and replace local storage scoping lists
        promise_loadViewerAPIScopeData(essScopeViewAPIURL)
        .then(function(response) {    
                   
            essUserScopeSettings.scopingLists = response.scopingLists;
            essScopingLists = essUserScopeSettings.scopingLists;
            //console.log('Returned scoping list:');
            //console.log(essScopingLists);

            //save local scoping data with updated timestamp
            essUserScopeSettings.timestamp = essUserSettingsPublishTimestamp;
            essUpdateUserSettings();
            essSetScopingDropdowns();
        });
    }
    
    
}

function essIsViewScopingReady() {
    return scopeInitialised;
}

// Function to populate the scoping category drop down list with nothing selected (first dropsown is enabled)
function essSetScopingDropdowns() {
    if(essScopingLists && essScopingLists.length > 0) {
        //add the list of filters dynamically provided by the containing view
        essDynamicFilterList?.forEach(flt => {
            if(flt.valueClass && essFilterClassList.indexOf(flt.valueClass) < 0) {
                essFilterClassList.push(flt.valueClass);
                essScopingLists.push(flt);
            }
        });

        let inScopeList = essScopingLists;
        //console.log('Scoping Lists', essScopingLists);
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
    
    $('#ess-add-scoping-value-btn').on('click', function(event) {
        
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

    $('#ess-add-exl-scoping-value-btn').on('click', function(event) {
        
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
    //console.log('essUserScope',essUserScope)
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
function essFilterResources(scopedResources, scopeForProperty, scopingProperty, metaClass) {
    let filteredResources = scopedResources.filter(function(aRes) {
        let isIncludeInScope = true;
 
        let resScope = new Set(aRes[scopingProperty]);
        
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
    console.log('filteredResources',filteredResources)
    return filteredResources;
}

//Main function called by Views/Editor to filter a given list of resources based on the provided property to meta-class pairings
function essScopeResources(resourceList, scopingPropertyList) {

    let scopedResources = resourceList;
  //  console.log('resourceList',resourceList)
  //  console.log('scopingPropertyList',scopingPropertyList)
    scopingPropertyList.forEach(function(aSP) {
  //      console.log('aSP',aSP)
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
        thisState = essGetLocalEssentialViewState();
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
