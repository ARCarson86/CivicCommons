(function(){
  $ = this.jQuery;
  $(document).ready(function(){
    var $newConvoForm = $('form#new_conversation')
    $newConvoForm.bind('submit',function(e){
      
      var $agreeToBeCivilCheckbox =  $(this).find('input#conversation_agree_to_be_civil');
      var aggreeToBiCivilChecked = $agreeToBeCivilCheckbox.attr('checked');
      var $permissionToUseImageCheckbox =  $(this).find('input#conversation_permission_to_use_image');
      var permissionToUseImageChecked = $permissionToUseImageCheckbox.attr('checked');
      var $imageInput = $(this).find('input#conversation_image');
      var imageInputExists = $imageInput.val() != "";
      
      if(imageInputExists == true && permissionToUseImageChecked == false){
        
        //open the colorbox
        $.colorbox({
          href:'/conversations/permission_to_use_image_modal', 
          opacity: 0.4,
          onComplete: function(){
            var $modal = $('#permission-to-use-image-modal');
            var $checkbox = $('#agree-on-permission-to-use-image-modal', $modal)
            var $continueButton = $('.continue',$modal);
            $continueButton.click(function(){
              if($checkbox.attr('checked') == true){
                $permissionToUseImageCheckbox.attr('checked',true);
                $.colorbox.close();
                setTimeout(function(){
                  $newConvoForm.submit();
                },500)
              }
              return false;
            })
          }
        })
        
        return false
      }else if(aggreeToBiCivilChecked == false){

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
                setTimeout(function(){
                  $newConvoForm.submit();
                },500)
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
