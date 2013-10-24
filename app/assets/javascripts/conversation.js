(function($) {
  $(function() {
    $("#contribute").sticky();
    $("#participants .see-all").click(function(event) {
      this.participantCount = $("#participants").find(".participant").length;
      event.preventDefault();
      if (this.participantCount < 6) {
        return false;
      }
      $("#participants").toggleClass("expanded");
      if ($("#participants").hasClass("expanded")) {
        $(".participants").css({
          height: (55 * Math.ceil(this.participantCount / 6)),
        });
        $(this).text("Close");
      }
      else {
        $(this).text("See All");
      }
    });

    $(".threads").delegate(".thread .action.expandable", "mouseenter", function(event) {
      this.timeout != undefined && clearTimeout(this.timeout)
      $(this).addClass("expanded");
    });
    $(".threads").delegate(".thread .action.expandable", "mouseleave", function(event) {
      this.timeout = setTimeout(function(element) {
        $(element).removeClass("expanded");
      }, 1000, this);
    });

    $(".thread .primary .content .content-inner").readmore();

    $('.threads-controls .button').click(function() {
      $('.threads-controls .button').removeClass('active');
      $(this).addClass('active');

      if ($(this).attr("rel") == "expand") {
        expandConversations();
      }
      else {
        collapseConversations();
      }
    });


    $(document).delegate('.contribution-attachments a.button', 'click', function(event) {
      event.preventDefault();
      var element = $(this).parent('.contribution-attachments');
      if ($(event.originalEvent.srcElement).hasClass('close')) {
        $(this).parent('.contribution-attachments').removeClass($(this).attr('rel'));
        $(this).find('input').val("");
      }
      else if (!$(element).hasClass($(this).attr('rel'))) {
        $(this).parent('.contribution-attachments').addClass($(this).attr('rel'));
        $(this).parent('.contribution-attachments').find('input').focus();
      }
    });

    $('.thread').each(function(index, element) {
      $(element).delegate('a.expand', 'click', function(event) {
        event.preventDefault();
        $(element).addClass('expanded');
        $(element).find('textarea').focus();
        $(element).find('textarea').trigger('focus');
      });
    });

    $(window).resize(function(event) {
      recent_activity_resize();
    });
    $(window).scroll(function() {
      recent_activity_resize();
    });
    recent_activity_resize();
  });

  function expandConversations() {
    $('.thread').addClass("expanded");
    $('#recent-activity').show();
  }
  function collapseConversations() {
    $('.thread').removeClass("expanded");
    $('.thread .responses').scrollTop(9999);
    $('#recent-activity').hide();
  }

  function recent_activity_resize() {
    if ($("#recent-activity").length > 0) {
      var to_bottom = $(window).scrollTop() + $(window).height() - $("#recent-activity .activities").offset().top;
      var to_footer = $("#footer").offset().top - $("#recent-activity .activities").offset().top;
      $("#recent-activity .activities").height(Math.min(to_bottom, to_footer));
    }
  }

})(jQuery)
