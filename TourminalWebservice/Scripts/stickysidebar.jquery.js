(function($){

  var settings = {
        speed: 350 //animation duration
      , easing: "linear" //use easing plugin for more options
      , padding: 0
      , constrain: true
    }
    , $window = $(window)
    , stickyboxes = []
    , methods = {

          init:function(opts){
            settings = $.extend(settings,opts);
            return this.each(function () {
              var $this = $(this);
              setPosition($this);
              stickyboxes[stickyboxes.length] = $this;
              moveIntoView();
            });
          }

        , remove:function(){
            return this.each(function () {
              var sticky = this;
              $.each(stickyboxes, function (i, $sb) {
                if($sb.get(0) === sticky){
                reset(null, $sb);
                stickyboxes.splice(i, 1);
                return false;
                }
              });
            });
          }

        , destroy: function () {
            $.each(stickyboxes, function (i, $sb) {
              reset(null, $sb);
            });
            stickyboxes=[];
            $window.unbind("scroll", moveIntoView);
            $window.unbind("resize", reset);
            return this;
          }

      };


  var moveIntoView = function () {
    $.each(stickyboxes, function (i, $sb) {
      var $this = $sb
        , data = $this.data("stickySB");
      if (data) {
        var sTop = $window.scrollTop() - data.offs.top
          , currOffs = $this.offset()
          , origTop = data.orig.offset.top - data.offs.top
          , animTo = origTop;
        //scrolled down out of view
        if (origTop < sTop) {
          if (sTop > data.offs.bottom) //stop inside parent
            animTo = data.offs.bottom;
          else animTo = sTop + settings.padding;
        }
        $this
          .stop()
          .animate(
              {top: animTo}
            , settings.speed
            , settings.easing
        );
      }
    });
  }

  var setPosition = function ($sb) {
    if ($sb) {
      var $this = $sb
        , $parent = $(".three_columns_left") //$this.parent()
        , parentOffs = $parent.offset()
        , currOff = $this.offset()
        , data = $this.data("stickySB");
      if (!data) {
        data = {
            offs: {} // our parents offset
          , orig: { // cache for original css
                top: $this.css("top")
              , left: $this.css("left")
              , position: $this.css("position")
              , marginTop: $this.css("marginTop")
              , marginLeft: $this.css("marginLeft")
              , offset: $this.offset()
            }
        }
		//alert( $this.offset());
      }
      //go up the tree until we find an elem to position from
      while (parentOffs && "top" in parentOffs
        && $parent.css("position") == "static") {
        $parent = $parent.parent();
        parentOffs = $parent.offset();
      }
      if (parentOffs) { // found a postioned ancestor
        var padBtm = parseInt($parent.css("paddingBottom"));		
        padBtm = isNaN(padBtm) ? 0 : padBtm;
        data.offs = parentOffs;
		//alert($parent.innerHeight());
		//alert($parent.outerHeight());
		var headerHeight = $("#header").innerHeight() + $("#headermap").innerHeight() + $(".main_menu").innerHeight() - 400;
        data.offs.bottom = //3700;
          settings.constrain ?
          Math.abs(($(".three_columns_content").innerHeight() - padBtm) - $this.outerHeight() - headerHeight) :
          $(document).height();
      }
      else data.offs = { // went to far set to doc
          top: 0
        , left: 0
        , bottom: $(".three_columns_grid").offset().top()
      };
      $this.css({
          position: "absolute"
        , top: Math.floor(currOff.top - data.offs.top) + "px"
        , left: Math.floor(currOff.left - data.offs.left) + "px"
        , margin: 0
        , width: $this.width()
      }).data("stickySB", data);
    }
  }

  var reset = function (ev, $toReset) {
    var stickies = stickyboxes;
    if ($toReset) { // just resetting selected items
      stickies = [$toReset];
    }
    $.each(stickies, function(i, $sb) {
      var data = $sb.data("stickySB");
      if (data) {
        $sb.css({
            position: data.orig.position
          , marginTop: data.orig.marginTop
          , marginLeft: data.orig.marginLeft
          , left: data.orig.left
          , top: data.orig.top
        });
        if (!$toReset) { // just resetting
          setPosition($sb);
          moveIntoView();
        }
      }
    });
  }

  $window.bind("scroll", moveIntoView);
  $window.bind("resize", reset);

  $.fn.stickySidebar = function (method) {

    if (methods[method]) {
      return methods[method].apply(
          this
        , Array.prototype.slice.call(arguments, 1)
      );
    } else if (typeof method == "object") {
      return methods.init.apply(this, arguments);
    }

  }

})(jQuery);