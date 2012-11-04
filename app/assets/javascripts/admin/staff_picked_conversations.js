$(document).ready(function(){
  $('.staff-picked input.conversation-position').change(function(){
    $(this).closest('form').submit();
  })
  $('.staff-picked form.edit_conversation').submit(function(){
    $('input.conversation-position:not(#'+$('.conversation-position',this).attr('id')+')').attr("disabled", true);
  })
});
