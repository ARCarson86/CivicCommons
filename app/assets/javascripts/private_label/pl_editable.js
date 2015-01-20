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
            image : '/assets/private_label/link-icon.png',
            onclick : function() {
                // Add you own code to execute something on click
                ed.focus();
                $('.contribution-attachments .add-link').toggleClass('hide');
            }
        });
        ed.addButton('plimage', {
            title : 'Image',
            image : '/assets/private_label/image-icon.png',
            onclick : function() {
                // Add you own code to execute something on click
                ed.focus();
                $('.contribution-attachments .add-file').toggleClass('hide');
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
})(jQuery);