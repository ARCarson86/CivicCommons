var lastAjaxSettings;

jQuery.uaMatch = function( ua ) {
	ua = ua.toLowerCase();

	var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
		/(webkit)[ \/]([\w.]+)/.exec( ua ) ||
		/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
		/(msie) ([\w.]+)/.exec( ua ) ||
		ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
		[];

	return {
		browser: match[ 1 ] || "",
		version: match[ 2 ] || "0"
	};
};

// Don't clobber any existing jQuery.browser in case it's different
if ( !jQuery.browser ) {
	matched = jQuery.uaMatch( navigator.userAgent );
	browser = {};

	if ( matched.browser ) {
		browser[ matched.browser ] = true;
		browser.version = matched.version;
	}

	// Chrome is Webkit, but Webkit is also Safari.
	if ( browser.chrome ) {
		browser.webkit = true;
	} else if ( browser.webkit ) {
		browser.safari = true;
	}

	jQuery.browser = browser;
}

(function ($) {
  $.fn.extend({
    scrubPlaceholderText: function(){
      $(this).find('input[placeholder], textarea[placeholder]').each( function() {
        $this = $(this);
        if( $this.val() == $this.attr('placeholder') ){
          $this.val('');
        }
      });
    },
    scrollTo: function(){
      var $this = this;
      if(this.offset() == undefined) { return; }
      var top = this.offset().top - 230; // 160px top padding in viewport,
      var origBG = this.css('background') || 'transparent';
      var scrolled = false; // Hack since 'html,body' is the only cross-browser compatible way to scroll window

      $('html,body').animate({scrollTop: top}, 1000, function (){
        if ( ! scrolled ) { $this.effect('highlight', {color: '#c5d36a'}, 3000); }
        scrolled = true;
      });
      return $this;
    }
  });
})(jQuery);

jQuery(function ($) {

  // Log all jQuery AJAX requests to Google Analytics
  $(document).ajaxSend(function(event, xhr, settings){
    if(typeof(_gaq) != 'undefined') {
      _gaq.push(['_trackPageview', settings.url]);
      if ( settings.url != "/people/ajax_login" ) {
        lastAjaxSettings = settings;
        lastAjaxEvent = event;
        lastAjaxIsColorbox = $('#colorbox').is(':visible');
      }
    }
  });

  $('#ajax-login-form')
  .on('ajax:error', function(evt, xhr, status, error){
    alert('Login failed!');
  });


});

$(document).ready(function(){
  $('a[data-colorbox]').not('[data-remote]').on('click', function(e){
    $.colorbox({
      transition: 'fade', // needed to fix colorbox bug with jquery 1.4.4
      href: $(this).attr('href')
    });
    e.preventDefault();
  });

  $('.flash-notice').show('blind');
  setTimeout(function(){
    $('.flash-notice').hide('blind');
  },5000);

  // set defaults for CKEditor
  if('CKEDITOR' in window) {
    CKEDITOR.on('dialogDefinition', function(event) {
      var dialogName = event.data.name;
      var dialogDefinition = event.data.definition;

      if(dialogName == 'link') {
        var targetTab = dialogDefinition.getContents('target');
        var targetField = targetTab.get('linkTargetType');
        targetField['default'] = '_blank';
      }

      if(dialogName == 'image') {
        var uploadPageID = 'Upload';
        dialogDefinition.removeContents('advanced');
        dialogDefinition.removeContents('Link');

        if(ckDialogPageExists(dialogDefinition, uploadPageID)) {
          var oldMethod = dialogDefinition.onShow;
          var oldArguments = arguments;

          dialogDefinition.onShow = function() {
            this.selectPage(uploadPageID);
            this.on('selectPage', ckRemoveLoadIcon);
            if(typeof oldMethod == 'function') {
              oldMethod.apply(this, oldArguments);
            }

            var uploadButton = this.getContentElement('Upload', 'uploadButton');
            var $uploadButton = $('#' + uploadButton.domId);

            // if the span for the button recieves 'upload-complete' it will dismiss the loading icon
            $uploadButton.bind('upload-complete', function(event){
              $(this).find('.loading-icon').remove();
            });

            $uploadButton.click(function(event){
              if(event.currentTarget == this &&
                $(this).find('.loading-icon').length === 0 &&
                CKEDITOR.dialog.getCurrent().getContentElement('Upload', 'upload').getValue() !== '') {
                var $spinner = $('<img class="loading-icon" src="//s3.amazonaws.com/com.theciviccommons.production/images/general/loading.gif" style="padding-left: 5px; vertical-align: middle;" />');
                $(this).find('span').append($spinner);
              }
            });
          };
        }
      }
    });
  }
});

function ckRemoveLoadIcon() {
  var $button = $('span.cke_dialog_ui_button:contains("Send it to the Server")');
  $button.trigger('upload-complete');
}

function ckDialogPageExists(dialogDefinition, pageID) {
  var i = 0;
  for(i = 0; i < dialogDefinition.contents.length; i++) {
    if(dialogDefinition.contents[i].id === pageID) {
      return true;
    }
  }
  return false;
}

var civic = function() {
  var displayMessage = function(message, cssClass) {
    var messageDiv = $("<div>")
      .addClass(cssClass)
      .addClass("message")
      .text(message)
      .appendTo($("body"));

    setTimeout(function() { messageDiv.fadeOut();}, 4000);
  };
  var self = {};
  self.error = function(message) { displayMessage(message, "error"); };
  self.alert = function(message) { displayMessage(message, "alert"); };
  return self;
}();

function flashMessage(message) {
  var flash = $("<div class=\"flash-notice\">"+message+"<img class=\"flash-close\" alt=\"Flash-close\" src=\"/assets/flash-close.png\"></div>").appendTo("body");
  setTimeout(function() {
    flash.fadeOut('fast', function() {
      $(this).remove();
    });
  }, 4000);
}

$(document).delegate(".flash-close", "click", function(event) {
  $(this).parent(".flash-notice").fadeOut('fast', function() {
    $(this).remove();
  });
});
