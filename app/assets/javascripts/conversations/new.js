(function(){
  $ = this.jQuery;
  $(document).ready(function(){
    var $newConvoForm = $('form#new_conversation')
    $newConvoForm.bind('submit',function(e){
      
      // get checked value for 'agree to be civil'
      var $agreeToBeCivilCheckbox =  $(this).find('input#conversation_agree_to_be_civil');
      var aggreeToBiCivilChecked = $agreeToBeCivilCheckbox.attr('checked');
      if(aggreeToBiCivilChecked == false){

        //open the colorbox
        $.colorbox({
          href:'/conversations/agree_to_be_civil_modal', 
          opacity: 0.4,
          onComplete: function(){
            var $modal = $('#agree-to-be-civil-modal');
            var $checkbox = $('#agree-on-agree-to-be-civil-modal', $modal)
            var $continueButton = $('.continue',$modal);
            $continueButton.click(function(){
              if($checkbox.attr('checked') == true){
                $agreeToBeCivilCheckbox.attr('checked',true);
                $.colorbox.close();
                $newConvoForm.submit();
              }
              return false;
            })
          }
        })

        return false
      }
    });
  });
}).call(this);
