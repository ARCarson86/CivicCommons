$(document).ready(function() {

  $('.notification-container .dropdown-toggle').click(function(){
    $.ajax({
      type: "post",
      url: "/notifications/viewed",
      success: function() {
        $('.notification-info').html("0");
        $('.notification-main').addClass('notification-inactive')
        $('.notification-main').removeClass('notification-active')
      }
    });
  });

  $('html').click(function (e) {
    if ($(e.target).parents('.notification-container').length == 0) {
      $('.notification-container .dropdown-menu').slideUp('ease');
    }
  });

});
