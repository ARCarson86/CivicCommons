(function($) {
  $.fn.editable = function(options) {
    var settings = $.extend({
      input_name: $(this).find('textarea').attr('name')
    }, options);
    console.log(settings);
    var editor = null;

    methods = {
      initialize: function(options) {
      },
      destroy: function() {
        this.editor.destroy();
      }
    };

    return this.each(function() {
    }
  };
}, jQuery)
