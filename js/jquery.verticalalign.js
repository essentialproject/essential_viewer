(function ($) {
    $.fn.vAlign = function(container) {
        return this.each(function(i){
	   if(container == null) {
	      container = 'div';
	   }
	   var paddingPx = 0; //change this value as you need (It is the extra height for the parent element)
	   $(this).html("<" + container + ">" + $(this).html() + "</" + container + ">");
	   var el = $(this).children(container + ":first");
	   var elh = $(el).height(); //new element height
	   var ph = $(this).height(); //parent height
	   if(elh > ph) { //if new element height is larger apply this to parent
	       $(this).height(elh + paddingPx);
	       ph = elh + paddingPx;
	   }
	   var nh = (ph - elh) / 2; //new margin to apply
	   $(el).css('padding-top', nh);
        });
     };
})(jQuery);