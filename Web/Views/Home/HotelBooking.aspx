<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Rent.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="CaptchaMvc.HtmlHelpers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Бронирование отеля: <%= ViewData["HotelName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" charset="utf-8">            
        $(document).ready(function () {			
            hideshow('loading', 0);	
            $("#datefrom").datepicker($.datepicker.regional['ru']);
            $("#dateto").datepicker($.datepicker.regional['ru']);
            $('#lblHotelname').text('<%= ViewData["HotelName"] %>');
            $('#txtId').val($.query.get("id"));
            $('#txtAdults').val($.query.get("adults"));
            $('#txtKids').val($.query.get("kids"));
            $('#datefrom').val($.query.get("datefrom"));
            $('#dateto').val($.query.get("dateto"));
            $('#txtMessage').val("Взрослых: " + $.query.get("adults") + ", детей: " + $.query.get("kids"));
        });
    </script>
    <div style="width: 90%;padding-left:10px;margin:10px 0 10px -30px;display:block;">
    <% using (Html.BeginForm("HotelBooking", "Home", FormMethod.Post)) { %>
        <%: Html.ValidationSummary(false, "Не удалось отправить данные для бронирования отеля. Исправьте ошибки и повторите попытку.") %>
        <h2>
            Бронирование отеля "<label id="lblHotelname">
            </label>" <%= Html.TextBox("txtId", string.Empty, new { style = "visibility:hidden" })%>
            <%= Html.TextBox("txtAdults", string.Empty, new { style = "visibility:hidden" })%>
            <%= Html.TextBox("txtKids", string.Empty, new { style = "visibility:hidden" })%>
        </h2>
        <div id="errorContact" class="error">&nbsp;</div>
        <table class="anketa">
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Фамилия, Имя, Отчество</td><td><%= Html.TextBox("txtName", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Контактный телефон</td><td><%= Html.TextBox("txtPersPhone", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td>Контактный email</td><td><%= Html.TextBox("txtEmail", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr>
                    <td><span style="color:red">*</span> 
                        Предполагаемые даты поездки
                    </td>
                    <td>
                        с
                        <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("datefrom", string.Empty, new { style = "width:100px" })%>
                        по
                        <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("dateto", string.Empty, new { style = "width:100px" })%>
                    </td>
                </tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td>Присоединить сообщение</td><td><%= Html.TextArea("txtMessage", string.Empty, 6, 70, new { name = "txtMessage" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td colspan="2">
                            <span style="color: #000; margin-bottom: 5px;">Введите текст на картинке:</span><br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            
                            <%= Html.Captcha("Обновить", "Ввести", 5, "Введите значение.")%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" id="btnsubmit"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="float: right;" value="Отправить запрос на бронирование" />
            </td>
        </tr>
    </table>
    <%} %>
    </div>
</asp:Content>
