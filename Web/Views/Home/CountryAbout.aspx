<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Country.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: О стране <%=ViewData["CountryName"] %> 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript" src="../../Scripts/gmap3.js"></script>
	<script type="text/javascript">
	    $(document).ready(function () {
            var param = "India";
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageOffersId %>);            
            var opts = {collapseTimer: 4000};
            $.expander.defaults.slicePoint = 220;
            $('div.expander').expander();

            $("#btncountrydesc").addClass("selected");

	        $('#headermap').gmap3(
                { action: 'init',
                    options: {
                        center: <%= ViewData["CapitalLatLng"]%>,
                        mapTypeId: google.maps.MapTypeId.ROADMAP,
                        zoom: 5,
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
	    });
    </script>
<script src='http://spiceupyourblogextras.googlecode.com/files/easing.js' type='text/javascript'/>
<script src='http://spiceupyourblogextras.googlecode.com/files/jquery.ui.totop.js' type='text/javascript'/>
<script type='text/javascript'>
$(document).ready(function() {
    $().UItoTop({ easingType: 'easeOutQuart' });
});
</script>
    <div class="navibar relover">
		<a href="http://tourminal.ru">Карта</a>
		<span class="navibar_sep"></span>
		<%=ViewData["CountryName"] %>
	</div>
    <div class="three_columns_content">
        <section class="country_maininfo">
			<h1><%=ViewData["CountryName"] %> <% if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString()))) { %> 
            <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="height: 30px;vertical-align: middle;" />
            <% } %></h1>
			<div class="country_cities">
				Города: 
				<%= ViewData["RegionCityListHTML"] %>
			</div>
			<p>
				<%= ViewData["CountryInfoContents"] %>
			</p>
		</section>
    </div>
    <div class="central_special_offers">
		Ознакомтесь с нашими <a href="">спецпредложениями</a> по стране <%=ViewData["CountryName"] %>
	</div>
            
   <%--<% if (int.Parse(ViewData["ArticleCount"].ToString()) > 0) { %>
    <div id="divArticleLinks">        
        <h3>Заметки путешественников</h3>
        <%=ViewData["GridArticleList"]%>
    </div>
    <% } %>--%>
</asp:Content>
