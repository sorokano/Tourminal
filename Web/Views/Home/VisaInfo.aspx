<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="CaptchaMvc.HtmlHelpers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData["PageTitle"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#lastvisitdatefrom").datepicker($.datepicker.regional['ru']);
            $("#lastvisitdateto").datepicker($.datepicker.regional['ru']);
            $("#visitdatefrom").datepicker($.datepicker.regional['ru']);
        });
    </script>
   <%-- <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a>
        <img src="../../Content/Images/greenarrow.png" />
        <%= ViewData["PageTitle"] %>
    </div>--%>
    <span class="mainTitle">
        <h1><%= ViewData["PageTitle"] %> <img style="height: 30px;vertical-align: middle;" alt="" src="../../Content/UserImages/flag_9.jpg"></h1>
    </span>
    <p>
        <%= ViewData["PageContent"] %>
    </p>
    <% using (Html.BeginForm("VisaInfo", "Home", FormMethod.Post)) { %>
        <%: Html.ValidationSummary(false, "Не удалось отправить анкету. Исправьте ошибки и повторите попытку.") %>
        
        <table class="anketa">
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Фамилия, Имя, Отчество</td><td><%= Html.TextBox("txtFIO", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Контактный телефон</td><td><%= Html.TextBox("txtPersPhone", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> ФИО отца, матери, где они родились (достаточно области)</td><td><%= Html.TextBox("txtName", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Предыдущие фамилии (если имеются)</td><td><%= Html.TextBox("txtPrevName", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> ФИО мужа/жены</td><td><%= Html.TextBox("txtHusbandName", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Адрес  постоянный </td><td><%= Html.TextBox("txtAddress", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Номер мобильного телефона, номер рабочего телефона</td><td><%= Html.TextBox("txtPhone", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Электронная почта</td><td><%= Html.TextBox("txtEmail", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Место работы:  Название фирмы, должность , номер телефона и  адрес</td><td><%= Html.TextBox("txtJob", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Города в Индии, которые Вы посетили, .последний город и адрес. </td><td><%= Html.TextBox("txtCitiesVisited", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr>
                    <td><span style="color:red">*</span> 
                        Даты последнего визита в Индию, где была получена виза.  Номер визы и тип. Дата получения последней визы (копию визы, по возможности, нужно выслать на наш <a href="mailto:info@tourminal.ru">email</a>).
                    </td>
                    <td>
                        с
                        <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("lastvisitdatefrom", string.Empty, new { style = "width:100px" })%>
                        по
                        <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("lastvisitdateto", string.Empty, new { style = "width:100px" })%>
                    </td>
                </tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr>
                    <td><span style="color:red">*</span> 
                        Дата прибытия в Индию. Город прибытия
                    </td>
                    <td>
                        <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("visitdatefrom", string.Empty, new { style = "width:100px" })%>
                        <%= Html.TextBox("txtVisitCityName", string.Empty, new { style = "width:200px" })%>
                    </td>
                </tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Количество въездов (однократно/двукратно: укажите страну в которую будете выезжать: Непал или Шри-Ланка, даты заезда и выезда))</td><td><%= Html.TextBox("txtNumberOfEntries", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Страны , которые Вы посетили в течение 10 лет</td><td><%= Html.TextBox("txtVisitedCountryList", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td><span style="color:red">*</span> Гарант в Российской федерации ( ФИО адрес и телефон)</td><td><%= Html.TextBox("txtGarantInRF", string.Empty, new { style = "width:350px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td>
                <table><tr><td>Все поля обязательны для заполнения!</td></tr></table>
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
                <input type="submit" id="btnsubmit"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="float: right;" value="Отправить анкету" />
            </td>
        </tr>
    </table>
    <%} %>
</asp:Content>
