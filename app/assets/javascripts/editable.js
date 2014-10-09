(function($) {
  var defaults = {
    script_url : '/assets/tiny_mce/tiny_mce_src.js',
    theme : "advanced",
    plugins : "autolink,inlinepopups",
    width : '100%',
    theme_advanced_buttons1 : "bold,italic,underline,|,link,unlink,|,bullist,numlist,|,undo,redo,|,cut,copy,paste",
    theme_advanced_buttons2 : "",
    theme_advanced_buttons3 : "",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "none",
    extended_valid_elements: "a[title|href|target=_blank|title]",
  };

  $(document).on("focus", ".editable textarea", function(event) {
    $(this).parent(".editable").addClass("editor-active");
    options = $.extend({}, defaults, {auto_focus: $(this).attr("id")});
    $(this).tinymce(options);
    var popup = $(this).closest('#popup-holder').children('.popup');
    $(popup).addClass('active');
    $.cookie('hide_popup', true);
    setTimeout(func, 4000);
      function func() {
        $(popup).removeClass('active');
      }
  });
  $(document).on("click", ".editable .cancel", function(event) {
    event.preventDefault();
    var $editable = $(this).closest(".editable");
    var $textarea = $($editable).children("textarea").first();
    $editable.removeClass("editor-active");
    $($textarea).text("");
    if ($($textarea).tinymce() != undefined) {
      $($textarea).tinymce().remove();
    }
  });

})(jQuery);
