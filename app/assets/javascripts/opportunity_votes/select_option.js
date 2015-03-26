var showRankOptionTab = function(){
  $('.rank-options-tab').fadeIn('slow');

  var $submit_button = $('input.continue.opportunity-button');
  var max_selected_options = $submit_button.closest('form').data('max-selected-options');
  if (parseInt(max_selected_options) > 1){
    $submit_button.val('Continue');
  }
}
var hideRankOptionTab = function(){
  $('.rank-options-tab').fadeOut('slow');

  var $submit_button = $('input.continue.opportunity-button');
  var max_selected_options = $submit_button.closest('form').data('max-selected-options');
  if (parseInt(max_selected_options) > 1){
    $submit_button.val('Cast my Vote');
  }
}
var selectOptionCheckBoxBehavior = function(){
  var $checked_boxes = $('input.option-checkbox:checked');
  var checked_count = $checked_boxes.length;
  if(checked_count < 1 || checked_count > 1){
    showRankOptionTab();
  }else{
    hideRankOptionTab();
  };
}

$(document).ready(function() {
  // initialize with the checkbox behavior
  selectOptionCheckBoxBehavior();
  
  $('input.option-checkbox').change(function(){
    selectOptionCheckBoxBehavior()
  })
  
})

