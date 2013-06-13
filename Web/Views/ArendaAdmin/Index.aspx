<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Панель администратора
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Index</h2>
    Панель администратора
    <br />
    <ul>
        <li><a href="/ArendaAdmin/HotelList">Список отелей</a></li>
        <li><a href="/ArendaAdmin/DictionaryList">Словари</a></li>
        <li><a href="/ArendaAdmin/TicketManagement">Авиабилеты</a></li>
    </ul>
</asp:Content>
