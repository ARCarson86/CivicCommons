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

    $(".editable").editable();

    $('.contribution-attachments').each(function(index,element) {
      $(element).delegate('.close', 'click', function(event) {
        event.preventDefault();
      });
      $(element).delegate('a.button', 'click', function(event) {
        event.preventDefault();
        if ($(event.originalEvent.srcElement).hasClass('close')) {
          $(element).removeClass($(this).attr('rel'));
        }
        else if (!$(element).hasClass($(this).attr('rel'))) {
          $(element).addClass($(this).attr('rel'));
          $(element).find('input').focus();
        }
      });
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
