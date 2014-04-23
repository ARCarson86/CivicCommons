//Surveys
function updateSelectedOptionID(){
  updateOptionID(this)
}

function updateOptionID(selector){
  var value = '';
  var $input = $(selector).find('input.selected_option_id')[0];
  var $selected_option = $(selector).find('.survey-option')[0];
  if($selected_option){ value = $($selected_option).data('option-id');}    
  $($input).val(value);
  $($selected_option).height('');
}

function receivingItem(event,ui){
  if($(this).find('.survey-option').length > 1){
    var current_id = ui.item.data('option-id');
    var $existing_item = $(this).find('.survey-option[data-option-id!='+current_id+']').first();
    $existing_item.hide();
    $(ui.sender).append($existing_item);
    $existing_item.siblings('.placeholder').hide();
    $existing_item.show('fast');
    $existing_item.equalHeights();
    updateOptionID(ui.sender);
  }
  $(this).find('.placeholder').hide();
}


function showPlaceHolder(event,ui){
  $(this).find('.placeholder').addClass('over').show();
}
function hidePlaceHolder(event,ui){
  $(ui.item).siblings('.placeholder').hide();
}

function addActivePlaceholder(event,ui){
   $('.selected-survey-options .placeholder').removeClass('over');
  $('.selected-survey-options .survey-option-locator').siblings('.placeholder').addClass('over');
}

function removeActivePlaceholder(event,ui){
  $('.selected-survey-options .placeholder').removeClass('over');
}

jQuery(function ($) {
  $(document).ready(function() {
  
    $('.survey-options .survey-option').equalHeights();
    
    //drag and drop of the votes
    if($('.selected-survey-options input.submit').attr('disabled') != true){
      $('.survey-options:not(.disabled) .sortable').sortable({ 
        connectWith: '.selected-survey-options .sortable',
        cursor: 'crosshair',
        receive: function(event,ui){
          console.log(this);
          $(ui.item).equalHeights();
        },
        placeholder: "survey-option-locator",
        over: removeActivePlaceholder
      });

      $('.selected-survey-options .sortable').sortable({ 
        connectWith: '.survey-options .sortable, .selected-survey-options .sortable',
        items: 'div.survey-option',
        over: addActivePlaceholder,
        out: removeActivePlaceholder,
        update: updateSelectedOptionID,
        receive: receivingItem,
        placeholder: "survey-option-locator",
        start: showPlaceHolder,
        stop: hidePlaceHolder
      });
      
    }
    
    // expand contract of the options
    $('.survey-option .expand').click(function(){
      $(this).closest('.survey-option').find('.description').show();
      $(this).siblings('.contract').show();
      $(this).hide();
      $(this).closest('.survey-option').height('');
      $(this).closest('.survey-option').equalHeights();
      return false;
    });
    
    $('.survey-option .contract').click(function(){
      $(this).closest('.survey-option').find('.description').hide();
      $(this).siblings('.expand').show();
      $(this).closest('.survey-option').height('');
      $(this).closest('.survey-option').equalHeights();
      $(this).hide()
      return false;
    });
    
    //unselect the survey options
    $('.survey-option .unselect').click(function(){
      var $sortable = $(this).closest('.sortable')
      $sortable.find('.placeholder').show();
      $('.survey-options .sortable').append($(this).closest('.survey-option'))
      updateOptionID($sortable);
      $(this).closest('.survey-option').equalHeights();
      return false;
    });
    
    $('.survey-option .select').click(function(){
      // $(this).closest('.sortable').find('.placeholder').show();
      // $('.survey-options .sortable').append($(this).closest('.survey-option'))
      $empty_vote = $('.selected_option_id').filter(function() { return $(this).val() == ""; }).first();
      $sortable = $empty_vote.closest('.sortable');
      $sortable.find('.placeholder').hide();
      $sortable.append($(this).closest('.survey-option'));
      updateOptionID($sortable);
      $(this).closest('.survey-option').height('');
      return false;
    });
    
    
    // close colorbox on cancelation of confirmation
    $('a.cancel_vote').on('click', function(){
      $.colorbox.close();
      return false;
    })
    
    // submits the form with without AJAX when the vote has been confirmed.
    $('a.confirm_vote').on('click', function(){
      var $form = $('.selected-survey-options form');
      var $confirmed_input = $("<input>").attr("type", "hidden").attr("name", "survey_response_presenter[confirmed]").val("true");
      $form.removeAttr('data-remote');
      $form.append($confirmed_input);
      $form.submit();
      return false;
    })
    
    
  });
});
