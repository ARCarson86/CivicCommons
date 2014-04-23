//authentication
jQuery(function ($) {

  function popupCenter(url, width, height, name) {
    var left = (screen.width/2)-(width/2);
    var top = (screen.height/2)-(height/2);
    return window.open(url, name, "menubar=no,toolbar=no,status=no,resizable=yes,width="+width+",height="+height+",left="+left+",top="+top);
  }

  $(document).ready(function() {
    $("a.createacct-link.facebook-auth").on('click', function(e) {
      if(window.location.href.indexOf('/people/login') != -1) {
        popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
      } else {
        window.location = '/people/login';
      }
      e.preventDefault();
    });

    $("a.connectacct-link.facebook-auth:not(.disconnect-fb)").on('click', function(e) {
      popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
      e.preventDefault();
    });

    $('.fb-modal a.cancel')
    .on('click',function(){
      $.colorbox.close();
      return false;
    });

    $('.fb-modal a.confirm-facebook-unlinking, a.connectacct-link.facebook-auth.disconnect-fb')
    .on('click',function(){
      $.colorbox({href:$(this).attr('href')});
      return false;
    });

    /*
      conflicting_email modal dialog
    */
    $('.fb-cnct-links a.overwrite-email').on('click',function(){
       $.post($(this).attr('href'),function(){
         $.colorbox({href:'/authentication/fb_linking_success'});
       });
      return false;
    });

    $('.fb-cnct-links a.cancel-overwrite-email').on('click',function(){
      $.colorbox({href:'/authentication/fb_linking_success'});
      return false;
    });

    $('form#ajax-auth-update-form')
    .on('ajax:success', function(evt, xhr, status, error){
      $(this).html(xhr);
    });

    $('#auth-before-facebook-unlinking') 
    .on('ajax:success', function(evt, xhr, status, error){
      $(this).replaceWith(xhr);
    });

  });
});
