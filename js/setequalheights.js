function setEqualHeight(columns)  
 {  
 var tallestcolumn = 0;  
 columns.each(  
 function()  
 {  
 currentHeight = $(this).height();  
 if(currentHeight > tallestcolumn)  
 {  
 tallestcolumn  = currentHeight;  
 }  
 }  
 );  
 columns.height(tallestcolumn);  
 }  
$(document).ready(function() {  
 setEqualHeight($(".AZEDM_SectionAppDependencies > div"));
});