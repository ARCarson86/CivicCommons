(function() {
  $ = this.jQuery;

  $.fn.extend({
    ratingButton: function() {
      var button = this;
      button.on('ajax:before', function() {
       button.children('.loading').show();
      });
      button.on('ajax:complete', function() {
        button.children('.loading').hide();
      });
      return this;
    }
  });


}).call(this);
