/***************************************/
/*    
COMMON FUNCTIONS
*/
/***************************************/

function essBuildApiPath(apiUri) {
    return essViewer.baseUrl+'/api'+apiUri+'/repositories/'+essViewer.repoId+'/';
}

function essBuildRefApiPath(apiUri) {
    return essViewer.baseUrl+'/api'+apiUri+'/';
}

function essBuildSystemApiPath(apiUri) {
    return essViewer.baseUrl+'/api'+apiUri+'/';
}


//functiom to clone a resource
function essCloneResource(aResource) {
    return _.cloneDeep(aResource);
    //return Object.assign({}, aResource);
}



//function to creata a JSON structure to send when updating a given Object
function essRenderUpdateJSON(theObject, attrList) {
    if((theObject != null) && (attrList != null)) {
        var updateJSON = {
            'id': theObject.id,
        }
        attrList.forEach(function (anAttr, attrIndex) {
            updateJSON[anAttr] = theObject[anAttr];
        });
        return updateJSON;
    } else {
        return null;
    }
}

function essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb) {
	return function() {
		let response = xhr.responseText;
		let status = xhr.status;
		if (status >= 200 && status < 300) {
			// http success code
			try {
				let theElements = JSON.parse(response);
                let pagCount = xhr.getResponseHeader('Pagination-Count');
                if(pagCount != null) {
                    let pagDetails = {
                        "count": pagCount
                    }
                    let pagStart = xhr.getResponseHeader('Pagination-Start');
                    if(pagStart != null) {
                        pagDetails["start"] = pagStart;
                    }
                    let pagLimit = xhr.getResponseHeader('Pagination-Limit');
                    if(pagLimit != null) {
                        pagDetails["limit"] = pagLimit;
                    }
                    theElements["pagination"] = pagDetails;
                }
				
				resolve(theElements);
			} catch (e) {
				let requestError = new Error('Error in the ' + resourceTypeLabel + ' data returned by the server');
				reject(requestError);
			}
		} else {
			// http error code
			try {
			    //console.log('Error Response:');
			    //console.log(response);
				let theResponseJson = JSON.parse(response);
				if (status === 403 && theResponseJson.message && theResponseJson.message.errorCode && theResponseJson.message.errorCode === 10) {
					// specific error code that informs the client that the server has logged the user out and requires a page refresh to complete the logout
					location.reload();
				}
			} catch (e) {
				// do nothing - if the API doesn't return a JSON error response, just continue
			}
			let requestError = new Error('Error ' + errorMessageVerb + ' ' + resourceTypeLabel + ' data');
			reject(requestError);
		}
	};
};

function essOnXhrError(reject, resourceTypeLabel, errorMessageVerb) {
	return function() {
		// on error listener fires when there is a network level error
		let requestError = new Error('Error ' + errorMessageVerb + ' ' + resourceTypeLabel + ' data');
		reject(requestError);
	};
};

//Utility function to create a CORs request
function essCreateCORSRequest(method, url) {
	var xhr = new XMLHttpRequest();
	if ("withCredentials" in xhr) {
	
		// Check if the XMLHttpRequest object has a "withCredentials" property.
		// "withCredentials" only exists on XMLHTTPRequest2 objects.
		
		xhr.open(method, url, true);
		xhr.setRequestHeader('Content-type','application/json; charset=utf-8');
		xhr.setRequestHeader('x-csrf-token', essViewer.csrfToken);
		xhr.setRequestHeader('x-form-id', essEnvironment.form.id);
		xhr.setRequestHeader('x-form-name', essEnvironment.form.name);
		

	} else if (typeof XDomainRequest != "undefined") {
		
		// Otherwise, check if XDomainRequest.
		// XDomainRequest only exists in IE, and is IE's way of making CORS requests
		xhr = new XDomainRequest();
		xhr.open(method, url);
		xhr.setRequestHeader('Content-type','application/json; charset=utf-8');
		xhr.setRequestHeader('x-csrf-token', essViewer.csrfToken);
		xhr.setRequestHeader('x-form-id', essEnvironment.form.id);
		xhr.setRequestHeader('x-form-name', essEnvironment.form.name);

	} else {
	
		// Otherwise, CORS is not supported by the browser.
		xhr = null;

	}
	return xhr;
}



//Utility function to create a CORs request
function essCreateRefCORSRequest(method, url) {
	var xhr = new XMLHttpRequest();
	if ("withCredentials" in xhr) {
	
		// Check if the XMLHttpRequest object has a "withCredentials" property.
		// "withCredentials" only exists on XMLHTTPRequest2 objects.
		
		xhr.open(method, url, true);
		//xhr.setRequestHeader('Content-type','multipart/form-data');
		xhr.setRequestHeader('x-csrf-token', essViewer.csrfToken);
		xhr.setRequestHeader('x-form-id', essEnvironment.form.id);
		xhr.setRequestHeader('x-form-name', essEnvironment.form.name);
		
	} else if (typeof XDomainRequest != "undefined") {
		
		// Otherwise, check if XDomainRequest.
		// XDomainRequest only exists in IE, and is IE's way of making CORS requests
		xhr = new XDomainRequest();
		xhr.open(method, url);
		xhr.setRequestHeader('Content-type','application/json; charset=utf-8');
		xhr.setRequestHeader('x-csrf-token', essViewer.csrfToken);
		xhr.setRequestHeader('x-form-id', essEnvironment.form.id);
		xhr.setRequestHeader('x-form-name', essEnvironment.form.name);
	
	} else {
	
	   // Otherwise, CORS is not supported by the browser.
	   xhr = null;
	
	}
	return xhr;
}


/*********************************************************
SYSTEM API FUNCTIONS
*********************************************************/
// get a list of elements via the Essential System API
function essPromise_getSystemAPIElements(apiUri, resourcePath, resourceTypeLabel) {
	return new Promise(
		function (resolve, reject) {
			let url = essBuildSystemApiPath(apiUri) + resourcePath;
			let xhr = essCreateCORSRequest('GET', url);
			if (!xhr) {
				corsError = new Error('CORS not supported by browser. Unable to retrieve ' + resourceTypeLabel + ' data');
				reject(corsError);
			} else {
				// Response handlers.
				let errorMessageVerb = 'retrieving';
				xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
				xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
				xhr.send();
			}
		}
	);
};


/********************************************************
CORE API FUNCTIONS
*********************************************************/

function essPromise_validateMetaModelVersion(apiUri, requiredVersion) {
    return new Promise(
		function (resolve) {
			essPromise_getAPIElements(apiUri, 'meta-model', 'Meta-Model')
            .then(function(response) {
               var mmVersion = response.version;
               if(requiredVersion <= mmVersion) {
                    resolve(true);
               } else {
                    resolve(false);
               }    
            });
		}
	);



    essPromise_getAPIElements(apiUri, 'meta-model', 'Meta-Model')
     .then(function(response) {
        var mmVersion = response.version;
        return mmVersion;
     });
}


// get an individual element via the Essential API
function essPromise_getAPIElement(apiUri, resourcePath, resourceId, resourceTypeLabel) {
	return new Promise(
		function (resolve, reject) {
			var url = essBuildApiPath(apiUri) + resourcePath + '/' + resourceId;
			var xhr = essCreateCORSRequest('GET', url);
			if (!xhr) {
				corsError = new Error('CORS not supported by browser. Unable to retrieve the ' + resourceTypeLabel);
				reject(corsError);
			} else {
				// Response handlers.
				let errorMessageVerb = 'retrieving';
				xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
				xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
				xhr.send();
			}
		}
	);
};



// get a list of elements via the Essential API
function essPromise_getAPIElements(apiUri, resourcePath, resourceTypeLabel) {
	return new Promise(
		function (resolve, reject) {
			let url = essBuildApiPath(apiUri) + resourcePath;
			let xhr = essCreateCORSRequest('GET', url);
			if (!xhr) {
				corsError = new Error('CORS not supported by browser. Unable to retrieve ' + resourceTypeLabel + ' data');
				reject(corsError);
			} else {
				// Response handlers.
				let errorMessageVerb = 'retrieving';
				xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
				xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
				xhr.send();
			}
		}
	);
};

// create an element via the Essential API
function essPromise_createAPIElement(apiUri, resource, resourcePath, resourceTypeLabel) {
	return new Promise(
		function (resolve, reject) {
			var resourceJSONString = JSON.stringify(resource);

			var url = essBuildApiPath(apiUri) + resourcePath;
			var xhr = essCreateCORSRequest('POST', url);
			if (!xhr) {
				corsError = new Error('CORS not supported by browser. Unable to create the ' + resourceTypeLabel);
				reject(corsError);
			} else {
				// Response handlers.
				let errorMessageVerb = 'creating';
				xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
				xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
				xhr.send(resourceJSONString);
			}
		}
	);
};

// update (patch) an element via the Essential API
function essPromise_updateAPIElement(apiUri, resourceDetails, resourcePath, resourceTypeLabel) {
	return new Promise(
		function (resolve, reject) {
			var resourceJSONString = JSON.stringify(resourceDetails);
			//console.log('PATCH resource path: ' + resourcePath);			        
			var url = essBuildApiPath(apiUri) + resourcePath + '/' + resourceDetails.id;
			//console.log('URL for PATCH: ' + url);
			var xhr = essCreateCORSRequest('PATCH', url);
			if (!xhr) {
				corsError = new Error('CORS not supported by browser. Unable to update the ' + resourceTypeLabel);
				reject(corsError);
			} else {
				// Response handlers.
				let errorMessageVerb = 'updating';
				xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
				xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
				xhr.send(resourceJSONString);
			}
		}
	);
};

// delete an element via the Essential API
function essPromise_deleteAPIElement(apiUri, resourceId, resourcePath, resourceTypeLabel) {
	return new Promise(
		function (resolve, reject) {
			var url = essBuildApiPath(apiUri) + resourcePath + '/' + resourceId;
			var xhr = essCreateCORSRequest('DELETE', url);
			if (!xhr) {
				corsError = new Error('CORS not supported by browser. Unable to delete the ' + resourceTypeLabel);
				reject(corsError);
			} else {
				// Response handlers.
				let errorMessageVerb = 'deleting';
				xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
				xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
				xhr.send();
			}
		}
	);
};


/********************************************************
REFERENCE API FUNCTIONS
*********************************************************/

// get an individual resource via the NoSQL API
function essPromise_getNoSQLElement(apiURL, resourcePath, resourceId, resourceTypeLabel) {
    return new Promise(
        function (resolve, reject) {
            var url = essBuildRefApiPath(apiURL) + resourcePath + '/' + resourceId;
            var xhr = essCreateCORSRequest('GET', url);
            if (!xhr) {
                corsError = new Error('CORS not supported by browser. Unable to retrieve the ' + resourceTypeLabel);
                reject(corsError);
            } else {
                // Response handlers.
                var errorMessageVerb = 'retrieving';
                xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
                xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
                xhr.send();
            }
        }
    );
};


// get a list of the given resource via the NoSQL API
function essPromise_getNoSQLElements(apiURL, resourcePath, resourceTypeLabel) {
    return new Promise(
        function (resolve, reject) {
            var url = essBuildRefApiPath(apiURL) + resourcePath;
            var xhr = essCreateCORSRequest('GET', url);
            if (!xhr) {
                corsError = new Error('CORS not supported by browser. Unable to retrieve ' + resourceTypeLabel + ' data');
                reject(corsError);
            } else {
                // Response handlers.
                var errorMessageVerb = 'retrieving';
                xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
                xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
                xhr.send();
            }
        }
    );
};


//EXAMPLE collections/data-objects/instances/dataObject1/related-collections/data-object-attributes/slots/belongs_to_data_object
// get a list of resources  via the NoSQL API, where the given property has the given value
function essPromise_getFileredPropNoSQLElements(apiURL, parentResourcePath, resourcePath, propertyLabel, propertyValue, resourceTypeLabel) {
    return new Promise(
        function (resolve, reject) {
            var url = essBuildRefApiPath(apiURL) + parentResourcePath + '/instances/' + propertyValue + '/related-collections/' + resourcePath + '/attributes/' + propertyLabel;
            var xhr = essCreateCORSRequest('GET', url);
            if (!xhr) {
                corsError = new Error('CORS not supported by browser. Unable to retrieve the ' + resourceTypeLabel);
                reject(corsError);
            } else {
                // Response handlers.
                var errorMessageVerb = 'retrieving';
                xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
                xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
                xhr.send();
            }
        }
    );
};



//EXAMPLE collections/data-objects/instances/dataObject1/related-collections/data-object-attributes/slots/belongs_to_data_object
// get a list of resources  via the NoSQL API, where the given property has the given value
function essPromise_getFileredEssentialNoSQLElements(apiURL, parentResourcePath, resourcePath, propertyLabel, propertyValue, resourceTypeLabel) {
    return new Promise(
        function (resolve, reject) {
            var url = essBuildRefApiPath(apiURL) + parentResourcePath + '/instances/' + propertyValue + '/related-collections/' + resourcePath + '/slots/' + propertyLabel;
            var xhr = essCreateCORSRequest('GET', url);
            if (!xhr) {
                corsError = new Error('CORS not supported by browser. Unable to retrieve the ' + resourceTypeLabel);
                reject(corsError);
            } else {
                // Response handlers.
                var errorMessageVerb = 'retrieving';
                xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
                xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
                xhr.send();
            }
        }
    );
};


// create a given resource via the NoSQL API
function essPromise_createNoSQLElement(apiURL, resource, resourcePath, resourceTypeLabel) {
    return new Promise(
        function (resolve, reject) {
            var resourceJSONString = JSON.stringify(resource);
            var formData = new FormData();
			formData.append("json-file", resourceJSONString);		
            var url = essBuildRefApiPath(apiURL) + resourcePath;
            //console.log('Create Ref URL: ' + url);
            var xhr = essCreateRefCORSRequest('POST', url);
            if (!xhr) {
                corsError = new Error('CORS not supported by browser. Unable to create ' + resourceTypeLabel + ' data');
                reject(corsError);
            } else {
                // Response handlers.
                //xhr.setRequestHeader('Content-type','multipart/form-data');
                var errorMessageVerb = 'creating';
                xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
                xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
                xhr.send(formData);
            }
        }
    );
};


// replace (PUT) an individual resource via the NoSQL API
function essPromise_replaceNoSQLElement(apiURL, resourcePath, resourceDetails, resourceId, resourceTypeLabel) {
    return new Promise(
        function (resolve, reject) {
            var resourceJSONString = JSON.stringify(resourceDetails);
            var formData = new FormData();
			formData.append("json-file", resourceJSONString);	
            var url = essBuildRefApiPath(apiURL) + resourcePath + '/instances/' + resourceId;
            var xhr = essCreateRefCORSRequest('PUT', url);
            if (!xhr) {
                corsError = new Error('CORS not supported by browser. Unable to update the ' + resourceTypeLabel);
                reject(corsError);
            } else {
                // Response handlers.
                var errorMessageVerb = 'updating';
                xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
                xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
                xhr.send(formData);
            }
        }
    );
};


// replace (PUT) an individual resource via the NoSQL API
function essPromise_deleteNoSQLElement(apiURL, resourcePath, resourceId, resourceTypeLabel) {
    return new Promise(
        function (resolve, reject) {
            var url = essBuildRefApiPath(apiURL) + resourcePath + '/instances/' + resourceId;
            var xhr = essCreateCORSRequest('DELETE', url);
            if (!xhr) {
                corsError = new Error('CORS not supported by browser. Unable to delete the ' + resourceTypeLabel);
                reject(corsError);
            } else {
                // Response handlers.
                var errorMessageVerb = 'deleting';
                xhr.onload = essOnXhrLoad(xhr, resolve, reject, resourceTypeLabel, errorMessageVerb);
                xhr.onerror = essOnXhrError(reject, resourceTypeLabel, errorMessageVerb);
                xhr.send();
            }
        }
    );
};

