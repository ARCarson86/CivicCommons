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

      element.height = $(this).children('.readmore-inner').height();
      $(element).children('.readmore-inner').css({
        height: settings.height,
        overflow: 'hidden',
        paddingBottom: 10
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
      $(element).children(".readmore-inner").animate({
        height: element.height
      }, {
        duration: settings.speed, 
        complete: function(first, second) {
          $(this).css({
            height: ''
          });
          $(link).css({
            backgroundImage: 'none'
          });
        }
      });
    }
    else {
      $(link).text(settings.moreText);
      $(link).css({
        backgroundImage: ''
      });
      $(element).children(".readmore-inner").animate({
        height: settings.height,
        backgroundImage: ''
      }, settings.speed);
    }
    element.collapsed = !element.collapsed;
  }

})(jQuery);
