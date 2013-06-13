<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/CountryDetails.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Регион <%= ViewData["RegionName"] %>, <%= ViewData["CountryName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript" src="../../Scripts/gmap3.js"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            if ("<%= ViewData["RegLatLng"].ToString()%>" != "[0,0]" ) { 
                $('#headermap').gmap3(
                    { action: 'init',
                        options: {
                            center: <%= ViewData["RegLatLng"]%>,
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            zoom: 6,
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
                    <%= ViewData["MarkersRegListHTML"] %>
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
                $("#headerArticle").css('height', '0px');
            }
        });
    </script>
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>"> <%=ViewData["CountryName"] %></a> <img src="../../Content/Images/greenarrow.png"/> <%=ViewData["RegionName"] %>
    </div>
    <h1>
        Регион: <%= ViewData["RegionName"] %>, <%= ViewData["CountryName"] %> 
        <% if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString()))) { %>
            <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="height: 30px;vertical-align: middle;" />
        <% } %>
    </h1>
    <%--<div id="divRegionCityList">--%>
    <% List<LinqToElcondor.TblCity> cts = Elcondor.UI.Utilities.DictionaryHelper.GetCityListData(int.Parse(ViewData["RegionId"].ToString()));
       bool isCapitalRegion = false;
       if (cts.Count > 0) {
           if (cts[0].IsCapital == false) {
               isCapitalRegion = true;
           }
       }
       if (isCapitalRegion) {
       %>
        <h2>Города региона:</h2>
        <div style="width: 100%;margin-bottom:20px;">
        <%  StringBuilder sb1 = new StringBuilder();
            sb1.Append("<ul style=\"padding-left:0 !important;margin-bottom: 10px !important;line-height: 1.0em !important;list-style:none;\">");
            foreach (LinqToElcondor.TblCity cty in cts) {
                sb1.Append(string.Format("<li style=\"padding-left: 3px;display: inline;\">&#x25E6; <a href=\"../../CityAbout?id={0}\" id=\"cty{0}\">{1} <span class=\"dc-icon\"></span></a></li>", cty.Id, cty.Name));
            }
            sb1.Append("</ul>");     
        %>
        <%= sb1.ToString()%>
        <%
       } %>
        </div>
    <% if (ViewData["Description"] != null) { %>
    <div id="divContentsLeft">
        <%if (ElcondorBiz.BizRegionRecreation.GetRegionRecreationCount(int.Parse(ViewData["RegionId"].ToString())) > 0) { %>
        <span class="divCountryRegionDesc">
            <h2>Достопримечательности:</h2>
            <%
              StringBuilder sb2 = new StringBuilder();
              sb2.Append("<ul style=\"margin-top:3px;\">");
              foreach (LinqToElcondor.TblRegionRecreation regrec in ElcondorBiz.BizRegionRecreation.GetListByRegionId(int.Parse(ViewData["RegionId"].ToString()))) {
                  sb2.Append(string.Format("<li><a href=\"../../RegionRecreationAbout?id={0}\">{1}</a></li>", regrec.Id, regrec.Name));
              }
              sb2.Append("</ul>");     
            %>
            <%= sb2.ToString() %>
        </span>
        <% } %>
        <%
           StringBuilder sb1 = new StringBuilder();
           sb1.Append("<ul style=\"margin-top:3px;\">");
           List<LinqToElcondor.TblCity> beaches = Elcondor.UI.Utilities.DictionaryHelper.GetBeachListData(int.Parse(ViewData["RegionId"].ToString()));
          if (beaches.Count() > 0) {
              foreach (LinqToElcondor.TblCity cty in beaches) {
                  sb1.Append(string.Format(
"<li><a href=\"../../CityAbout?id={0}\" style=\"text-decoration: none;font-weight:normal;\" id=\"cty{0}\">{1} </span></a></li>"
                  , cty.Id, cty.Name));
              }
              sb1.Append("</ul>");%>
              
        <span class="divCountryRegionDesc">
            <h2>Пляжи:</h2>
            <%= sb1.ToString() %>
          
        </span>
        <%} %>
        <h2>Общие сведения о <%if (isCapitalRegion) { %>регионе <%} %><%= ViewData["RegionName"] %></h2>        
        <p>
            <%=ViewData["Description"]%>
        </p>
    </div>
    <% } %>
    
   <%-- <div id="divCountryRegionDesc">        --%>
        
    <%--</div>--%>
    
</asp:Content>
