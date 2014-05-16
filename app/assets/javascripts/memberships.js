$(document).ready(function(){

  $('.membership a.join').on('click', function(){
    var $membership_button = $(this)
    var join_url = $membership_button.attr('href');
    
    $.colorbox({href:"/user/confirm_membership"});
    
    $('a.confirm_membership').on('click', function(){
      $.post(join_url, function(data) {
        $.colorbox.close();
      });
      return false
    })
    
    $('a.cancel').on('click', function(){
        $.colorbox.close();
        return false
      });
    return false
    });  
});