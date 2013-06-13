(function ($) {
		$.fn.cross = function (options) {
			return this.each(function (i) { 
				var $$ = $(this);
				var target = $$.css('backgroundImage').replace(/^url|[\(\)'"]/g, '');
				$$.wrap('<span style="position: relative; margin: -4px;"></span>')
					.parent()
					.prepend('<img>')
					.find(':first-child')
					.attr('src', target);
					
				if ($.browser.mozilla) {
					$$.css({
						'position' : 'absolute',
						'left' : 0,
						'background' : '',
						'top' : this.offsetTop
					});
					} else if ($.browser.msie && $.browser.version < 7) {
					$$.css({
						'position' : 'absolute',
						'left' : 0,
						'background' : '',
						'top' : "0",
						'margin-left' : -4
					});
					} else if ($.browser.msie && $.browser.version > 6) {
					$$.css({
						'position' : 'absolute',
						'left' : 0,
						'background' : '',
						'top' : "0",
						'margin-left' : 0
					});					
					} else if ($.browser.opera) {       
					$$.css({
						'display' : 'none'
					});
				} else {
					$$.css({
						'position' : 'absolute', 
						'left' : 0,
						'background' : ''
					});
				}

				$$.hover(function () {
					$$.stop().animate({
						opacity: 0
					}, 350);
				}, function () {
					$$.stop().animate({
						opacity: 1
				}, 350);
			});
		});
	};
})(jQuery);

$(window).bind('load', function () {
	//$('img.fade').cross();
});

if ($.browser.msie && $.browser.version < 7) {
	$(function () {
	  $('.bubbleInfo').each(function () {
	    // options
	    var distance = 5;
	    var time = 5;
	    var hideDelay = 250;

	    var hideDelayTimer = null;

	    // tracker
	    var beingShown = false;
	    var shown = false;
	    
	    var trigger = $('.buttonArea', this);
	    var popup = $('.popup', this).css('opacity', 0);

	    // set the mouseover and mouseout on both element
	    $([trigger.get(0), popup.get(0)]).mouseover(function () {
	      // stops the hide event if we move from the trigger to the popup element
	      if (hideDelayTimer) clearTimeout(hideDelayTimer);

	      // don't trigger the animation again if we're being shown, or already visible
	      if (beingShown || shown) {
	        return;
	      } else {
	        beingShown = true;
			
	        // reset position of popup box
	        popup.css({
	          top: 0,
	          left: 30,
	          display: 'block' // brings the popup back in to view
	        })

	        // (we're using chaining on the popup) now animate it's opacity and position
	        .animate({
	          top: '-=' + distance + 'px',
	          opacity: 1
	        }, time, 'swing', function() {
	          // once the animation is complete, set the tracker variables
	          beingShown = false;
	          shown = true;
	        });
	      }
	    }).mouseout(function () {
	      // reset the timer if we get fired again - avoids double animations
	      if (hideDelayTimer) clearTimeout(hideDelayTimer);
	      
	      // store the timer so that it can be cleared in the mouseover if required
	      hideDelayTimer = setTimeout(function () {
	        hideDelayTimer = null;
	        popup.animate({
	          top: '-=' + distance + 'px',
	          opacity: 0
	        }, time, 'swing', function () {
	          // once the animate is complete, set the tracker variables
	          shown = false;
	          // hide the popup entirely after the effect (opacity alone doesn't do the job)
	          popup.css('display', 'none');
	        });
	      }, hideDelay);
	    });
	  });
	});
} else if ($.browser.msie && $.browser.version > 6) {
	$(function () {
	  $('.bubbleInfo').each(function () {
	    // options
	    var distance = 5;
	    var time = 5;
	    var hideDelay = 250;

	    var hideDelayTimer = null;

	    // tracker
	    var beingShown = false;
	    var shown = false;
	    
	    var trigger = $('.buttonArea', this);
	    var popup = $('.popup', this).css('opacity', 0);

	    // set the mouseover and mouseout on both element
	    $([trigger.get(0), popup.get(0)]).mouseover(function () {
	      // stops the hide event if we move from the trigger to the popup element
	      if (hideDelayTimer) clearTimeout(hideDelayTimer);

	      // don't trigger the animation again if we're being shown, or already visible
	      if (beingShown || shown) {
	        return;
	      } else {
	        beingShown = true;
			
	        // reset position of popup box
	        popup.css({
	          top: 0,
	          left: 50,
	          display: 'block' // brings the popup back in to view
	        })

	        // (we're using chaining on the popup) now animate it's opacity and position
	        .animate({
	          top: '-=' + distance + 'px',
	          opacity: 1
	        }, time, 'swing', function() {
	          // once the animation is complete, set the tracker variables
	          beingShown = false;
	          shown = true;
	        });
	      }
	    }).mouseout(function () {
	      // reset the timer if we get fired again - avoids double animations
	      if (hideDelayTimer) clearTimeout(hideDelayTimer);
	      
	      // store the timer so that it can be cleared in the mouseover if required
	      hideDelayTimer = setTimeout(function () {
	        hideDelayTimer = null;
	        popup.animate({
	          top: '-=' + distance + 'px',
	          opacity: 0
	        }, time, 'swing', function () {
	          // once the animate is complete, set the tracker variables
	          shown = false;
	          // hide the popup entirely after the effect (opacity alone doesn't do the job)
	          popup.css('display', 'none');
	        });
	      }, hideDelay);
	    });
	  });
	});
} else {
	$(function () {
	  $('.bubbleInfo').each(function () {
	    // options
	    var distance = 5;
	    var time = 5;
	    var hideDelay = 250;

	    var hideDelayTimer = null;

	    // tracker
	    var beingShown = false;
	    var shown = false;
	    
	    var trigger = $('.buttonArea', this);
	    var popup = $('.popup', this).css('opacity', 0);

	    // set the mouseover and mouseout on both element
	    $([trigger.get(0), popup.get(0)]).mouseover(function () {
	      // stops the hide event if we move from the trigger to the popup element
	      if (hideDelayTimer) clearTimeout(hideDelayTimer);

	      // don't trigger the animation again if we're being shown, or already visible
	      if (beingShown || shown) {
	        return;
	      } else {
	        beingShown = true;
			
	        // reset position of popup box
	        popup.css({
	          top: 0,
	          left: 30,
	          display: 'block' // brings the popup back in to view
	        })

	        // (we're using chaining on the popup) now animate it's opacity and position
	        .animate({
	          top: '-=' + distance + 'px',
	          opacity: 1
	        }, time, 'swing', function() {
	          // once the animation is complete, set the tracker variables
	          beingShown = false;
	          shown = true;
	        });
	      }
	    }).mouseout(function () {
	      // reset the timer if we get fired again - avoids double animations
	      if (hideDelayTimer) clearTimeout(hideDelayTimer);
	      
	      // store the timer so that it can be cleared in the mouseover if required
	      hideDelayTimer = setTimeout(function () {
	        hideDelayTimer = null;
	        popup.animate({
	          top: '-=' + distance + 'px',
	          opacity: 0
	        }, time, 'swing', function () {
	          // once the animate is complete, set the tracker variables
	          shown = false;
	          // hide the popup entirely after the effect (opacity alone doesn't do the job)
	          popup.css('display', 'none');
	        });
	      }, hideDelay);
	    });
	  });
	});
}