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
    $('.threads .thread .actions .action.expandabl').hover(function() {
      $(this).addClass("expanded");
    }, function() {
      $(this).removeClass("expanded");
    });
    $(".thread .content").readmore();
  });
})(jQuery)
