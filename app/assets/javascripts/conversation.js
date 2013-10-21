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
    $('.thread').each(function(index, element) {
      $(element).delegate('a.expand', 'click', function(event) {
        event.preventDefault();
        $(element).addClass('expanded');
        $(element).find('textarea').focus();
        $(element).find('textarea').trigger('focus');
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
