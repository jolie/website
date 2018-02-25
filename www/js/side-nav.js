
(function() {
	$(".button-collapse").sideNav();

	$("#slide-out a").click(function() {
		$('.button-collapse').sideNav('hide');
	});
})();