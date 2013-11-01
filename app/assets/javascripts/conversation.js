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
        $(".participants").css({
          height: 165
        });
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

    // 'Expand All' and 'Collapse All' Contribution Threads
    $('.threads-controls .button').click(function(event) {
      event.preventDefault();
      deselectExpandCollapseThreadButtons();
      $(this).addClass('active');

      if ($(this).attr("rel") == "expand") {
        expandConversations();
      }
      else {
        collapseConversations();
      }
    });

    $(document).delegate('.contribution-attachments .button', 'click', function(event) {
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

    /*
     * 'Add Comment' and 'Expand This Thread' Button
     *   - Expands Single Thread
     *   - Opens WYSIWYG Editor If 'Add Comment' Button is Selected
     *   - Deselects 'Expand All' and 'Collapse All' Button If Threads Are Not In A Expand All State
     */
    $(document).delegate(".thread a.expand, .thread a.expand-button", "click", function(event) {
      event.preventDefault();
      var parent = $(this).closest(".thread").addClass("expanded");
      if ($(this).hasClass("expand")) {
        $(parent).find('.editable').scrollTo().find('textarea').focus();
      }
      if ( $('.threads-controls .button[rel="collapse"]').hasClass("active") ) {
        deselectExpandCollapseThreadButtons();
      }
    });

    $(window).resize(function(event) {
      recent_activity_resize();
    });
    $(window).scroll(function() {
      recent_activity_resize();
    });
    recent_activity_resize();
    $(document).delegate(".thread .response", "click", function(event) {
      $(this).toggleClass("show-all");
    });
    init_date_changer();

    if (window.location.hash != "") {
      goToNode(parseInt(_.last(window.location.hash.split('-'))));
    }
    $(window).hashchange(function(event) {
      event.preventDefault();
      goToNode(parseInt(_.last(window.location.hash.split('-'))));
    });

  });

  function deselectExpandCollapseThreadButtons() {
    $('.threads-controls .button').removeClass('active');
  }

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

  function init_date_changer() {
    var now = moment();
    $(".date[data-date]").each(function(index, element) {
      var mmnt = moment($(this).data("date"));
      mmnt.format();
      if (now.diff(mmnt, "days") <= 7) {
        $(this).text(mmnt.fromNow());
      }
    });
    window.dateListenerMinutes = setInterval(function() {
      $(".date[data-minutes-ago]").each(function(index, element) {
        $(this).text(moment($(this).data("date")).fromNow());
      });
    }, 60000);
  }

  function goToNode(node_id) {
    var contribution = $('#show-contribution-' + node_id);
    if ($(contribution).hasClass("response")) {
      $(contribution).closest(".thread").addClass("expanded");
    }
    contribution.scrollTo();
  }

})(jQuery)
