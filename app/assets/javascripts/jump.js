(function ($) {
  $.fn.extend({
    jump: function(options) {
      var $element = this;
      settings = $.extend({
        css_class: "new",
        offset: 230
      },options);
      if (this.offset() == undefined) {
        return;
      }
      $('html,body').animate({
        scrollTop: $(this).offset().top - settings.offset
      }, 1000);
      $(this).addClass('new');
      setTimeout(function() {
        $($element).removeClass('new');
      },3000);
      return this;
    }
  });
})(jQuery);
