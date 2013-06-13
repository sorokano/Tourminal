<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - <%= ViewData["PageTitle"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">        $(document).ready(function () { $('#regionMap').gmap3({ action: 'init', options: { center: [59.889136, 30.318716], mapTypeId: google.maps.MapTypeId.ROADMAP, zoom: 14} }, { action: 'addMarkers', markers: [{ lat: "59.889136", lng: "30.318716", options: { icon: "../../Content/images/flag_red.png" }, data: { content: ""}}], marker: { options: { draggable: false }, events: {}} }); function displayPoint(marker, data, map) { var scale = Math.pow(2, map.getZoom()); var nw = new google.maps.LatLng(map.getBounds().getNorthEast().lat(), map.getBounds().getSouthWest().lng()); var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw); var worldCoordinate = map.getProjection().fromLatLngToPoint(marker.getPosition()); var pixelOffset = new google.maps.Point(Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale), Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)); } }); </script>
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageContactsId %>);
        });
    </script>
    <span class="mainTitle">
        <h1><%= ViewData["PageTitle"] %></h1>
    </span>
    <table width="100%" cellspacing="1" cellpadding="1" border="0">
    <tbody>
        <tr>
            <td width="35%" style="vertical-align: top">
                <%= ViewData["PageContent"] %>
            </td>
            <td align="right" valign="top">
            <div id="regionMap">&nbsp;</div>
            </td>
        </tr>
    </tbody>
</table>
    
    

</asp:Content>
