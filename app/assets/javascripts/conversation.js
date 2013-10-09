(function($) {
  $(function() {
    $("#contribute").sticky();
    $("#recent-activity").sticky({
      topSpacing:167
    });
    $("#participants .see-all").click(function(event) {
      this.participantCount = $("#participants").find(".participant").length;
      event.preventDefault();
      if (this.participantCount < 6) {
        return false;
      }
      $("#participants").toggleClass("expanded");
      if ($("#participants").hasClass("expanded")) {
        console.log(this.participantCount / 6);

        $(".participants").css({
          height: (55 * Math.ceil(this.participantCount / 6)),
        });
      }
    });

    $('.threads .thread .actions .action.expandable').hover(function() {
      $(this).addClass("expanded");
    }, function() {
      $(this).removeClass("expanded");
    });

    $(".thread .primary .content").readmore();

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

  });

  function expandConversations() {
    $('.thread').addClass("expanded");
    $('#recent-activity').show();
  }
  function collapseConversations() {
    $('.thread').removeClass("expanded");
    $('#recent-activity').hide();
  }

})(jQuery)
