<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/CountryDetails.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Город <%= ViewData["CityName"] %>, <%= ViewData["RegionName"] %>, <%= ViewData["CountryName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript" src="../../Scripts/gmap3.js"></script>
    <script type="text/javascript" charset="utf-8">
        $.fn.infiniteCarousel = function () {
            function repeat(str, num) {
                return new Array(num + 1).join(str);
            }
            return this.each(function () {
                var $wrapper = $('> div', this).css('overflow', 'hidden'),
				$slider = $wrapper.find('> ul'),
				$items = $slider.find('> li'),
				$single = $items.filter(':first'),
                
				singleWidth = $single.outerWidth(),
				visible = Math.ceil($wrapper.innerWidth() / singleWidth), // note: doesn't include padding or border
				currentPage = 1,
				pages = Math.ceil($items.length / visible);


                // 1. Pad so that 'visible' number will always be seen, otherwise create empty items
                if (($items.length % visible) != 0) {
                    $slider.append(repeat('<li class="empty" />', visible - ($items.length % visible)));
                    $items = $slider.find('> li');
                }

                // 2. Top and tail the list with 'visible' number of items, top has the last section, and tail has the first
                $items.filter(':first').before($items.slice(-visible).clone().addClass('cloned'));
                $items.filter(':last').after($items.slice(0, visible).clone().addClass('cloned'));
                $items = $slider.find('> li'); // reselect

                // 3. Set the left position to the first 'real' item
                $wrapper.scrollLeft(singleWidth * visible);

                // 4. paging function
                function gotoPage(page) {
                    var dir = page < currentPage ? -1 : 1,
					n = Math.abs(currentPage - page),
					left = singleWidth * dir * visible * n;

                    $wrapper.filter(':not(:animated)').animate({
                        scrollLeft: '+=' + left
                    }, 500, function () {
                        if (page == 0) {
                            $wrapper.scrollLeft(singleWidth * visible * pages);
                            page = pages;
                        } else if (page > pages) {
                            $wrapper.scrollLeft(singleWidth * visible);
                            // reset back to start position
                            page = 1;
                        }

                        currentPage = page;
                    });

                    return false;
                }

                $wrapper.after('<a class="arrow back">&lt;</a><a class="arrow forward">&gt;</a>');

                // 5. Bind to the forward and back buttons
                $('a.back', this).click(function () {
                    return gotoPage(currentPage - 1);
                });

                $('a.forward', this).click(function () {
                    return gotoPage(currentPage + 1);
                });

                // create a public interface to move to a specific page
                $(this).bind('goto', function (event, page) {
                    gotoPage(page);
                });
            });
        };

        $(document).ready(function () {
            if ("<%= ViewData["CityLatLng"].ToString()%>" != "[0,0]" ) { 
                $('#headermap').gmap3(
                    { action: 'init',
                        options: {
                            center: <%= ViewData["CityLatLng"]%>,
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            zoom: 7,
                            mapTypeControl:true,
                            mapTypeControlOptions: {
                              style:google.maps.MapTypeControlStyle.DROPDOWN_MENU,
                              position:google.maps.ControlPosition.RIGHT_CENTER
                            },
                            zoomControl: true,
                            zoomControlOptions: {
                                style: google.maps.ZoomControlStyle.SMALL,
                                position: google.maps.ControlPosition.LEFT_CENTER
                            }
                        }
                    },
                    { action: 'addMarkers',
                        markers: [
                    <%= ViewData["MarkersCityListHTML"] %>
                    ],
                        marker: {
                            options: {
                                draggable: false
                            },
                            events: {
                                mouseover: function (marker, event, data) {
                                    var map = $(this).gmap3('get');
                                    displayPoint(marker, data.content, map);
                                },
                                mouseout: function () {
                                    $("#message").delay(15000).fadeOut(800);
                                },
                                click: function (marker, event, data) {
                                    location.href = data.weblink_text;
                                },
                            }
                        }
                    }
                );

	            function displayPoint(marker, data, map) {
	                var scale = Math.pow(2, map.getZoom());
	                var nw = new google.maps.LatLng(
                        map.getBounds().getNorthEast().lat(),
                        map.getBounds().getSouthWest().lng());

	                var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw);
	                var worldCoordinate = map.getProjection().fromLatLngToPoint(marker.getPosition());

	                var pixelOffset = new google.maps.Point(
                        Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
                        Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
                    );
	                $("#message").html(data);
	                $("#message").show().css({ top: pixelOffset.y, left: pixelOffset.x });
	            }
            } else {
                $("#headermap").css('height', '35px');
                $("#header").css('height', '10px');
            }
            $('.infiniteCarousel').infiniteCarousel();
            $("area[rel^='prettyPhoto']").prettyPhoto();
            $(".gallery:first a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'normal', theme: 'light_square', slideshow: 10000, autoplay_slideshow: true });
            $(".gallery:gt(0) a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'fast', slideshow: 10000, hideflash: true });

        });
    </script>
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>"> <%=ViewData["CountryName"] %></a> <img src="../../Content/Images/greenarrow.png"/> <a href="../../RegionAbout?id=<%= ViewData["RegionId"] %>"> <%=ViewData["RegionName"] %></a> <img src="../../Content/Images/greenarrow.png"/> <%= ViewData["CityName"] %>
    </div>
    <h1>
        <% if(Convert.ToBoolean(ViewData["CityIsBeach"].ToString())){ %>Пляж <%}else { %>Город <%} %> <%= ViewData["CityName"] %>, <%= ViewData["CountryName"] %> 
        <% if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString()))) { %>
            <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="height: 30px;vertical-align: middle;" />
        <% } %>
    </h1>
    <%--<div id="divRegionCityList">
        <h3>Общие сведения о городе</h3>--%>
        <p>
            <%= ViewData["CityDescription"] %>
        </p>


        <%List<LinqToElcondor.TblPhotoImage> items = ElcondorBiz.BizCity.GetCityImageGallery(int.Parse(ViewData["CityId"].ToString()));
                    if (items.Count > 0) { %>
        <h3>Фотоальбомы: <% if(Convert.ToBoolean(ViewData["CityIsBeach"].ToString())){ %>Пляж <%}else { %>Город <%} %> <%= ViewData["CityName"] %>, <%= ViewData["CountryName"] %></h3>
		<div style="width:740px;margin-bottom: 20px;">
            <h4 style="float:left;"></h4>
			<br/>
            
			<div style="width:650px;height:120px;margin:10px 0px;">
				<div class="infiniteCarousel">
					<div class="wrapper">
						<ul class="gallery clearfix">
                            <%
                                StringBuilder sb = new StringBuilder();
                                
                                foreach (LinqToElcondor.TblPhotoImage img in items) {
                                    sb.Append(string.Format("<li><a href=\"../../Content/UserImages/album_{0}_image_{1}.jpg\" rel=\"prettyPhoto[pp_gal]\" title=\"{2}\"><img src=\"../../Content/UserImages/album_{0}_image_{1}.jpg\" alt=\"\" height=\"100px\" ></a></li>"
                                                                , img.PhotoalbumId, img.Id, img.Description));
                                }
                                
                            %>
							<%= sb.ToString() %>
                        </ul>
					</div>
				</div>
			</div>
		</div>
        <% } %>

    <%--</div>--%>
</asp:Content>
