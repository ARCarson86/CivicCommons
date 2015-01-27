(function($) {
  var defaults = {
    script_url : '/assets/tiny_mce/tiny_mce_src.js',
    theme : "advanced",
    skin : 'private_label',
    plugins : "autolink,inlinepopups,mention,noneditable",
    width : '100%',
    theme_advanced_buttons1 : "bold,italic,underline,pllink,plimage",
    theme_advanced_buttons2 : "",
    theme_advanced_buttons3 : "",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "none",
    extended_valid_elements: "a[title|href|target=_blank|title|class=mceNonEditable|data-mention-id]",
    content_css: '/assets/private_label/editor.css',
    setup : function(ed) {
        // Add a custom button
        ed.addButton('pllink', {
            title : 'Link',
            image : '/assets/private_labels/link-icon.png',
            onclick : function() {
                // Add you own code to execute something on click
                ed.focus();
                $(ed.formElement).find('.contribution-attachments').removeClass('hide');
                if ($(ed.formElement).find('.contribution-attachments .add-file').hasClass('hide') == false){
                  $(ed.formElement).find('.contribution-attachments .add-file').addClass('hide');
                  $(ed.formElement).find('#contribute-text_plimage').removeClass('mceButtonActive');
                }
                $(ed.formElement).find('#contribute-text_pllink').toggleClass('mceButtonActive');
                $(ed.formElement).find('.contribution-attachments .add-link').toggleClass('hide');
            }
        });
        ed.addButton('plimage', {
            title : 'Image',
            image : '/assets/private_labels/image-icon.png',
            onclick : function() {
                // Add you own code to execute something on click
                ed.focus();
                $(ed.formElement).find('.contribution-attachments').removeClass('hide');
                if ($(ed.formElement).find('.contribution-attachments .add-link').hasClass('hide') == false){
                  $(ed.formElement).find('.contribution-attachments .add-link').addClass('hide');
                  $(ed.formElement).find('#contribute-text_pllink').removeClass('mceButtonActive');
                }
                $(ed.formElement).find('#contribute-text_plimage').toggleClass('mceButtonActive');
                $(ed.formElement).find('.contribution-attachments .add-file').toggleClass('hide');
            }
        });
    },
    mentions: {
      source: function(query, process) {
        var conversation_id = $("[data-conversation-id]").data("conversation-id");
        $.ajax({
          datatype: "json",
          url: "/conversations/"+conversation_id+"/people",
          data: {
            term: query
          },
          success: function(data) {
            var contributors = _.map(data, function(person) {
              if (person.organization != undefined) {
                return person.organization;
              }
              return person.person;
            });
            process(contributors);
          }
        });
      },
      render: function(item) {
        var out = "<li>";
        out += '<a href="javascript:;"><span data-mention="'+item.id+'">' + item.name + '</span></a>';
        return out;
      },
      insert: function(item) {
        return '<a href="/user/'+item.friendly_id+'" class="mceNonEditable" data-mention="'+item.id+'">'+item.name+'</a>';
      }
    }
  };

  $(document).on("focus", ".editable textarea", function(event) {
    $(this).parent(".editable").addClass("editor-active");
    options = $.extend({}, defaults, {auto_focus: $(this).attr("id")});
    console.log($(this));
    $(this).tinymce(options);

    $(this).parents('.contribute-form').find('.contribute-actions').removeClass('hide');
  });
  $(document).on("click", ".contribute-actions .cancel", function(event) {
    event.preventDefault();
    var $editable = $(this).parents(".contribute-form").find('.editable');
    var $textarea = $($editable).children("textarea").first();
    $editable.removeClass("editor-active");
    $($textarea).text("");
    if ($($textarea).tinymce() != undefined) {
      $($textarea).tinymce().remove();
    }
    $(this).parents('.contribute-form').find('.contribution-attachments .add-link, .contribution-attachments .add-file').addClass('hide');
    $(this).parent().addClass('hide');
  });
  $(document).on("click", ".contribution-header .reply-to-contribution", function(event) {
    event.preventDefault();
    $('html, body').animate({
        scrollTop: $(this).closest('.contribution-wrapper').find('.reply-form').offset().top
    }, 'fast');
    $(this).closest('.contribution-wrapper').find('.reply-form .editable textarea').focus();
  });
  $(document).on("click", ".private_labels-conversations .recent-activities .item-header .reply", function(event) {
    event.preventDefault();
    var contributionID = $(this).parents('.item').attr('id');
    $('html, body').animate({
        scrollTop: $('.conversation-contributions').find('#'+contributionID).closest('.contribution-wrapper').find('.reply-form').offset().top
    }, 'fast');
    $('.conversation-contributions').find('#'+contributionID).closest('.contribution-wrapper').find('.reply-form .editable textarea').focus();
  });
  $(document).on("click", ".contribution-attachments .close", function(event) {
    event.preventDefault();
    $(this).parents('form').find('#contribute-text_pllink, #contribute-text_plimage').removeClass('mceButtonActive');
    $(this).parents('.button').addClass('hide');
  });

  function MoveTo(path) {
    var arr = path.split('-')
    if ((arr[0] == 'reply') && (arr[1] != '' || undefined)){
      $('html, body').animate({
        scrollTop: $('.conversation-contributions').find('#contribution-'+arr[1]).closest('.contribution-wrapper').find('.reply-form').offset().top
    }, 'fast');
      $('.conversation-contributions').find('#contribution-'+arr[1]).closest('.contribution-wrapper').find('.reply-form .editable textarea').focus();
    }
    
    }
    $(document).on('ready', function(){
       MoveTo(window.location.hash.replace('#', ''));
    })
})(jQuery);