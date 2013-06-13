<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Словари
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Словари</h2>
    <br />
    <ul>
        <li><a href="/ArendaAdmin/CurrencyList">Валюта</a></li>
        <%--<li><a href="/ArendaAdmin/CountryList">Страны, города, регионы</a></li>--%>
        <li><a href="/ArendaAdmin/HotelServicesList">Сервисы отеля</li>

        <li><a href="/ArendaAdmin/DictHealthList">Медицина, здоровье, красота отеля</li>
        <li><a href="/ArendaAdmin/DictSportList">Спорт и развлечения отеля</li>
        <li><a href="/ArendaAdmin/DictForKidsList">Для детей в отеле</li>
        <li><a href="/ArendaAdmin/DictRestaurantList">Бары и рестораны отеля</li>

        <li><a href="/ArendaAdmin/HotelAmenitiesList">Удобства отеля</li>
        <li><a href="/ArendaAdmin/GoodForList">Список опций "Подходит для ..."</li>
        <li><a href="/ArendaAdmin/HotelTypeList">Типы отелей</li>
        <li><a href="/ArendaAdmin/RoomTypeList">Тип комнаты</li>
    </ul>
    <br /><br />
    <a href="/ArendaAdmin/Index">Вернуться назад</a>
</asp:Content>
