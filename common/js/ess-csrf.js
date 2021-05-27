/***********************************
Dynamic CSRF token request functionality 
************************************/

// Set the essViewer.csrfToken
var aRequest = new XMLHttpRequest();
aRequest.open("GET", essViewer.baseUrl + "/report?GET-CSRF=true", false);
aRequest.send(null);

if(aRequest.status == 200)
{
    essViewer.csrfToken = aRequest.responseText;
}
else
{
    alert("CSRF Issue. Please try refreshing the page, or logging out and back in again. If this issue persists, please contact Support.");
}