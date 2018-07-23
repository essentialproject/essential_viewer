$(document).ready(function()	{
	if($('div.ShowHideDivTrigger').length>0)	{
		$('div.ShowHideDivTrigger').click(function()	{
			if($(this).hasClass('ShowHideDivOpen'))	{
				$(this).removeClass('ShowHideDivOpen');
				$(this).addClass('ShowHideDivClose');
				$(this).next().slideDown(200);
				return false;
			} else	{
				$(this).removeClass('ShowHideDivClose');
				$(this).addClass('ShowHideDivOpen');
				$(this).next().slideUp(200);
				return false;
			}
		})
	}	
});	