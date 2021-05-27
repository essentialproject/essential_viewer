/***********************************
VIEW STATE MANAGEMENT FUNCTIONS
************************************/

const essWindowParams = new URLSearchParams(window.location.search);
const essViewStateParam = 'essstate';
const essViewId = essWindowParams.get('XSL');

var essCurrentViewState;

window.onpopstate = essRevertViewState;

function essInitViewState(stateObj, defaultViewState) {
    essCurrentViewState = stateObj;
    let stateVal;
    let thisState = defaultViewState;
    

    //Check the view url for a url parameter
    if(essWindowParams.has(essViewStateParam)) {
        stateVal = essWindowParams.get(essViewStateParam);
    } else {
        //if the url parameter is empty, see if there is anything in local storage
        stateVal = essGetLocalEssentialViewState();
    }

    //if a state value was found, deserialize it into a JSON object
    if(stateVal) {
        thisState = essDeserializeState(stateVal);	
    } else {
        thisState = defaultViewState;
    }    

    $('#ess-copy-page-link').on('click', function(e) {
        essCopyPageLink();
    });

    essCurrentViewState.state = thisState;
    essUpdateViewState();
    //return thisState;
}


function essUpdateViewState() {
    let newURL = essGeneratePageLink();
    history.replaceState(essCurrentViewState.state, null, newURL);
    essSaveLocalEssentialViewState(essViewId, essCurrentViewState.state);
}


function essRevertViewState(e) {
    // page reload
    if(e.state) {
        essCurrentViewState.state = e.state;
        console.log('Current state on reload');
        console.log(essCurrentViewState.state);
    } else {
        console.log('No State Found');
        console.log(essCurrentViewState.state);
    }
}


// helper function to turn an object into a base64 encoded string
function essSerializeState(data) {
    let jsonStr = JSON.stringify(data);
    return encodeURIComponent(btoa(jsonStr));
}

// helper function to turn a base64 encoded string back into an object
function essDeserializeState(string) {
    try {
        let jsonStr = atob(decodeURIComponent(string));
        return JSON.parse(jsonStr);
    } catch (err) {
        console.error('Invalid state could not be deserialised!', err);
        return undefined;
    }
}

//function to copy the url for the current instance
function essCopyPageLink() {
    $('#ess-copy-page-link').addClass("btn-success");
    $('#ess-copy-page-link > span').text('Copied!');
    setTimeout(essRevertCopyButton,1000);
    
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
    $('#ess-copy-page-link > span').text('Copy Link');
    $('#ess-copy-page-link').removeClass('btn-success');
};


function essGeneratePageLink() {
    let url = new URL(location.href);
    let search_params = url.searchParams;

    // set the state parameter to the current state
    let currentState = essCurrentViewState.state;
    search_params.set(essViewStateParam, essSerializeState(currentState));

    // change the search property of the main url
    url.search = search_params.toString();

    // return the new url string
    return url.toString();
}

/****************************************
 * VIEW STATE LOCAL STORAGE FUNCTIONS
 ***************************************/

const ESS_LOCAL_VIEW_STATE_KEY = 'ESSENTIAL_USER_SETTINGS.VIEW_STATE';

function essGetLocalEssentialViewState() {
    let viewStateKey = ESS_LOCAL_VIEW_STATE_KEY + '.' + essViewId;
    let viewStateString = localStorage.getItem(viewStateKey);
    console.log('Locally stored encoded state: ' + viewStateString);
    let viewState;
    if(viewStateString) {     
        try {
            viewState = essDeserializeState(viewStateString);
        }
        catch(e) {
            console.log('Exception when loading scope settings');
            console.log(e);
        }
    }
    return viewState;
}


function essSaveLocalEssentialViewState(viewId, theState) {
    let viewStateKey = ESS_LOCAL_VIEW_STATE_KEY + '.' + viewId;
    if(theState != null) {
        let settingsString = essSerializeState(theState);
        localStorage.setItem(viewStateKey, settingsString);         
    }
    return theState;
}