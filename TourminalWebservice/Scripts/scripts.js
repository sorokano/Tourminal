$(document).ready(function(){
    $('.tip_content').hide();

    $('.show_tip').toggle(
		function () {
		    $('.show_tip').addClass('fly_down');
		    $('.tip_content').slideDown('slow',
				function callback() {
				    $('.show_tip').removeClass('fly_down');
				    $('.show_tip').addClass('fly_up');
				}
			);
		}, function () {
		    $('.tip_content').slideUp(
				function callback() {
				    $('.show_tip').removeClass('fly_up');
				}
			);
		}
	);
	

});