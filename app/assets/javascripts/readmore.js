(function($) {
  $.fn.readmore = function(options) {
    var settings = $.extend({
      height: 150,
      moreText: "Read More",
      lessText: "Read Less"
    }, options);
    return this.each(function() {
      var element = this;
      if ($(element).height() < settings.height) return;
      $(element).addClass("readmore").wrapInner('<div class="readmore-inner" />');

      var link = $('<a href="#" class="readmore-link"><span class="more">'+settings.moreText+'</span><span class="less">'+settings.lessText+'</span></a>')
        .click(function(event) {
          event.preventDefault();
          $(this).closest('div.readmore').toggleClass("expanded");
        });

      $(element).append(link);
    });
  };

})(jQuery);
