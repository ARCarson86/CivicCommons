(function($) {
  var defaults = {
    script_url : '/assets/tinymce/tiny_mce_src.js',
    theme : "advanced",
    skin : 'private_label',
    plugins : "autolink,inlinepopups,noneditable",
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
      var linkActive = false;
      var imageActive = false;

      function toggleAttachments() {
        $(ed.formElement).find('.mce_pllink').removeClass('mceButtonActive');
        $(ed.formElement).find('.contribution-attachments .add-link').addClass('hide');

        $(ed.formElement).find('.mce_plimage').removeClass('mceButtonActive');
        $(ed.formElement).find('.contribution-attachments .add-file').addClass('hide');

        if (linkActive) {
          $(ed.formElement).find('.mce_pllink').addClass('mceButtonActive');
          $(ed.formElement).find('.contribution-attachments .add-link').removeClass('hide');
          $(ed.formElement).find('.contribution-attachments').removeClass('hide');

          $(ed.formElement).find('.contribution-attachments .add-link #contribution_url').focus();
        }
        else if (imageActive) {
          $(ed.formElement).find('.mce_plimage').addClass('mceButtonActive');
          $(ed.formElement).find('.contribution-attachments .add-file').removeClass('hide');
          $(ed.formElement).find('.contribution-attachments').removeClass('hide');
        }
        else {
          $(ed.formElement).find('.contribution-attachments').addClass('hide');
        }

        if (!linkActive) {
          setTimeout(function() {
            ed.focus();
          }, 100);
        }

      }

      ed.addButton('pllink', {
        title : 'Link',
        image : '/assets/private_labels/link-icon.png',
        onclick : function() {
          imageActive = false;
          linkActive = !linkActive;
          toggleAttachments();
        }
      });

      ed.addButton('plimage', {
        title : 'Image',
        image : '/assets/private_labels/image-icon.png',
        onclick : function() {
          linkActive = false;
          imageActive = !imageActive;
          toggleAttachments();
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
    $(this).tinymce(options);

    $(this).parents('.contribute-form').find('.pre-actions').addClass('hide');
    $(this).parents('.contribute-form').find('.contribute-actions').removeClass('hide');
    $(this).jump();
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
    $(this).parents('.contribute-form').find('.contribution-attachments, .contribution-attachments .add-link, .contribution-attachments .add-file').addClass('hide');
    $(this).parent().addClass('hide');
    $(this).parents('.contribute-form').find('.pre-actions').removeClass('hide');
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
  $(document).on("click", ".contribution-attachments .close", function(event) {
    event.preventDefault();
    $(this).parents('form').find('#contribute-text_pllink, #contribute-text_plimage').removeClass('mceButtonActive');
    $(this).parents('.button').addClass('hide');
  });
  $(document).on("click", ".editable .pre-actions .upload-image", function(event) {
    event.preventDefault();
    var $editable = $(this).parents(".contribute-form").find('.editable');
    var $textarea = $($editable).children("textarea").first();

    $textarea.focus();
    setTimeout(function(){ 
      $editable.parent().find('.mce_plimage').addClass('mceButtonActive');
      $editable.parent().find('.contribution-attachments, .contribution-attachments .add-file').removeClass('hide');
    }, 300);
  });
  $(document).on("click", ".editable .pre-actions .upload-link", function(event) {
    event.preventDefault();
    var $editable = $(this).parents(".contribute-form").find('.editable');
    var $textarea = $($editable).children("textarea").first();

    $textarea.focus();
    setTimeout(function(){ 
      $editable.parent().find('.mce_pllink').addClass('mceButtonActive');
      $editable.parent().find('.contribution-attachments, .contribution-attachments .add-link').removeClass('hide');
      $editable.parent().find('#contribution_url').focus();
    }, 300);
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
