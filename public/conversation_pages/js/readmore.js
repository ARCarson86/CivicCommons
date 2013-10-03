(function($) {
  $.fn.readmore = function(options) {
    var settings = $.extend({
      height: 150,
      speed: 300,
      readMoreCSS: {
        position: 'absolute',
        bottom: 0,
        width: "100%",
        paddingTop: 25,
        textAlign: "center",
        display: "block",
        margin: 0,
      },
      moreText: "Read More",
      lessText: "Read Less"
    }, options);
    return this.each(function() {
      var element = this;
      if ($(element).height() < settings.height) {
        return;
      }
      element.collapsed = true;
      $(element).wrapInner('<div class="readmore-inner" />')
      .css({
        position: 'relative'
      })
      .addClass("readmore");

      element.height = $(this).children('.readmore-inner').height() + 45;
      $(element).children('.readmore-inner').css({
        height: settings.height,
        overflow: 'hidden',
      });
      var link = $('<a>')
      .text(settings.moreText)
      .attr("href", "#")
      .addClass("readmore")
      .css(settings.readMoreCSS)
      .click(function(event) {
        event.preventDefault();
        toggle(element, link, settings);
      });
      $(element).append(link);
    });
  };

  function toggle(element, link, settings) {
    if (element.collapsed) {
      $(link).text(settings.lessText);
      console.log(element.height);
      $(element).children(".readmore-inner").animate({
        height: element.height
      }, settings.speed);
    }
    else {
      $(link).text(settings.moreText);
      $(element).children(".readmore-inner").animate({
        height: settings.height
      }, settings.speed);
    }
    element.collapsed = !element.collapsed;
  }

})(jQuery);
