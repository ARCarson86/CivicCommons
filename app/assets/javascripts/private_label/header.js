(function($) {
	$(document).on("click", "#pl-search", function(event) {
		event.preventDefault();
		$('#pl-search-form').toggleClass('hide');
		if (!$('#pl-search-form').hasClass('hide')){
			$('#pl-search-form').find('.textbox').focus();
		}
	});

	$(document).on("click", "#profile-more", function(event) {
		event.preventDefault();
		$('#profile-options').toggleClass('hide');
	});
})(jQuery);