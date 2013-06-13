<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Панель администратора Tourminal
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnhome").addClass("selected");
        });
    </script>
    <h2>Панель администратора Tourminal</h2>
    <ul>
        <li><a href="/Admin/PageList">Статичные страницы сайта</a></li>
        <li><a href="/Admin/DictionaryList">Словари</a></li>
    </ul>
    <ul>
        <li><a href="/Admin/SightseeingList">Статьи</a></li>
        <li><a href="/Admin/TourList">Список туров</a></li>
        <li><a href="/Admin/ExcursList">Список  экскурсий</a></li>
        <li><a href="/Admin/ExcursCruise">Список  круизов</a></li>
    </ul>
    <ul>
        <li><a href="/Admin/AviaTicketList">Авиабилеты</a></li>
        <li><a href="/Admin/HotelList">Отели</a></li>
        
    </ul>
</asp:Content>
