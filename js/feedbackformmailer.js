function emailForm(){

var email = document.EmailFeedbackForm.emailTo.value;
var userComment = document.EmailFeedbackForm.VisitorComment.value;
var subject = "Essential Viewer: " + document.EmailFeedbackForm.feedbacktype.value ;
var name = document.EmailFeedbackForm.VisitorName.value ;
var pageLink = document.EmailFeedbackForm.pageLink.value;


var body_message = "Thank you "+name+" for your contribution to the Essential Viewer portal.%0D%0DFEEDBACK:%0D" + userComment + "%0D%0DPAGE LINK:%0D" + encodeURIComponent(pageLink);

var mailto_link = 'mailto:'+email+'?subject='+subject+'&body='+body_message;

win = window.open(mailto_link,'emailWindow');
if (win && win.open &&!win.closed) win.close();
}
