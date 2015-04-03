(function($) {
	$(document).on("click", "#pl-search", function(event) {
		event.preventDefault();
		$('#header-wrapper .header-util-item').addClass('hide');
		$('#header-wrapper .navbar-right .nav-user-info').removeClass('active');
		var classTest = $(this).parent().hasClass('active');
		console.log(classTest);
		if (classTest){
			$('#header-wrapper .header-utilities').addClass('hide');
			$('#pl-search-form').addClass('hide');
			$(this).parent().removeClass('active');
		}
		else{
			$('#header-wrapper .header-utilities').removeClass('hide');
			$('#pl-search-form').removeClass('hide');
			$('#pl-search-form').find('.form-control input').focus();
			$(this).parent().addClass('active');
		}

		
		
	});

	$(document).on("click", "#profile-more", function(event) {
		event.preventDefault();
		$('#header-wrapper .header-util-item').addClass('hide');
		$('#header-wrapper .navbar-right #nav-search').removeClass('active');
		var classTest = $(this).parent().hasClass('active');
		console.log(classTest);
		if (classTest){
			$('#header-wrapper .header-utilities').addClass('hide');
			$('#profile-options').addClass('hide');
			$(this).parent().removeClass('active');
		}
		else{
			$('#header-wrapper .header-utilities').removeClass('hide');
			$('#profile-options').removeClass('hide');
			$(this).parent().addClass('active');
		}
	});

	$(document).on('click', '#header-wrapper .toggle-nav', function(event){
		event.preventDefault();
		$('#header-wrapper .collapse-nav').toggleClass('nav-hide');
		$(this).toggleClass('active');
	});
})(jQuery);