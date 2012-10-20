$(document).ready(function(){
  $('input#agree').click(function() {
    $(this).parent('div.inset').toggleClass('checked').removeClass('cbx-error');
    $('p.cbx-error-message').hide();
  });

  $('a.verify').click(function () {
    $unchecked_check_box = $('input#agree:not(:checked)');
    $unchecked_check_box.parent('div.inset').addClass('cbx-error');
    $unchecked_check_box.parent().siblings('p.cbx-error-message').show();
    if($unchecked_check_box.length < 1){
      return true;
    }else{
      return false;
    }
  });

  // user registration form
  $("a.no-fb").click(function() {
    $(".regular-reg").fadeIn();
    $(".facebook-auth").hide();
    return false;
  });

  $('.register a.cancel').click(function() {
    $(".regular-reg").hide();
    $(".facebook-auth").show();
    return false;
  })
});
